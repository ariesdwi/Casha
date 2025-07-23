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
        //        let dummyDataSource = CoreDataTransactionLocalDataSource()
        //        dummyDataSource.addDummyTransactions(count: 20)
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
           
            let dashboardState = DashboardState(
                getRecentTransactions: GetRecentTransactionsUseCase(repository: repository),
                getTotalSpending: GetTotalSpendingUseCase(repository: repository),
                getSpendingReport: GetSpendingReportUseCase(repository: repository)
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
