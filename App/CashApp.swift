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
            let localDataSource = CoreDataTransactionLocalDataSource()
            let repository = TransactionRepositoryImpl(localDataSource: localDataSource)
            
            let dashboardState = DashboardState(
                getRecentTransactions: GetRecentTransactionsUseCase(repository: repository),
                getTotalSpending: GetTotalSpendingUseCase(repository: repository),
                getSpendingReport: GetSpendingReportUseCase(repository: repository)
            )
            
            let getTransactionsByPeriod = GetTransactionsByPeriodUseCase(repository: repository)
            let searchTransactions = SearchTransactionsUseCase(repository: repository)

            // Transaction list state
            let transactionListState = TransactionListState(
                getTransactionsByPeriod: getTransactionsByPeriod,
                searchTransactions: searchTransactions
            )
            
            SplashView()
                .environmentObject(dashboardState)
                .environmentObject(transactionListState)
            
        }
    }
}
