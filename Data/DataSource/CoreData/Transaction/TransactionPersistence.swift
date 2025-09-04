//
//  CoreDataTransactionPersistence.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//


import Foundation
import CoreData
import Domain
import Core

public final class TransactionPersistence: TransactionPersistenceDataSource {
    private let manager: CoreDataManager

    public init(manager: CoreDataManager = .shared) {
        self.manager = manager
    }

    public func save(_ transaction: TransactionCasha) throws {
        var saveError: Error?

        manager.context.performAndWait {
            let entity = TransactionEntity(context: manager.context)
            entity.id = transaction.id
            entity.name = transaction.name
            entity.amount = transaction.amount
            entity.datetime = transaction.datetime
            entity.isConfirm = transaction.isConfirm
            entity.createdAt = transaction.createdAt
            entity.updatedAt = transaction.updatedAt

            do {
                // Set category relationship if exists, otherwise create new
                if let category = try fetchCategoryByName(transaction.category) {
                    entity.category = category
                } else {
                    let newCategory = CategoryEntity(context: manager.context)
                    newCategory.id = UUID().uuidString
                    newCategory.name = transaction.category
                    newCategory.isActive = true
                    newCategory.createdAt = Date()
                    newCategory.updatedAt = Date()
                    entity.category = newCategory
                }

                try manager.saveContext()
            } catch {
                saveError = error
            }
        }

        if let error = saveError {
            throw error
        }
    }

    public func delete(byId id: String) throws {
        var deleteError: Error?

        manager.context.performAndWait {
            let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)
            request.fetchLimit = 1

            do {
                if let entity = try manager.context.fetch(request).first {
                    manager.context.delete(entity)
                    try manager.saveContext()
                }
            } catch {
                deleteError = error
            }
        }

        if let error = deleteError {
            throw error
        }
    }

    public func deleteAll() throws {
        var deleteError: Error?

        manager.context.performAndWait {
            let request: NSFetchRequest<NSFetchRequestResult> = TransactionEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

            do {
                try manager.context.execute(deleteRequest)
                try manager.saveContext()
            } catch {
                deleteError = error
            }
        }

        if let error = deleteError {
            throw error
        }
    }

    public func update(_ transaction: TransactionCasha) throws {
        var updateError: Error?

        manager.context.performAndWait {
            let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", transaction.id)
            request.fetchLimit = 1

            do {
                if let entity = try manager.context.fetch(request).first {
                    entity.name = transaction.name
                    entity.amount = transaction.amount
                    entity.datetime = transaction.datetime
                    entity.isConfirm = transaction.isConfirm
                    entity.updatedAt = transaction.updatedAt

                    if let existingCategory = try fetchCategoryByName(transaction.category) {
                        entity.category = existingCategory
                    } else {
                        let newCategory = CategoryEntity(context: manager.context)
                        newCategory.id = UUID().uuidString
                        newCategory.name = transaction.category
                        newCategory.isActive = true
                        newCategory.createdAt = Date()
                        newCategory.updatedAt = Date()
                        entity.category = newCategory
                    }

                    try manager.saveContext()
                } else {
                    print("⚠️ Transaction with id \(transaction.id) not found. Saving as new.")
                    try save(transaction)
                }
            } catch {
                updateError = error
            }
        }

        if let error = updateError {
            throw error
        }
    }

    public func addDummyTransactions(count: Int) {
        let calendar = Calendar.current
        let categories = ["Food", "Shopping", "Transport", "Bills", "Entertainment", "Health"]

        for i in 0..<count {
            let monthOffset = Int.random(in: 0..<12)
            let dayOffset = Int.random(in: 0..<28)

            var components = calendar.dateComponents([.year, .month], from: Date())
            components.month = (components.month ?? 1) - monthOffset
            components.day = dayOffset + 1

            let randomDate = calendar.date(from: components) ?? Date()

            let transaction = TransactionCasha(
                id: UUID().uuidString,
                name: "Dummy Item \(i + 1)",
                category: categories.randomElement() ?? "Other",
                amount: Double.random(in: 5_000...250_000),
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

    // MARK: - Private
    private func fetchCategoryByName(_ name: String) throws -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1
        return try manager.context.fetch(request).first
    }
}

