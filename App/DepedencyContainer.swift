
//
//  DependencyContainer.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//

import Foundation
import Domain
import Data
import Core
import SwiftUI

@MainActor
final class DependencyContainer {
    static let shared = DependencyContainer()
    
    private init() {} // Prevent external initialization
    
    // MARK: - Configuration
    private let baseURL = "https://5eb6f0c0cd97.ngrok-free.app/"
    private let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
    
    // TODO: Move to secure storage (Keychain)
    private let authToken: () -> String = {
        AuthManager.shared.getToken() ?? ""
    }
    //    private let authToken = AuthManager.shared.getToken() ?? ""
    
    // MARK: - API Client (Singleton)
    private lazy var apiClient: APIClient = {
        APIClient(baseURL: baseURL)
    }()
    
    // MARK: - Data Sources
    private lazy var remoteDataSource: TransactionRemoteDataSourceImpl = {
        TransactionRemoteDataSourceImpl(
            client: apiClient,
            sessionUserID: deviceUUID,
            authorizationToken: authToken()
        )
    }()
    
    private lazy var budgetRemoteDataSource: BudgetRemoteDataSourceImpl = {
        BudgetRemoteDataSourceImpl(
            client: apiClient,
            sessionUserID: deviceUUID,
            authorizationToken: authToken()
        )
    }()
    
    private lazy var profileRemoteDataSource: AuthRemoteDataSourceImpl = {
        AuthRemoteDataSourceImpl(
            client: apiClient,
            sessionUserID: deviceUUID,
            authorizationToken: AuthManager.shared.getToken() ?? ""
        )
    }()
    
    private lazy var loginRemoteDataSource: AuthRemoteDataSourceImpl = {
        AuthRemoteDataSourceImpl(
            client: apiClient,
            sessionUserID: deviceUUID,
            authorizationToken: AuthManager.shared.getToken() ?? ""
        )
    }()
    
    private lazy var persistenceDataSource: TransactionPersistence = {
        TransactionPersistence()
    }()
    
    private lazy var queryDataSource: TransactionQuery = {
        TransactionQuery()
    }()
    
    private lazy var analyticsDataSource: TransactionAnalytics = {
        TransactionAnalytics()
    }()
    
    // MARK: - Repositories
    private lazy var transactionRepository: TransactionRepositoryImpl = {
        TransactionRepositoryImpl(
            query: queryDataSource,
            analytics: analyticsDataSource,
            persistence: persistenceDataSource
        )
    }()
    
    private lazy var categoryRepository: CategoryRepositoryImpl = {
        CategoryRepositoryImpl(analytics: CategoryAnalytics())
    }()
    
    // MARK: - Sync Manager
    private lazy var syncManager: TransactionSyncManager = {
        TransactionSyncManager(
            remoteDataSource: remoteDataSource,
            repository: transactionRepository
        )
    }()
    
    // MARK: - Use Cases
    private lazy var getRecentTransactions: GetRecentTransactionsUseCase = {
        GetRecentTransactionsUseCase(repository: transactionRepository)
    }()
    
    private lazy var getTotalSpending: GetTotalSpendingUseCase = {
        GetTotalSpendingUseCase(repository: transactionRepository)
    }()
    
    private lazy var getSpendingReport: GetSpendingReportUseCase = {
        GetSpendingReportUseCase(repository: transactionRepository)
    }()
    
    private lazy var getTransactionsByPeriod: GetTransactionsByPeriodUseCase = {
        GetTransactionsByPeriodUseCase(repository: transactionRepository)
    }()
    
    private lazy var searchTransactions: SearchTransactionsUseCase = {
        SearchTransactionsUseCase(repository: transactionRepository)
    }()
    
    private lazy var getCategorySpending: GetCategorySpendingUseCase = {
        GetCategorySpendingUseCase(repository: categoryRepository)
    }()
    
    private lazy var getAllBudget: GetAllBudgetUseCase = {
        GetAllBudgetUseCase(repository: budgetRemoteDataSource)
    }()
    
    private lazy var addBudget: AddBudgetUseCase = {
        AddBudgetUseCase(repository: budgetRemoteDataSource)
    }()
    
    private lazy var getTotalSummaryBudget: GetTotalSummaryBudget = {
        GetTotalSummaryBudget(repository: budgetRemoteDataSource)
    }()
    
    private lazy var getProfile: GetProfileUsecase = {
        
        GetProfileUsecase(repository: profileRemoteDataSource)
        
    }()
    
    private lazy var loginUseCase: LoginUseCase = {
        LoginUseCase(repository: loginRemoteDataSource)
    }()
    
    private lazy var networkMonitor: NetworkMonitorProtocol = {
        let monitor = NetworkMonitor()
        monitor.startMonitoring()
        return monitor
    }()
    
    // MARK: - State Objects Factory Methods
    nonisolated func makeDashboardState() -> DashboardState {
        MainActor.assumeIsolated {
            DashboardState(
                getRecentTransactions: getRecentTransactions,
                getTotalSpending: getTotalSpending,
                getSpendingReport: getSpendingReport,
                transactionSyncManager: syncManager,
                networkMonitor: networkMonitor
            )
        }
    }
    
    nonisolated func makeTransactionListState() -> TransactionListState {
        MainActor.assumeIsolated {
            TransactionListState(
                getTransactionsByPeriod: getTransactionsByPeriod,
                searchTransactions: searchTransactions
            )
        }
    }
    
    nonisolated func makeReportState() -> ReportState {
        MainActor.assumeIsolated {
            ReportState(getCategorySpendingUseCase: getCategorySpending)
        }
    }
    
    nonisolated func makeBudgetState() -> BudgetState {
        MainActor.assumeIsolated {
            BudgetState(
                fetchUseCase: getAllBudget,
                addBudgetUseCase: addBudget,
                getTotalSummaryBudget: getTotalSummaryBudget
            )
        }
    }
    
    nonisolated func makeProfileState() -> ProfileState {
        MainActor.assumeIsolated {
            ProfileState(getProfileUsecase: getProfile)
        }
    }
    
    nonisolated func makeLoginState() -> LoginState {
        MainActor.assumeIsolated {
            LoginState(
                loginUsecase: loginUseCase,
                transactionSyncManager: syncManager
            )
        }
    }
}
