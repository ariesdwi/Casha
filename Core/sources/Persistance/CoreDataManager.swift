//
//  CoreDataManager.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//


//import Foundation
//import CoreData
//import Domain
//
//public final class CoreDataManager {
//    public static let shared = CoreDataManager()
//    public let context: NSManagedObjectContext
//    
//    private init() {
//        self.context = CoreDataStack.shared.context
//    }
//
//    // MARK: - Category
//
//    public func insertCategory(_ category: CategoryCasha) throws {
//        let entity = CategoryEntity(context: context)
//        entity.id = category.id
//        entity.name = category.name
//        entity.isActive = category.isActive
//        entity.createdAt = category.createdAt
//        entity.updatedAt = category.updatedAt
//        try saveContext()
//    }
//
//    public func getAllCategories() throws -> [CategoryEntity] {
//        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        return try context.fetch(request)
//    }
//
//    public func getCategoryById(_ id: String) throws -> CategoryEntity? {
//        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id)
//        request.fetchLimit = 1
//        return try context.fetch(request).first
//    }
//
//    public func deleteAllCategories() throws {
//        let request: NSFetchRequest<NSFetchRequestResult> = CategoryEntity.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
//        try context.execute(deleteRequest)
//        try saveContext()
//    }
//
//    // MARK: - Transaction
//
//    public func insertTransaction(_ transaction: TransactionCasha) throws {
//        let entity = TransactionEntity(context: context)
//        entity.id = transaction.id
//        entity.name = transaction.name
//        entity.amount = transaction.amount
//        entity.datetime = transaction.datetime
//        entity.isConfirm = transaction.isConfirm
//        entity.createdAt = transaction.createdAt
//        entity.updatedAt = transaction.updatedAt
//
//        if let category = try getCategoryByName(transaction.category) {
//            entity.category = category
//        }
//        try saveContext()
//    }
//
//    public func getAllTransactions(sortedBy key: String = "datetime", ascending: Bool = false) throws -> [TransactionEntity] {
//        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: key, ascending: ascending)]
//        return try context.fetch(request)
//    }
//
//    public func getTransactionById(_ id: String) throws -> TransactionEntity? {
//        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id)
//        request.fetchLimit = 1
//        return try context.fetch(request).first
//    }
//
//    public func deleteTransactionById(_ id: String) throws {
//        if let entity = try getTransactionById(id) {
//            context.delete(entity)
//            try saveContext()
//        }
//    }
//
//    public func deleteAllTransactions() throws {
//        let request: NSFetchRequest<NSFetchRequestResult> = TransactionEntity.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
//        try context.execute(deleteRequest)
//        try saveContext()
//    }
//
//    // MARK: - Helpers
//
//    private func getCategoryByName(_ name: String) throws -> CategoryEntity? {
//        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "name == %@", name)
//        request.fetchLimit = 1
//        return try context.fetch(request).first
//    }
//
//    private func saveContext() throws {
//        if context.hasChanges {
//            try context.save()
//        }
//    }
//}

import Foundation
import CoreData

public final class CoreDataManager {
    public static let shared = CoreDataManager()
    public let context: NSManagedObjectContext

    private init() {
        self.context = CoreDataStack.shared.context
    }

    public func saveContext() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}

