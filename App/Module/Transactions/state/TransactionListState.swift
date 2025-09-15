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
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let getTransactionsByPeriod: GetTransactionsByPeriodUseCase
    private let searchTransactions: SearchTransactionsUseCase
    private let transactionSyncUsecase: TransactionSyncUseCase
    private var selectedPeriod: String = "This month"
    private var searchQuery: String = ""

    init(
        getTransactionsByPeriod: GetTransactionsByPeriodUseCase,
        searchTransactions: SearchTransactionsUseCase,
        transactionSyncUsecase: TransactionSyncUseCase
    ) {
        self.getTransactionsByPeriod = getTransactionsByPeriod
        self.searchTransactions = searchTransactions
        self.transactionSyncUsecase = transactionSyncUsecase
    }

    @MainActor
    func load() async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            if searchQuery.isEmpty {
                try await filterTransactions(by: selectedPeriod)
            } else {
                try await searchTransactions(with: searchQuery)
            }
        } catch {
            errorMessage = "Failed to load transactions: \(error.localizedDescription)"
            print("❌ Load error: \(error)")
        }
    }

    @MainActor
    func filterTransactions(by period: String) async throws {
        isSearching = false
        selectedPeriod = period
        errorMessage = nil
        
        let (start, end) = DateHelper.resolveDateRange(for: period)
        let transactions = try await getTransactionsByPeriod.execute(startDate: start, endDate: end)
        self.filteredTransactions = groupAndSort(transactions: transactions)
    }

    @MainActor
    func searchTransactions(with query: String) async throws {
        searchQuery = query
        isSearching = !query.isEmpty
        errorMessage = nil

        guard !query.isEmpty else {
            try await filterTransactions(by: selectedPeriod)
            return
        }

        // Add debouncing with proper async/await
        try await Task.sleep(nanoseconds: 300_000_000) // 300ms debounce
        
        // Check if search query hasn't changed during debounce
        guard searchQuery == query else { return }
        
        let transactions = try await searchTransactions.execute(query: query)
        self.filteredTransactions = groupAndSort(transactions: transactions)
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
    
    @MainActor
    func updateTransaction(_ transaction: TransactionCasha) async {
        errorMessage = nil
        
        do {
            let request = UpdateTransactionRequest(
                name: transaction.name,
                amount: transaction.amount,
                category: transaction.category
            )
            
            try await transactionSyncUsecase.syncUpdateTransaction(
                id: transaction.id,
                request: request
            )
            
            // Reload UI after update
            try await reloadCurrentData()
            
        } catch {
            errorMessage = "Failed to update transaction: \(error.localizedDescription)"
            print("❌ Update error: \(error)")
        }
    }

    @MainActor
    func deleteTransaction(id: String) async {
        errorMessage = nil
        
        do {
            try await transactionSyncUsecase.syncDeleteTransaction(id: id)
            
            // Reload UI after delete
            try await reloadCurrentData()
            
        } catch {
            errorMessage = "Failed to delete transaction: \(error.localizedDescription)"
            print("❌ Delete error: \(error)")
        }
    }
    
    @MainActor
    private func reloadCurrentData() async throws {
        if isSearching {
            try await searchTransactions(with: searchQuery)
        } else {
            try await filterTransactions(by: selectedPeriod)
        }
    }
    
    // Optional: Clear error message
    @MainActor
    func clearError() {
        errorMessage = nil
    }
    
    // Optional: Refresh data without loading indicator
    @MainActor
    func refresh() async {
        errorMessage = nil
        do {
            try await reloadCurrentData()
        } catch {
            errorMessage = "Failed to refresh: \(error.localizedDescription)"
        }
    }
}
