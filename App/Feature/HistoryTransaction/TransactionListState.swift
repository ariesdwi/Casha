//
//  TransactionState.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//


import Foundation
import Domain
import Data

final class TransactionListState: ObservableObject {
    @Published var allTransactions: [TransactionCasha] = []
    @Published var filteredTransactions: [TransactionDateSection] = []

    private let repository = TransactionRepositoryImpl()

    private let sectionDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()

    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    func loadTransactions() {
        Task {
            let data = await repository.fetchRecentTransactions(limit: 100)
            DispatchQueue.main.async {
                self.allTransactions = data
                self.filterTransactions(by: "This month")
            }
        }
    }

    func filterTransactions(by month: String) {
        let calendar = Calendar.current
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM/yyyy"

        let currentMonth = monthFormatter.string(from: Date())

        let filtered = allTransactions.filter { tx in
            let txMonth = monthFormatter.string(from: tx.datetime)
            return month == "This month" ? txMonth == currentMonth : txMonth == month
        }

        let grouped = Dictionary(grouping: filtered) { tx in
            sectionDateFormatter.string(from: tx.datetime)
        }

        let sections: [TransactionDateSection] = grouped.map { date, items in
            let day = dayFormatter.string(from: items.first?.datetime ?? Date())
            return TransactionDateSection(date: date, day: day, items: items)
        }

        self.filteredTransactions = sections.sorted { lhs, rhs in
            guard let lhsDate = sectionDateFormatter.date(from: lhs.date),
                  let rhsDate = sectionDateFormatter.date(from: rhs.date) else {
                return false
            }
            return lhsDate > rhsDate
        }
    }
}

