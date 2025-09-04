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

public final class TransactionQuery: TransactionQueryDataSource {
    private let manager: CoreDataManager
    
    public init(manager: CoreDataManager = .shared) {
        self.manager = manager
    }
    
    public func fetch(limit: Int) throws -> [TransactionCasha] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.fetchLimit = limit
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]

        return try performFetch(request)
    }

    public func fetchAll() throws -> [TransactionCasha] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]

        return try performFetch(request)
    }
    
    public func fetch(startDate: Date, endDate: Date?) throws -> [TransactionCasha] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        var predicates: [NSPredicate] = [
            NSPredicate(format: "datetime >= %@", startDate as NSDate)
        ]
        
        if let end = endDate {
            predicates.append(NSPredicate(format: "datetime <= %@", end as NSDate))
        }
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        
        return try performFetch(request)
    }
    
    public func search(query: String) throws -> [TransactionCasha] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "name CONTAINS[cd] %@", query),
            NSPredicate(format: "category.name CONTAINS[cd] %@", query)
        ])
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        
        return try performFetch(request)
    }
    
    // MARK: - Private helper
    
    private func performFetch(_ request: NSFetchRequest<TransactionEntity>) throws -> [TransactionCasha] {
        var results: [TransactionCasha] = []
        var fetchError: Error?

        manager.context.performAndWait {
            do {
                let entities = try manager.context.fetch(request)
                results = entities.map { $0.toDomain() }
            } catch {
                fetchError = error
            }
        }

        if let error = fetchError {
            throw error
        }
        return results
    }
}


