//
//  CoreDataTransactionAnalytics.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import CoreData
import Domain
import Core

public final class CoreDataTransactionAnalytics: TransactionAnalyticsDataSource {
    
    private let context: NSManagedObjectContext
    private let manager: CoreDataManager
    
    public init(manager: CoreDataManager = .shared) {
        self.manager = manager
        self.context = manager.context
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
    
}
