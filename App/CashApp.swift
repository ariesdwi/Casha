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
//        let dummyDataSource = TransactionPersistence()
//        dummyDataSource.addDummyTransactions(count: 100)
    }
    
    var body: some Scene {
        WindowGroup {

            let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"

            let remoteDataSource = TransactionRemoteDataSourceImpl (
                client: APIClient(baseURL: "https://750c262edbca.ngrok-free.app/"),
                sessionUserID: deviceUUID, // TODO: Replace with real session management
                authorizationToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxYzYwYWFiYy02Y2Y0LTRjNWItYTc0OC0zZWNkMDViMzBiOTMiLCJlbWFpbCI6InRlc3RAZXhhbXBsZS5jb20iLCJpYXQiOjE3NTU3NTU0NDQsImV4cCI6MTc1NjM2MDI0NH0.sHPrBaNtIrsluhODd2suS9POk3vmL8Vd3QTTDVEhjM4" // TODO: Secure from Keychain or LoginSession
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
