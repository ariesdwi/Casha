//
//  CategoryRepositoryImpl.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//


import Foundation
import Domain

public final class CategoryRepositoryImpl: CategoryRepositoryProtocol {
   
    
//    private let query: CategoryQueryDataSource
    private let analytics: CategoryAnalyticsDataSource
//    private let persistence: CategoryPersistenceDataSource

    public init(
//        query: CategoryQueryDataSource? = nil,
        analytics: CategoryAnalyticsDataSource
//        persistence: CategoryPersistenceDataSource
    ) {
//        self.query = query
        self.analytics = analytics
//        self.persistence = persistence
    }

    public func fetchCategorySpending(startDate: Date, endDate: Date) -> [Domain.ChartCategorySpending] {
        do {
            return try analytics.fetchCategorySpending(startDate: startDate, endDate: endDate)
        } catch {
            print("❌ Failed to fetch category spending: \(error)")
            return []
        }
    }
}
