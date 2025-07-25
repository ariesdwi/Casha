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

public final class CategoryAnalytics: CategoryAnalyticsDataSource {
    private let context: NSManagedObjectContext
    private let manager: CoreDataManager

    public init(manager: CoreDataManager = .shared) {
        self.manager = manager
        self.context = manager.context
    }

    public func fetchCategorySpending(startDate: Date, endDate: Date) throws -> [ChartCategorySpending] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        // Filter by date range
        request.predicate = NSPredicate(
            format: "datetime >= %@ AND datetime <= %@",
            startDate as NSDate,
            endDate as NSDate
        )

        let transactions = try context.fetch(request)

        // Group by category name
        let groupedByCategory = Dictionary(grouping: transactions) { transaction in
            transaction.category?.name ?? "Uncategorized"
        }

        // Calculate total spending overall
        let overallTotal = transactions.reduce(0) { $0 + $1.amount }

        // Map to ChartCategorySpending
        let categorySpendings = groupedByCategory.map { (categoryName, transactions) -> ChartCategorySpending in
            let total = transactions.reduce(0) { $0 + $1.amount }
            let percentage = overallTotal == 0 ? 0 : (total / overallTotal)
            return ChartCategorySpending(category: categoryName, total: total, percentage: percentage)
        }

        return categorySpendings.sorted { $0.total > $1.total }
    }

}
