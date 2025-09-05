//
//  TransactionLocalDataSource.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import Domain

public protocol TransactionPersistenceDataSource {
    func save(_ transaction: TransactionCasha) throws
    func update(_ transaction: TransactionCasha) throws
    func delete(byId id: String) throws
    func deleteAll() throws
    func markAsSynced(transactionId: String, remoteData: TransactionCasha) throws
}

public protocol TransactionQueryDataSource {
    func fetchAll() throws -> [TransactionCasha]
    func fetch(limit: Int) throws -> [TransactionCasha]
    func fetch(startDate: Date, endDate: Date?) throws -> [TransactionCasha]
    func search(query: String) throws -> [TransactionCasha]
    func fetchUnsyncedTransactions() throws -> [TransactionCasha]
    func fetchUnsyncedTransactionsCount() throws -> Int
    
}

public protocol TransactionAnalyticsDataSource {
    func fetchSpendingReport() throws -> SpendingReport
}
