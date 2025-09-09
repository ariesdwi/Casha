//
//  CategoryAnalutics.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//


import Foundation
import Core
import CoreData
import Domain

public protocol CategoryAnalyticsDataSource {
    func fetchCategorySpending(startDate: Date, endDate: Date) throws -> [ChartCategorySpending]
}

public final class CategoryAnalytics: CategoryAnalyticsDataSource {
    private let manager: CoreDataManager

    public init(manager: CoreDataManager = .shared) {
        self.manager = manager
    }

    public func fetchCategorySpending(startDate: Date, endDate: Date) throws -> [ChartCategorySpending] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        // Filter by date range
        request.predicate = NSPredicate(
            format: "datetime >= %@ AND datetime <= %@",
            startDate as NSDate,
            endDate as NSDate
        )

        var categorySpendings: [ChartCategorySpending] = []
        var fetchError: Error?

        manager.context.performAndWait {
            do {
                let transactions = try manager.context.fetch(request)

                // Group by category name
                let groupedByCategory = Dictionary(grouping: transactions) { transaction in
                    transaction.category?.name ?? "Uncategorized"
                }

                // Calculate total spending overall
                let overallTotal = transactions.reduce(0) { $0 + $1.amount }

                // Map to ChartCategorySpending
                categorySpendings = groupedByCategory.map { (categoryName, transactions) -> ChartCategorySpending in
                    let total = transactions.reduce(0) { $0 + $1.amount }
                    let percentage = overallTotal == 0 ? 0 : (total / overallTotal)
                    return ChartCategorySpending(category: categoryName, total: total, percentage: percentage)
                }
                .sorted { $0.total > $1.total }

            } catch {
                fetchError = error
            }
        }

        if let error = fetchError {
            throw error
        }
        return categorySpendings
    }
}

