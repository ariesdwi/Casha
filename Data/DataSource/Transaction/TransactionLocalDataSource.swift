//
//  TransactionLocalDataSource.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import CoreData
import Domain

public protocol TransactionPersistenceDataSource {
    func save(_ transaction: TransactionCasha) throws
    func delete(byId id: String) throws
    func deleteAll() throws
}

public protocol TransactionQueryDataSource {
    func fetchAll() throws -> [TransactionCasha]
    func fetch(limit: Int) throws -> [TransactionCasha]
    func fetch(startDate: Date, endDate: Date?) throws -> [TransactionCasha]
    func search(query: String) throws -> [TransactionCasha]
}

public protocol TransactionAnalyticsDataSource {
    func fetchSpendingReport(period: ReportPeriod) throws -> SpendingReport
}
