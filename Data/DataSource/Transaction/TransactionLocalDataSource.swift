//
//  TransactionLocalDataSource.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import CoreData
import Domain

public protocol TransactionLocalDataSource {
    func save(_ transaction: TransactionCasha) throws
    func fetchAll() throws -> [TransactionCasha]
    func fetch(limit: Int) throws -> [TransactionCasha]
    func fetchSpendingReport(period: ReportPeriod) throws -> SpendingReport
    func delete(byId id: String) throws
    func deleteAll() throws
}
