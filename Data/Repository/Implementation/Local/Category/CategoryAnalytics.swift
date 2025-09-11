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
    func fetchTransactionsForCategory(_ category: String, startDate: Date, endDate: Date) throws -> [TransactionCasha]
    func fetchTransactionsForCategories(_ categories: [String], startDate: Date, endDate: Date) throws -> [TransactionCasha]
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

    // MARK: - Fetch Transactions for Specific Category
    
    public func fetchTransactionsForCategory(_ category: String, startDate: Date, endDate: Date) throws -> [TransactionCasha] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        // Filter by category and date range
        request.predicate = NSPredicate(
            format: "(category.name == %@ OR category == %@) AND datetime >= %@ AND datetime <= %@",
            category,
            category, // For backward compatibility if category is stored as string
            startDate as NSDate,
            endDate as NSDate
        )
        
        // Sort by date descending
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        
        var transactions: [TransactionCasha] = []
        var fetchError: Error?
        
        manager.context.performAndWait {
            do {
                let transactionEntities = try manager.context.fetch(request)
                transactions = transactionEntities.map { $0.toDomain() }
            } catch {
                fetchError = error
            }
        }
        
        if let error = fetchError {
            throw error
        }
        return transactions
    }
    
    // MARK: - Fetch Transactions for Multiple Categories
    
    public func fetchTransactionsForCategories(_ categories: [String], startDate: Date, endDate: Date) throws -> [TransactionCasha] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        // Filter by multiple categories and date range
        request.predicate = NSPredicate(
            format: "(category.name IN %@ OR category IN %@) AND datetime >= %@ AND datetime <= %@",
            categories,
            categories, // For backward compatibility
            startDate as NSDate,
            endDate as NSDate
        )
        
        // Sort by date descending
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        
        var transactions: [TransactionCasha] = []
        var fetchError: Error?
        
        manager.context.performAndWait {
            do {
                let transactionEntities = try manager.context.fetch(request)
                transactions = transactionEntities.map { $0.toDomain() }
            } catch {
                fetchError = error
            }
        }
        
        if let error = fetchError {
            throw error
        }
        return transactions
    }
    
    // MARK: - Fetch Transactions Grouped by Category
    
    public func fetchTransactionsGroupedByCategory(startDate: Date, endDate: Date) throws -> [String: [TransactionCasha]] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        // Filter by date range
        request.predicate = NSPredicate(
            format: "datetime >= %@ AND datetime <= %@",
            startDate as NSDate,
            endDate as NSDate
        )
        
        // Sort by date descending
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        
        var groupedTransactions: [String: [TransactionCasha]] = [:]
        var fetchError: Error?
        
        manager.context.performAndWait {
            do {
                let transactionEntities = try manager.context.fetch(request)
                let domainTransactions = transactionEntities.map { $0.toDomain() }
                
                // Group by category
                groupedTransactions = Dictionary(grouping: domainTransactions) { transaction in
                    transaction.category ?? "Uncategorized"
                }
                
            } catch {
                fetchError = error
            }
        }
        
        if let error = fetchError {
            throw error
        }
        return groupedTransactions
    }
    
    // MARK: - Get Top Spending Categories with Transactions
    
    public func fetchTopCategoriesWithTransactions(limit: Int, startDate: Date, endDate: Date) throws -> [(ChartCategorySpending, [TransactionCasha])] {
        let categorySpendings = try fetchCategorySpending(startDate: startDate, endDate: endDate)
        var result: [(ChartCategorySpending, [TransactionCasha])] = []
        
        // Get top N categories
        let topCategories = Array(categorySpendings.prefix(limit))
        
        for categorySpending in topCategories {
            let transactions = try fetchTransactionsForCategory(categorySpending.category, startDate: startDate, endDate: endDate)
            result.append((categorySpending, transactions))
        }
        
        return result
    }
}


