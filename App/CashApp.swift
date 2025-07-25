//
//  App.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//

import SwiftUI
import Domain
import Data
import Core

@main
struct CashaApp: App {
    init() {
        // ⚠️ FOR DEBUGGING ONLY
        let dummyDataSource = TransactionPersistence()
        dummyDataSource.addDummyTransactions(count: 100)
    }
    
    var body: some Scene {
        WindowGroup {
            let remoteDataSource = TransactionRemoteDataSourceImpl (
                client: APIClient(baseURL: "https://api-daruma.selayangsurat.com/"),
                sessionUserID: "95eb84d2-0a32-4aef-b6c2-bfb5bbc686f5", // TODO: Replace with real session management
                authorizationToken: "ZG9ydW1hOlFYSnExMVFiRFA=" // TODO: Secure from Keychain or LoginSession
            )
            
            let persistenceDataSource = TransactionPersistence()
            let queryDataSource = TransactionQuery()
            let analyticsDataSource = TransactionAnalytics()
            
            // 🔌 Inject all data sources into repository
            let transactionRepository = TransactionRepositoryImpl(
                query: queryDataSource,
                analytics: analyticsDataSource,
                persistence: persistenceDataSource
            )
            
           
            

            let syncManager = TransactionSyncManager(
                remoteDataSource: remoteDataSource,
                repository: transactionRepository
            )
            
            let dashboardState = DashboardState(
                getRecentTransactions: GetRecentTransactionsUseCase(repository: transactionRepository),
                getTotalSpending: GetTotalSpendingUseCase(repository: transactionRepository),
                getSpendingReport: GetSpendingReportUseCase(repository: transactionRepository), transactionSyncManager: syncManager
            )
            
           
            
            // Transaction list state
            let transactionListState = TransactionListState(
                getTransactionsByPeriod: GetTransactionsByPeriodUseCase(repository: transactionRepository),
                searchTransactions: SearchTransactionsUseCase(repository: transactionRepository)
            )
            
            let categoryRepository = CategoryRepositoryImpl( analytics: CategoryAnalytics())
            let reportState = ReportState(getCategorySpendingUseCase: GetCategorySpendingUseCase(repository: categoryRepository))
            
            SplashView()
                .environmentObject(dashboardState)
                .environmentObject(transactionListState)
                .environmentObject(reportState)
            
        }
    }
}
