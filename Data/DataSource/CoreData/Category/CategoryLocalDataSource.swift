//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import Domain
import CoreData

public protocol CategoryQueryDataSource {
    func fetchAll() throws -> [CategoryCasha]
}

public protocol CategoryAnalyticsDataSource {
    func fetchCategorySpending(startDate: Date, endDate: Date) throws -> [ChartCategorySpending]
}

public protocol CategoryPersistenceDataSource {
    func save(_ category: CategoryCasha) throws
    func deleteAll() throws
    func exists(id: String) throws -> Bool
}
