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

public protocol TransactionQueryDataSource {
    func fetchAll() throws -> [TransactionCasha]
    func fetch(limit: Int) throws -> [TransactionCasha]
    func fetch(startDate: Date, endDate: Date?) throws -> [TransactionCasha]
    func search(query: String) throws -> [TransactionCasha]
    func fetchUnsyncedTransactions() throws -> [TransactionCasha]
    func fetchUnsyncedTransactionsCount() throws -> Int
    func fetchTotalSpending(for period: SpendingPeriod) throws -> Double
}

public final class TransactionQuery: TransactionQueryDataSource {
    
    
    private let manager: CoreDataManager
    
    public init(manager: CoreDataManager = .shared) {
        self.manager = manager
    }
    
    public func fetch(limit: Int) throws -> [TransactionCasha] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        request.fetchLimit = limit
        
        return try performFetch(request)
    }
    
    
    public func fetchAll() throws -> [TransactionCasha] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        
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
    
    
    public func fetchUnsyncedTransactions() throws -> [TransactionCasha] {
        var transactions: [TransactionCasha] = []
        var fetchError: Error?
        
        manager.context.performAndWait {
            do {
                let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
                // Use isConfirm = false for unsynced transactions
                request.predicate = NSPredicate(format: "isConfirm == %@", NSNumber(value: false))
                
                let entities = try manager.context.fetch(request)
                transactions = entities.map { entity in
                    TransactionCasha(
                        id: entity.id ?? UUID().uuidString,
                        name: entity.name ?? "",
                        category: entity.category?.name ?? "",
                        amount: entity.amount,
                        datetime: entity.datetime ?? Date(),
                        isConfirm: entity.isConfirm,
                        createdAt: entity.createdAt ?? Date(),
                        updatedAt: entity.updatedAt ?? Date()
                    )
                }
            } catch {
                fetchError = error
            }
        }
        
        if let error = fetchError {
            throw error
        }
        
        return transactions
    }
    
    public func fetchUnsyncedTransactionsCount() throws -> Int {
        var count = 0
        var countError: Error?
        
        manager.context.performAndWait {
            do {
                let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
                // Use isConfirm = false for unsynced transactions
                request.predicate = NSPredicate(format: "isConfirm == %@", NSNumber(value: false))
                
                count = try manager.context.count(for: request)
            } catch {
                countError = error
            }
        }
        
        if let error = countError {
            throw error
        }
        
        return count
    }
    
    public func fetchTotalSpending(for period: SpendingPeriod = .allTime) throws -> Double {
        var total: Double = 0
        var fetchError: Error?
        
        manager.context.performAndWait {
            do {
                let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
                
                switch period {
                case .thisMonth:
                    let startOfMonth = Calendar.current.startOfMonth(for: Date())
                    let endOfMonth = Calendar.current.endOfMonth(for: Date())
                    request.predicate = NSPredicate(
                        format: "datetime >= %@ AND datetime <= %@",
                        startOfMonth as NSDate,
                        endOfMonth as NSDate
                    )
                    
                case .lastThreeMonths:
                    let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
                    request.predicate = NSPredicate(
                        format: "datetime >= %@",
                        threeMonthsAgo as NSDate
                    )
                    
                case .thisYear:
                    let startOfYear = Calendar.current.startOfYear(for: Date())
                    let endOfYear = Calendar.current.endOfYear(for: Date())
                    request.predicate = NSPredicate(
                        format: "datetime >= %@ AND datetime <= %@",
                        startOfYear as NSDate,
                        endOfYear as NSDate
                    )
                    
                case .custom(let interval):
                    request.predicate = NSPredicate(
                        format: "datetime >= %@ AND datetime <= %@",
                        interval.start as NSDate,
                        interval.end as NSDate
                    )
                    
                case .allTime:
                    // No predicate for all time
                    break
                }
                
                let entities = try manager.context.fetch(request)
                total = entities.reduce(0) { $0 + $1.amount }
                
            } catch {
                fetchError = error
            }
        }
        
        if let error = fetchError {
            throw error
        }
        
        return total
    }
}


extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        return self.date(from: self.dateComponents([.year, .month], from: date))!
    }
    
    func endOfMonth(for date: Date) -> Date {
        return self.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth(for: date))!
    }
    
    func startOfYear(for date: Date) -> Date {
        return self.date(from: self.dateComponents([.year], from: date))!
    }
    
    func endOfYear(for date: Date) -> Date {
        let start = startOfYear(for: date)
        return self.date(byAdding: DateComponents(year: 1, day: -1), to: start)!
    }
}
