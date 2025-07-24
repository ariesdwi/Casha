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
//        let dummyDataSource = CoreDataTransactionPersistence()
//        dummyDataSource.addDummyTransactions(count: 100)
    }
    
    var body: some Scene {
        WindowGroup {
            let persistenceDataSource = CoreDataTransactionPersistence()
            let queryDataSource = CoreDataTransactionQuery()
            let analyticsDataSource = CoreDataTransactionAnalytics()
            
            
            // 🔌 Inject all data sources into repository
            let repository = TransactionRepositoryImpl(
                query: queryDataSource,
                analytics: analyticsDataSource,
                persistence: persistenceDataSource
            )
            
            let remoteDataSource = TransactionRemoteDataSourceImpl (
                client: APIClient(baseURL: "https://api-daruma.selayangsurat.com/"),
                sessionUserID: "95eb84d2-0a32-4aef-b6c2-bfb5bbc686f5", // TODO: Replace with real session management
                authorizationToken: "ZG9ydW1hOlFYSnExMVFiRFA=" // TODO: Secure from Keychain or LoginSession
            )

            let syncManager = TransactionSyncManager(
                remoteDataSource: remoteDataSource,
                repository: repository
            )
            
            let dashboardState = DashboardState(
                getRecentTransactions: GetRecentTransactionsUseCase(repository: repository),
                getTotalSpending: GetTotalSpendingUseCase(repository: repository),
                getSpendingReport: GetSpendingReportUseCase(repository: repository), transactionSyncManager: syncManager
            )
            
            // Transaction list state
            let transactionListState = TransactionListState(
                getTransactionsByPeriod: GetTransactionsByPeriodUseCase(repository: repository),
                searchTransactions: SearchTransactionsUseCase(repository: repository)
            )
            
            SplashView()
                .environmentObject(dashboardState)
                .environmentObject(transactionListState)
            
        }
    }
}
