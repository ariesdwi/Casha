//
//  CoreDataManager.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//


import Foundation
import CoreData

public final class CoreDataManager {
    public static let shared = CoreDataManager()
    public let context: NSManagedObjectContext
    
    public init() {
        self.context = CoreDataStack.shared.context
    }
    
    // MARK: - Category Operations
    
    public func saveCategory(
        id: String,
        name: String,
        isActive: Bool,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) throws {
        let category = CategoryEntity(context: context)
        category.id = id
        category.name = name
        category.isActive = isActive
        category.createdAt = createdAt
        category.updatedAt = updatedAt
        try saveContext()
    }
    
    public func fetchCategories() -> [CategoryEntity] {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            assertionFailure("Failed to fetch categories: \(error)")
            return []
        }
    }
    
    public func deleteAllCategories() throws {
        let request: NSFetchRequest<NSFetchRequestResult> = CategoryEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try context.execute(deleteRequest)
        try saveContext()
    }
    
    public func categoryExists(withId id: String) -> Bool {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        
        do {
            return try context.count(for: request) > 0
        } catch {
            assertionFailure("Category existence check failed: \(error)")
            return false
        }
    }
    
    // MARK: - Transaction Operations
    
    public func saveTransaction(
        id: String,
        name: String,
        amount: Double,
        datetime: Date,
        isConfirm: Bool,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        categoryId: String
    ) throws {
        let transaction = TransactionEntity(context: context)
        transaction.id = id
        transaction.name = name
        transaction.amount = amount
        transaction.datetime = datetime
        transaction.isConfirm = isConfirm
        transaction.createdAt = createdAt
        transaction.updatedAt = updatedAt
        
        if let category = try fetchCategoryById(categoryId) {
            transaction.category = category
        }
        
        try saveContext()
    }
    
    public func fetchTransactions(
        sortedBy sortKey: String = "datetime",
        ascending: Bool = false
    ) -> [TransactionEntity] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: ascending)]
        
        do {
            return try context.fetch(request)
        } catch {
            assertionFailure("Failed to fetch transactions: \(error)")
            return []
        }
    }
    
    public func deleteTransaction(withId id: String) throws {
        guard let transaction = try fetchTransactionById(id) else { return }
        context.delete(transaction)
        try saveContext()
    }
    
    public func deleteAllTransactions() throws {
        let request: NSFetchRequest<NSFetchRequestResult> = TransactionEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try context.execute(deleteRequest)
        try saveContext()
    }
    
    
    private func fetchCategoryById(_ id: String) throws -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    private func fetchTransactionById(_ id: String) throws -> TransactionEntity? {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    private func saveContext() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}
