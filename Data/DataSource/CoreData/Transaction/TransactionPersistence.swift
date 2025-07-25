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
    
    public func update(_ transaction: Domain.TransactionCasha) throws {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", transaction.id)
        request.fetchLimit = 1

        if let entity = try context.fetch(request).first {
            entity.name = transaction.name
            entity.amount = transaction.amount
            entity.datetime = transaction.datetime
            entity.isConfirm = transaction.isConfirm
            entity.updatedAt = transaction.updatedAt

            if let existingCategory = try fetchCategoryByName(transaction.category) {
                entity.category = existingCategory
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
        } else {
            print("⚠️ Transaction with id \(transaction.id) not found. Saving as new.")
            try save(transaction)
        }
    }

}

