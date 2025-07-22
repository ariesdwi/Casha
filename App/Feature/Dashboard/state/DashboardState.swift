//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import Foundation
import Domain
import Data
import Core

final class DashboardState: ObservableObject {
    @Published var recentTransactions: [TransactionCasha] = []
    @Published var totalSpending: Double = 0.0
    @Published var report: SpendingReport = .init(thisPeriod: 0, lastPeriod: 0)

    private let getRecentTransactions = GetRecentTransactionsUseCase(
        repository: TransactionRepositoryImpl()
    )
    
    private let getTotalSpending = GetTotalSpendingUseCase(
        repository: TransactionRepositoryImpl()
    )
    
    private let getSpendingReport = GetSpendingReportUseCase(
        repository: TransactionRepositoryImpl()
    )

    @MainActor
    func loadData() {
        Task {
            async let recentTransactionsTask = getRecentTransactions.execute(limit: 5)
            async let totalSpendingTask = getTotalSpending.execute()
            async let spendingReportTask = getSpendingReport.execute(period: .week)
            
            let (transactions, spending, reportResults) = await (
                recentTransactionsTask,
                totalSpendingTask,
                spendingReportTask
            )
            
            self.recentTransactions = transactions
            self.totalSpending = spending
            if let result = reportResults.first {
                self.report = result
            }
        }
    }
    
    func addDummyData() async {
        let dummyTransactions = TransactionDummyGenerator.generate(count: 10)

        for model in dummyTransactions {
            try await TransactionRepositoryImpl().addTransaction(model)
        }

    }

}

