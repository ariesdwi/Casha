//
//  TransactionRepository.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//


import Foundation
import Domain

public final class TransactionRepositoryImpl: TransactionRepositoryProtocol {
    private let query: TransactionQueryDataSource
    private let analytics: TransactionAnalyticsDataSource
    private let persistence: TransactionPersistenceDataSource

    public init(
        query: TransactionQueryDataSource,
        analytics: TransactionAnalyticsDataSource,
        persistence: TransactionPersistenceDataSource
    ) {
        self.query = query
        self.analytics = analytics
        self.persistence = persistence
    }

    public func addTransaction(_ transaction: TransactionCasha) async throws {
        try persistence.save(transaction)
    }

    public func fetchRecentTransactions(limit: Int) -> [TransactionCasha] {
        do {
            return try query.fetch(limit: limit)
        } catch {
            print("❌ Failed to fetch recent transactions: \(error)")
            return []
        }
    }

    public func fetchTotalSpending() -> Double {
        do {
            let all = try query.fetchAll()
            return all.reduce(0) { $0 + $1.amount }
        } catch {
            print("❌ Failed to calculate total spending: \(error)")
            return 0
        }
    }

    public func fetchSpendingReport() -> [SpendingReport] {
        do {
            let report = try analytics.fetchSpendingReport()
            return [report]
        } catch {
            print("❌ Failed to fetch spending report: \(error)")
            return []
        }
    }

    public func fetchAllTransactions() async -> [TransactionCasha] {
        do {
            return try query.fetchAll()
        } catch {
            print("❌ Failed to fetch all transactions: \(error)")
            return []
        }
    }
    
    public func fetchTransactions(startDate: Date, endDate: Date?) async -> [TransactionCasha] {
          do {
              return try query.fetch(startDate: startDate, endDate: endDate)
          } catch {
              print("Error fetching transactions by period: \(error)")
              return []
          }
      }

      public func searchTransactions(text: String) async -> [TransactionCasha] {
          do {
              return try query.search(query: text)
          } catch {
              print("Error searching transactions: \(error)")
              return []
          }
      }
    
    public func mergeTransactions(_ remoteTransactions: [TransactionCasha]) async throws {
        let localTransactions = try query.fetchAll()
        let localDict = Dictionary(uniqueKeysWithValues: localTransactions.map { ($0.id, $0) })

        var toInsert: [TransactionCasha] = []
        var toUpdate: [TransactionCasha] = []

        for remote in remoteTransactions {
            if let local = localDict[remote.id] {
                if remote != local {
                    toUpdate.append(remote)
                }
            } else {
                toInsert.append(remote)
            }
        }

        // Save new transactions
        for transaction in toInsert {
            try persistence.save(transaction)
        }

        // Update existing transactions
        for transaction in toUpdate {
            try persistence.update(transaction)
        }
    }

}

