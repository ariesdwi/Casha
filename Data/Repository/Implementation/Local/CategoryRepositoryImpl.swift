//
//  CategoryRepositoryImpl.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//


import Foundation
import Domain

public final class CategoryRepositoryImpl: LocalCategoryRepositoryProtocol {
    private let analytics: CategoryAnalyticsDataSource
    
    public init(
        analytics: CategoryAnalyticsDataSource
    ) {
        self.analytics = analytics
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
