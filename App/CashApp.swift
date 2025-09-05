//
//  App.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//
//
//import SwiftUI
//
//import Domain
//import Data
//import Core
//
//@main
//struct CashaApp: App {
//    init() {
//        // ⚠️ FOR DEBUGGING ONLY
//        //        let dummyDataSource = TransactionPersistence()
//        //        dummyDataSource.addDummyTransactions(count: 100)
//    }
//    
//    var body: some Scene {
//        WindowGroup {
//            
//            let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
//            
//            let remoteDataSource = TransactionRemoteDataSourceImpl (
//                client: APIClient(baseURL: "https://5eb6f0c0cd97.ngrok-free.app/"),
//                sessionUserID: deviceUUID, // TODO: Replace with real session management
//                authorizationToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkOTE2NzU1Mi04ZGYyLTQwNTQtODI2OS01MGUyZWEwZjNhYmYiLCJlbWFpbCI6InRlc3QzQGV4YW1wbGUuY29tIiwiaWF0IjoxNzU2OTU0MzY4LCJleHAiOjE3NjIxMzgzNjh9.eFWa6Ie6EbJNDzZ6-BHcjJlMYpIs0YXG-v5DaLThstg" // TODO: Secure from Keychain or LoginSession
//            )
//            
//            // MARK: Budget setup
//            let budgetRemoteDataSource = BudgetRemoteDataSourceImpl(
//                client: APIClient(baseURL: "https://5eb6f0c0cd97.ngrok-free.app/"),
//                sessionUserID: deviceUUID,
//                authorizationToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkOTE2NzU1Mi04ZGYyLTQwNTQtODI2OS01MGUyZWEwZjNhYmYiLCJlbWFpbCI6InRlc3QzQGV4YW1wbGUuY29tIiwiaWF0IjoxNzU2OTU0MzY4LCJleHAiOjE3NjIxMzgzNjh9.eFWa6Ie6EbJNDzZ6-BHcjJlMYpIs0YXG-v5DaLThstg"
//            )
//            
//            // MARK: Profile setup
//            let profileRemoteDataSource = ProfileRemoteDataSourceImpl(
//                client: APIClient(baseURL: "https://5eb6f0c0cd97.ngrok-free.app/"),
//                sessionUserID: deviceUUID,
//                authorizationToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkOTE2NzU1Mi04ZGYyLTQwNTQtODI2OS01MGUyZWEwZjNhYmYiLCJlbWFpbCI6InRlc3QzQGV4YW1wbGUuY29tIiwiaWF0IjoxNzU2OTU0MzY4LCJleHAiOjE3NjIxMzgzNjh9.eFWa6Ie6EbJNDzZ6-BHcjJlMYpIs0YXG-v5DaLThstg"
//            )
//            
//            let persistenceDataSource = TransactionPersistence()
//            let queryDataSource = TransactionQuery()
//            let analyticsDataSource = TransactionAnalytics()
//            
//            // 🔌 Inject all data sources into repository
//            let transactionRepository = TransactionRepositoryImpl(
//                query: queryDataSource,
//                analytics: analyticsDataSource,
//                persistence: persistenceDataSource
//            )
//            
//            let syncManager = TransactionSyncManager(
//                remoteDataSource: remoteDataSource,
//                repository: transactionRepository
//            )
//            
//            // Transaction list stat
//            let categoryRepository = CategoryRepositoryImpl( analytics: CategoryAnalytics())
//            
//            let dashboardState = DashboardState(
//                getRecentTransactions: GetRecentTransactionsUseCase(repository: transactionRepository),
//                getTotalSpending: GetTotalSpendingUseCase(repository: transactionRepository),
//                getSpendingReport: GetSpendingReportUseCase(repository: transactionRepository), transactionSyncManager: syncManager
//            )
//            let transactionListState = TransactionListState(
//                getTransactionsByPeriod: GetTransactionsByPeriodUseCase(repository: transactionRepository),
//                searchTransactions: SearchTransactionsUseCase(repository: transactionRepository)
//            )
//            let reportState = ReportState(getCategorySpendingUseCase: GetCategorySpendingUseCase(repository: categoryRepository))
//            
//            let budgetState = BudgetState(
//                fetchUseCase: GetAllBudgetUseCase(repository: budgetRemoteDataSource),
//                addBudgetUseCase: AddBudgetUseCase(repository: budgetRemoteDataSource), getTotalSummaryBudget: GetTotalSummaryBudget(repository: budgetRemoteDataSource)
//            )
//            let profileState = ProfileState(getProfileUsecase: GetProfileUsecase(repository: profileRemoteDataSource))
//            
//            SplashView()
//                .environmentObject(dashboardState)
//                .environmentObject(transactionListState)
//                .environmentObject(reportState)
//                .environmentObject(budgetState)
//                .environmentObject(profileState)
//            
//        }
//    }
//}

//@main
//struct CashaApp: App {
//    let container = DependencyContainer.shared
//
//    var body: some Scene {
//        WindowGroup {
//            SplashView()
//                .environmentObject(container.makeDashboardState())
//                .environmentObject(container.makeTransactionListState())
//                .environmentObject(container.makeReportState())
//        }
//    }
//}


import SwiftUI
import Domain
import Data
import Core

@main
struct CashaApp: App {
    private let container = DependencyContainer.shared
    
    init() {
        setupApp()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                // Using environment objects (traditional approach)
                .environmentObject(container.makeDashboardState())
                .environmentObject(container.makeTransactionListState())
                .environmentObject(container.makeReportState())
                .environmentObject(container.makeBudgetState())
                .environmentObject(container.makeProfileState())
                
                // Alternative: Using environment values (more SwiftUI-like)
                .environment(\.dashboardState, container.makeDashboardState())
                .environment(\.transactionListState, container.makeTransactionListState())
                .environment(\.reportState, container.makeReportState())
                .environment(\.budgetState, container.makeBudgetState())
                .environment(\.profileState, container.makeProfileState())
        }
    }
    
    private func setupApp() {
        // App-wide configuration
        configureAppearance()
        
        #if DEBUG
        DebugTools.printEnvironmentInfo()
        
        // Uncomment to add dummy data for debugging
        // DebugTools.addDummyTransactions(count: 50)
        #endif
    }
    
    private func configureAppearance() {
        // Global UI configuration
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .clear
        
        // Navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
