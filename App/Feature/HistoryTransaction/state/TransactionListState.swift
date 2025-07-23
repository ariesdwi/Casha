//
//  TransactionState.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//


import Foundation
import Domain
import Core

final class TransactionListState: ObservableObject {
    @Published var filteredTransactions: [TransactionDateSection] = []
    @Published var isSearching = false

    private let getTransactionsByPeriod: GetTransactionsByPeriodUseCase
    private let searchTransactions: SearchTransactionsUseCase

    private var selectedPeriod: String = "This month"
    private var searchQuery: String = ""

    init(
        getTransactionsByPeriod: GetTransactionsByPeriodUseCase,
        searchTransactions: SearchTransactionsUseCase
    ) {
        self.getTransactionsByPeriod = getTransactionsByPeriod
        self.searchTransactions = searchTransactions
    }

    @MainActor
    func load() {
        if searchQuery.isEmpty {
            filterTransactions(by: selectedPeriod)
        } else {
            searchTransactions(with: searchQuery)
        }
    }

    @MainActor
    func filterTransactions(by period: String) {
        isSearching = false
        selectedPeriod = period

        Task {
            let (start, end) = resolveDateRange(for: period)
            let transactions = await getTransactionsByPeriod.execute(startDate: start, endDate: end)
            self.filteredTransactions = groupAndSort(transactions: transactions)
        }
    }

    @MainActor
    func searchTransactions(with query: String) {
        searchQuery = query
        isSearching = !query.isEmpty

        guard !query.isEmpty else {
            filterTransactions(by: selectedPeriod)
            return
        }

        Task {
            let transactions = await searchTransactions.execute(query: query)
            self.filteredTransactions = groupAndSort(transactions: transactions)
        }
    }

    private func resolveDateRange(for period: String) -> (Date, Date?) {
        let now = Date()
        let calendar = Calendar.current

        switch period {
        case "This month":
            return (now.startOfMonth(), now.endOfMonth())
        case "Last month":
            guard let lastMonth = calendar.date(byAdding: .month, value: -1, to: now) else {
                return (now, nil)
            }
            return (lastMonth.startOfMonth(), lastMonth.endOfMonth())
        case "Future":
            guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: now) else {
                return (now, nil)
            }
            return (nextMonth.startOfMonth(), nil)
        default:
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            if let date = formatter.date(from: period) {
                return (date.startOfMonth(), date.endOfMonth())
            } else {
                return (now.startOfMonth(), now.endOfMonth())
            }
        }
    }

    private func groupAndSort(transactions: [TransactionCasha]) -> [TransactionDateSection] {
        let grouped = Dictionary(grouping: transactions) { transaction in
            DateHelper.format(transaction.datetime, style: .sectionDate)
        }

        let sections = grouped.map { dateString, items in
            TransactionDateSection(
                date: dateString,
                day: DateHelper.format(items.first?.datetime ?? Date(), style: .dayName),
                items: items.sorted { $0.datetime > $1.datetime }
            )
        }

        return sections.sorted {
            guard let d1 = DateHelper.date(from: $0.date, style: .sectionDate),
                  let d2 = DateHelper.date(from: $1.date, style: .sectionDate) else {
                return false
            }
            return d1 > d2
        }
    }
}

// MARK: - Date helpers
extension Date {
    func startOfMonth() -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) ?? self
    }

    func endOfMonth() -> Date {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth()) ?? self
    }
}

