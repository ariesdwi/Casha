//
//  TransactionRepository.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//


import Core
import Foundation
import Domain

public final class TransactionRepositoryImpl: TransactionRepositoryProtocol {
    private let localDataSource: TransactionLocalDataSource

    public init(localDataSource: TransactionLocalDataSource) {
        self.localDataSource = localDataSource
    }

    public func addTransaction(_ transaction: TransactionCasha) async throws {
        try localDataSource.save(transaction)
    }

    public func fetchRecentTransactions(limit: Int) -> [TransactionCasha] {
        do {
            return try localDataSource.fetch(limit: limit)
        } catch {
            print("❌ Failed to fetch recent transactions: \(error)")
            return []
        }
    }

    public func fetchTotalSpending() -> Double {
        do {
            let all = try localDataSource.fetchAll()
            return all.reduce(0) { $0 + $1.amount }
        } catch {
            print("❌ Failed to calculate total spending: \(error)")
            return 0
        }
    }

    public func fetchSpendingReport(period: ReportPeriod) -> [SpendingReport] {
        do {
            let report = try localDataSource.fetchSpendingReport(period: period)
            return [report]
        } catch {
            print("❌ Failed to fetch spending report: \(error)")
            return []
        }
    }

    public func fetchAllTransactions() async -> [TransactionCasha] {
        do {
            return try localDataSource.fetchAll()
        } catch {
            print("❌ Failed to fetch all transactions: \(error)")
            return []
        }
    }
}

