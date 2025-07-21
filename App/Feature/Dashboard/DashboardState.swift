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

    func loadData() {
        Task {
            self.recentTransactions = await getRecentTransactions.execute(limit: 5)
            self.totalSpending = await getTotalSpending.execute()
            if let result = await getSpendingReport.execute(period: .week).first {
                self.report = result
            }

        }
    }
    
    func injectDummyTransactions() {
        let repo = TransactionRepositoryImpl()

        let dummyTransactions: [TransactionCasha] = [
            TransactionCasha(
                id: UUID().uuidString,
                name: "Starbucks",
                category: "Food & Beverage",
                amount: 45000,
                datetime: Date(),
                isConfirm: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            TransactionCasha(
                id: UUID().uuidString,
                name: "Grab",
                category: "Transportation",
                amount: 22000,
                datetime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                isConfirm: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            TransactionCasha(
                id: UUID().uuidString,
                name: "Indomaret",
                category: "Groceries",
                amount: 78000,
                datetime: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                isConfirm: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            TransactionCasha(
                id: UUID().uuidString,
                name: "Netflix",
                category: "Entertainment",
                amount: 169000,
                datetime: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                isConfirm: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            TransactionCasha(
                id: UUID().uuidString,
                name: "Pulsa Telkomsel",
                category: "Utilities",
                amount: 50000,
                datetime: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                isConfirm: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
        ]

        Task {
            for transaction in dummyTransactions {
                do {
                    try await repo.addTransaction(transaction)
                    print("✅ Injected: \(transaction.name)")
                } catch {
                    print("❌ Failed to inject \(transaction.name): \(error)")
                }
            }
        }
    }
    
    func injectDummyTransactionsIfNeeded() {
        let injected = UserDefaults.standard.bool(forKey: "didInjectDummy")
        guard !injected else { return }

        injectDummyTransactions()
        UserDefaults.standard.set(true, forKey: "didInjectDummy")
    }



}
