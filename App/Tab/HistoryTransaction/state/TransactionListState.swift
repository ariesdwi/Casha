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
            let (start, end) = DateHelper.resolveDateRange(for: period)
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
            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms debounce
            let transactions = await searchTransactions.execute(query: query)
            self.filteredTransactions = groupAndSort(transactions: transactions)
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



