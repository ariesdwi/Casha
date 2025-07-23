//
//  CoreDataTransactionLocalDataSource.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import CoreData
import Domain
import Core

public final class CoreDataTransactionLocalDataSource: TransactionLocalDataSource {
    
    private let context: NSManagedObjectContext
    private let manager: CoreDataManager

    public init(manager: CoreDataManager = .shared) {
        self.manager = manager
        self.context = manager.context
    }

    public func save(_ transaction: TransactionCasha) throws {
        let entity = TransactionEntity(context: context)
        entity.id = transaction.id
        entity.name = transaction.name
        entity.amount = transaction.amount
        entity.datetime = transaction.datetime
        entity.isConfirm = transaction.isConfirm
        entity.createdAt = transaction.createdAt
        entity.updatedAt = transaction.updatedAt

        // Set category relationship if exists
        if let category = try fetchCategoryByName(transaction.category) {
            entity.category = category
        } else {
            let newCategory = CategoryEntity(context: context)
            newCategory.id = UUID().uuidString
            newCategory.name = transaction.category
            newCategory.isActive = true
            newCategory.createdAt = Date()
            newCategory.updatedAt = Date()
            entity.category = newCategory
        }

        try manager.saveContext()
    }

    public func fetchAll() throws -> [TransactionCasha] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]

        let result = try context.fetch(request)
        return result.map { $0.toDomain() }
    }

    public func delete(byId id: String) throws {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        if let entity = try context.fetch(request).first {
            context.delete(entity)
            try manager.saveContext()
        }
    }

    public func deleteAll() throws {
        let request: NSFetchRequest<NSFetchRequestResult> = TransactionEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try context.execute(deleteRequest)
        try manager.saveContext()
    }

    // MARK: - Private
    private func fetchCategoryByName(_ name: String) throws -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    public func fetch(limit: Int) throws -> [TransactionCasha] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.fetchLimit = limit
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]

        let result = try context.fetch(request)
        return result.map { $0.toDomain() }
    }

    
    public func fetchSpendingReport(period: ReportPeriod) throws -> SpendingReport {
        let calendar = Calendar.current
        let now = Date()

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

        request.predicate = thisPredicate
        let thisTransactions = try context.fetch(request)

        request.predicate = lastPredicate
        let lastTransactions = try context.fetch(request)

        let thisTotal = thisTransactions.reduce(0) { $0 + $1.amount }
        let lastTotal = lastTransactions.reduce(0) { $0 + $1.amount }

        return SpendingReport(thisPeriod: thisTotal, lastPeriod: lastTotal)
    }
    
    public func addDummyTransactions(count: Int) {
        let calendar = Calendar.current
        let categories = ["Food", "Shopping", "Transport", "Bills", "Entertainment", "Health"]
        
        for i in 0..<count {
            // Random month offset within the last 12 months
            let monthOffset = Int.random(in: 0..<12)
            let dayOffset = Int.random(in: 0..<28) // Keep within safe range for all months

            var components = calendar.dateComponents([.year, .month], from: Date())
            components.month = (components.month ?? 1) - monthOffset
            components.day = dayOffset + 1 // To avoid 0

            let randomDate = calendar.date(from: components) ?? Date()

            let transaction = TransactionCasha(
                id: UUID().uuidString,
                name: "Dummy Item \(i + 1)",
                category: categories.randomElement() ?? "Other", amount: Double.random(in: 5_000...250_000),
                datetime: randomDate,
                isConfirm: Bool.random(),
                createdAt: randomDate,
                updatedAt: randomDate
            )

            do {
                try save(transaction)
            } catch {
                print("❌ Failed to insert dummy transaction \(i): \(error)")
            }
        }

        print("✅ Dummy transactions added across random months in the last year.")
    }


}
