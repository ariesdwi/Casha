//
//  DependencyContainer.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//


import SwiftUI
import Domain
import Data
import Core

final class DependencyContainer {
    static let shared = DependencyContainer()

    // MARK: - Shared Dependencies
    private let remoteDataSource = TransactionRemoteDataSourceImpl(
        client: APIClient(baseURL: "https://api-daruma.selayangsurat.com/"),
        sessionUserID: "95eb84d2-0a32-4aef-b6c2-bfb5bbc686f5",
        authorizationToken: "ZG9ydW1hOlFYSnExMVFiRFA=" // TODO: secure
    )

    private let transactionRepository: TransactionRepositoryImpl
    private let categoryRepository: CategoryRepositoryImpl

    private init() {
        let persistence = TransactionPersistence()
        let query = TransactionQuery()
        let analytics = TransactionAnalytics()

        transactionRepository = TransactionRepositoryImpl(
            query: query,
            analytics: analytics,
            persistence: persistence
        )

        categoryRepository = CategoryRepositoryImpl(analytics: CategoryAnalytics())
    }

    // MARK: - States
    func makeDashboardState() -> DashboardState {
        DashboardState(
            getRecentTransactions: GetRecentTransactionsUseCase(repository: transactionRepository),
            getTotalSpending: GetTotalSpendingUseCase(repository: transactionRepository),
            getSpendingReport: GetSpendingReportUseCase(repository: transactionRepository),
            transactionSyncManager: TransactionSyncManager(
                remoteDataSource: remoteDataSource,
                repository: transactionRepository
            )
        )
    }

    func makeTransactionListState() -> TransactionListState {
        TransactionListState(
            getTransactionsByPeriod: GetTransactionsByPeriodUseCase(repository: transactionRepository),
            searchTransactions: SearchTransactionsUseCase(repository: transactionRepository)
        )
    }

    func makeReportState() -> ReportState {
        ReportState(
            getCategorySpendingUseCase: GetCategorySpendingUseCase(repository: categoryRepository)
        )
    }
}
