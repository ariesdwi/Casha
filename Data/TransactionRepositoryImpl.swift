//
//  TransactionRepository.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//

import Foundation
import CoreData
import Domain
import Core

public final class TransactionRepositoryImpl: TransactionRepositoryProtocol {
    private let coreDataManager: CoreDataManager

    public init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }

    // MARK: - Add Transaction
    public func addTransaction(_ transaction: TransactionCasha) async throws {
        let context = coreDataManager.context

        let entity = TransactionEntity(context: context)
        entity.id = transaction.id
        entity.name = transaction.name
        entity.amount = transaction.amount
        entity.datetime = transaction.datetime
        entity.isConfirm = transaction.isConfirm
        entity.createdAt = transaction.createdAt
        entity.updatedAt = transaction.updatedAt

        // Fetch or create CategoryEntity
        let categoryFetch: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        categoryFetch.predicate = NSPredicate(format: "name == %@", transaction.category)

        if let categoryEntity = try? context.fetch(categoryFetch).first {
            entity.category = categoryEntity
        } else {
            let newCategory = CategoryEntity(context: context)
            newCategory.id = UUID().uuidString
            newCategory.name = transaction.category
            newCategory.isActive = true
            newCategory.createdAt = Date()
            newCategory.updatedAt = Date()
            entity.category = newCategory
        }

        try context.save()
    }

    // MARK: - Fetch Recent Transactions
    public func fetchRecentTransactions(limit: Int) -> [TransactionCasha] {
        let context = coreDataManager.context

        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.fetchLimit = limit
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]

        do {
            let results = try context.fetch(request)
            return results.map { $0.toDomain() }
        } catch {
            print("❌ Failed to fetch recent transactions: \(error)")
            return []
        }
    }

    // MARK: - Fetch Total Spending
    public func fetchTotalSpending() -> Double {
        let context = coreDataManager.context

        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()

        do {
            let transactions = try context.fetch(request)
            return transactions.reduce(0) { $0 + $1.amount }
        } catch {
            print("❌ Failed to calculate total spending: \(error)")
            return 0
        }
    }

    // MARK: - Fetch Spending Report
    public func fetchSpendingReport(period: ReportPeriod) -> [SpendingReport] {
        let context = coreDataManager.context

        let now = Date()
        let calendar = Calendar.current

        let thisStartDate: Date
        let lastStartDate: Date
        let thisEndDate = now

        switch period {
        case .week:
            thisStartDate = calendar.date(byAdding: .day, value: -7, to: now)!
            lastStartDate = calendar.date(byAdding: .day, value: -14, to: now)!
        case .month:
            thisStartDate = calendar.date(byAdding: .month, value: -1, to: now)!
            lastStartDate = calendar.date(byAdding: .month, value: -2, to: now)!
        }

        let thisPredicate = NSPredicate(format: "datetime >= %@ AND datetime <= %@", thisStartDate as NSDate, thisEndDate as NSDate)
        let lastPredicate = NSPredicate(format: "datetime >= %@ AND datetime <= %@", lastStartDate as NSDate, thisStartDate as NSDate)

        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()

        do {
            request.predicate = thisPredicate
            let thisTransactions = try context.fetch(request)

            request.predicate = lastPredicate
            let lastTransactions = try context.fetch(request)

            let thisTotal = thisTransactions.reduce(0) { $0 + $1.amount }
            let lastTotal = lastTransactions.reduce(0) { $0 + $1.amount }

            return [SpendingReport(thisPeriod: thisTotal, lastPeriod: lastTotal)]

        } catch {
            print("❌ Failed to fetch spending report: \(error)")
            return []
        }
    }
    
    
    public func fetchAllTransactions() async -> [TransactionCasha] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TransactionEntity.datetime, ascending: false)]
        
        do {
            let entities = try CoreDataStack.shared.context.fetch(request)
            return entities.map { $0.toDomain() }
        } catch {
            print("❌ Failed to fetch all transactions: \(error)")
            return []
        }
    }

}
