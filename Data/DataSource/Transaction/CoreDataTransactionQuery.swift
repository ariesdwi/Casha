//
//  CoreDataTransactionQuery.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//
import Foundation
import CoreData
import Domain
import Core

public final class CoreDataTransactionQuery: TransactionQueryDataSource {
    private let context: NSManagedObjectContext
    private let manager: CoreDataManager
    
    public init(manager: CoreDataManager = .shared) {
        self.manager = manager
        self.context = manager.context
    }
    
    public func fetch(limit: Int) throws -> [TransactionCasha] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.fetchLimit = limit
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        
        let result = try context.fetch(request)
        return result.map { $0.toDomain() }
    }
    
    public func fetchAll() throws -> [TransactionCasha] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        
        let result = try context.fetch(request)
        return result.map { $0.toDomain() }
    }
    
    public func fetch(startDate: Date, endDate: Date?) throws -> [TransactionCasha] {
        let request = TransactionEntity.fetchRequest()
        var predicates: [NSPredicate] = [
            NSPredicate(format: "datetime >= %@", startDate as NSDate)
        ]
        
        if let end = endDate {
            predicates.append(NSPredicate(format: "datetime <= %@", end as NSDate))
        }
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        let results = try context.fetch(request)
        return results.map { $0.toDomain() }
    }
    
    public func search(query: String) throws -> [TransactionCasha] {
        let request = TransactionEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "name CONTAINS[cd] %@", query),
            NSPredicate(format: "category.name CONTAINS[cd] %@", query)
        ])
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        
        let results = try context.fetch(request)
        
        return results.map { entity in
            TransactionCasha(
                id: entity.id,
                name: entity.name,
                category: entity.category?.name ?? "(Uncategorized)",
                amount: entity.amount,
                datetime: entity.datetime,
                isConfirm: entity.isConfirm,
                createdAt: entity.createdAt,
                updatedAt: entity.updatedAt
            )
        }
    }
    
}

