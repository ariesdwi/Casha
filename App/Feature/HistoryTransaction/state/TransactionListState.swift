//
//  TransactionState.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//


import Foundation
@preconcurrency import Domain
import Data
import Core


final class TransactionListState: ObservableObject {
    @Published var allTransactions: [TransactionCasha] = []
    @Published var filteredTransactions: [TransactionDateSection] = []
    @Published var isSearching = false
    
    private let repository = TransactionRepositoryImpl()
    private var selectedPeriod: String = "This month"
    
    @MainActor
    func loadTransactions() {
        Task {
            let data = repository.fetchRecentTransactions(limit: 100)
            self.allTransactions = data
            self.filterTransactions(by: "This month")
        }
    }

    
    func filterTransactions(by period: String) {
        guard !isSearching else { return }
        
        selectedPeriod = period
        let calendar = Calendar.current
        let now = Date()
        
        // 1. Determine date range based on selected period
        let dateRange: (start: Date?, end: Date?) = {
            switch period {
            case "This month":
                return (now.startOfMonth(), now.endOfMonth())
            case "Last month":
                guard let lastMonth = calendar.date(byAdding: .month, value: -1, to: now) else {
                    return (nil, nil)
                }
                return (lastMonth.startOfMonth(), lastMonth.endOfMonth())
            case "Future":
                guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: now) else {
                    return (nil, nil)
                }
                return (nextMonth.startOfMonth(), nil)
            default: // Specific month (e.g. "Jun 2025")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM yyyy"
                guard let date = dateFormatter.date(from: period) else {
                    return (nil, nil)
                }
                return (date.startOfMonth(), date.endOfMonth())
            }
        }()
        
        // 2. Filter transactions
        let filtered = allTransactions.filter { transaction in
            if let start = dateRange.start {
                guard transaction.datetime >= start else { return false }
            }
            if let end = dateRange.end {
                guard transaction.datetime <= end else { return false }
            }
            return true
        }
        
        // Create sections
        let grouped = Dictionary(grouping: filtered) { transaction in
            DateHelper.format(transaction.datetime, style: .sectionDate)
        }
        
        let sections = grouped.map { dateString, transactions in
            TransactionDateSection(
                date: dateString,
                day: DateHelper.format(transactions.first?.datetime ?? now, style: .dayName),
                items: transactions.sorted { $0.datetime > $1.datetime }
            )
        }
        
        // Sort sections
        self.filteredTransactions = sections.sorted {
            guard let date1 = DateHelper.date(from: $0.date, style: .sectionDate),
                  let date2 = DateHelper.date(from: $1.date, style: .sectionDate) else {
                return false
            }
            return date1 > date2
        }
    }
    
    func searchTransactions(with query: String) {
        isSearching = !query.isEmpty
        
        if query.isEmpty {
            // When search is cleared, return to current filtered view
            filterTransactions(by: selectedPeriod)
            return
        }
        
        let lowercasedQuery = query.lowercased()
        
        // Search through ALL transactions
        let filtered = allTransactions.filter {
            $0.name.lowercased().contains(lowercasedQuery) ||
//            $0.amount.lowercased().contains(lowercasedQuery) ||
            $0.category.lowercased().contains(lowercasedQuery)
        }
        
        // Group search results by date
        let grouped = Dictionary(grouping: filtered) { transaction in
            DateHelper.format(transaction.datetime, style: .sectionDate)
        }
        
        let sections = grouped.map { dateString, transactions in
            TransactionDateSection(
                date: dateString,
                day: DateHelper.format(transactions.first?.datetime ?? Date(), style: .dayName),
                items: transactions.sorted { $0.datetime > $1.datetime }
            )
        }
        
        // Sort sections by date
        self.filteredTransactions = sections.sorted {
            guard let date1 = DateHelper.date(from: $0.date, style: .sectionDate),
                  let date2 = DateHelper.date(from: $1.date, style: .sectionDate) else {
                return false
            }
            return date1 > date2
        }
    }
}

// Date extensions
extension Date {
    func startOfMonth() -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) ?? self
    }
    
    func endOfMonth() -> Date {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth()) ?? self
    }
}

