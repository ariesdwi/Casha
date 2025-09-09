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

public protocol TransactionAnalyticsDataSource {
    func fetchSpendingReport() throws -> SpendingReport
}

public final class TransactionAnalytics: TransactionAnalyticsDataSource {
    private let manager: CoreDataManager

    public init(manager: CoreDataManager = .shared) {
        self.manager = manager
    }

    public func fetchSpendingReport() throws -> SpendingReport {
        let calendar = Calendar.current
        let now = Date()
        
        // 1. Start of this week
        guard let startOfWeek = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        ) else {
            throw SpendingReportError.calendarCalculationFailed
        }
        
        // 2. Start of this month
        guard let startOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: now)
        ) else {
            throw SpendingReportError.calendarCalculationFailed
        }
        
        // 3. Fetch all transactions since the beginning of this month
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "datetime >= %@", startOfMonth as NSDate)
        
        var transactions: [TransactionEntity] = []
        var fetchError: Error?
        
        manager.context.performAndWait {
            do {
                transactions = try manager.context.fetch(request)
            } catch {
                fetchError = error
            }
        }
        
        if let error = fetchError {
            throw error
        }
        
        // 4. Daily bars (Mon–Sun)
        let thisWeekTransactions = transactions.filter { $0.datetime >= startOfWeek }
        let dailyGrouped = Dictionary(grouping: thisWeekTransactions) { transaction in
            calendar.component(.weekday, from: transaction.datetime)
        }
        
        let dailyBars: [SpendingBar] = (1...7).map { weekday -> SpendingBar in
            let index = (weekday - 1 + calendar.firstWeekday - 1) % 7
            let dayLabel = calendar.shortWeekdaySymbols[index]
            let total = dailyGrouped[weekday]?.reduce(0) { $0 + $1.amount } ?? 0
            return SpendingBar(label: dayLabel, amount: total)
        }
        
        // 5. Weekly bars (Week 1 to Week 4)
        let weeklyGrouped = Dictionary(grouping: transactions) { transaction in
            let week = calendar.component(.weekOfMonth, from: transaction.datetime)
            return min(week, 4)
        }
        
        let weeklyBars: [SpendingBar] = (1...4).map { week in
            let label = "Week \(week)"
            let total = weeklyGrouped[week]?.reduce(0) { $0 + $1.amount } ?? 0
            return SpendingBar(label: label, amount: total)
        }
        
        // 6. Totals
        let thisWeekTotal = dailyBars.reduce(0) { $0 + $1.amount }
        let thisMonthTotal = weeklyBars.reduce(0) { $0 + $1.amount }
        
        return SpendingReport(
            thisWeekTotal: thisWeekTotal,
            thisMonthTotal: thisMonthTotal,
            dailyBars: dailyBars,
            weeklyBars: weeklyBars
        )
    }

    enum SpendingReportError: Error {
        case calendarCalculationFailed
    }
}
