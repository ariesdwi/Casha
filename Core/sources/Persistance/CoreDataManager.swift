//
//  CoreDataManager.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//


import Foundation
import CoreData

public class CoreDataManager {
    public static let shared = CoreDataManager()

    public let context: NSManagedObjectContext

    private init() {
        self.context = CoreDataStack.shared.context
    }

    // MARK: - CATEGORY OPERATIONS

    public func saveCategory(id: String, name: String, isActive: Bool, createdAt: Date, updatedAt: Date) {
        let category = CategoryEntity(context: context)
        category.id = id
        category.name = name
        category.isActive = isActive
        category.createdAt = createdAt
        category.updatedAt = updatedAt
        saveContext()
    }

    public func fetchCategories() -> [CategoryEntity] {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Error fetching categories: \(error)")
            return []
        }
    }

    public func deleteAllCategories() {
        let request: NSFetchRequest<NSFetchRequestResult> = CategoryEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("❌ Error deleting all categories: \(error)")
        }
    }

    public func categoryExists(withId id: String) -> Bool {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        do {
            return try context.count(for: request) > 0
        } catch {
            return false
        }
    }

    // MARK: - TRANSACTION OPERATIONS

    public func saveTransaction(id: String, name: String, amount: Double, datetime: Date, isConfirm: Bool, createdAt: Date, updatedAt: Date, categoryId: String) {
        let transaction = TransactionEntity(context: context)
        transaction.id = id
        transaction.name = name
        transaction.amount = amount
        transaction.datetime = datetime
        transaction.isConfirm = isConfirm
        transaction.createdAt = createdAt
        transaction.updatedAt = updatedAt

        if let category = fetchCategoryById(categoryId) {
            transaction.category = category
        }

        saveContext()
    }

    public func fetchTransactions() -> [TransactionEntity] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("❌ Error fetching transactions: \(error)")
            return []
        }
    }

    public func deleteTransaction(withId id: String) {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        if let transaction = try? context.fetch(request).first {
            context.delete(transaction)
            saveContext()
        }
    }

    public func deleteAllTransactions() {
        let request: NSFetchRequest<NSFetchRequestResult> = TransactionEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("❌ Error deleting all transactions: \(error)")
        }
    }

    public func transactionExists(withId id: String) -> Bool {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        do {
            return try context.count(for: request) > 0
        } catch {
            return false
        }
    }

    // MARK: - PRIVATE HELPERS

    private func fetchCategoryById(_ id: String) -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        return try? context.fetch(request).first
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("❌ Failed to save Core Data context: \(error)")
        }
    }
}
