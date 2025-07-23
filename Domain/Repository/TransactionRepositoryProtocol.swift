//
//  TransactionRepositoryProtocol.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import Foundation

public protocol TransactionRepositoryProtocol {
    func addTransaction(_ transaction: TransactionCasha) async throws
    func fetchRecentTransactions(limit: Int) -> [TransactionCasha]
    func fetchTotalSpending() -> Double
    func fetchSpendingReport(period: ReportPeriod) -> [SpendingReport]
    func fetchAllTransactions() async -> [TransactionCasha]
    func searchTransactions(query: String) async -> [TransactionCasha]
    func fetchTransactions(startDate: Date, endDate: Date?) async -> [TransactionCasha]
}
