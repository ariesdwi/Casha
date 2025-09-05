//
//  BudgetSummaryView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 05/09/25.
//

import SwiftUI
import Domain
import Core

struct BudgetSummaryView: View {
    let summary: BudgetSummary

    private var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(currentMonth) Budget")
                .font(.headline)
                .foregroundColor(.primary)

            Text("\(CurrencyFormatter.format(summary.totalSpent)) of \(CurrencyFormatter.format(summary.totalBudget)) spent")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if summary.totalRemaining >= 0 {
                Text("Great job! You have \(CurrencyFormatter.format(summary.totalRemaining)) left.")
                    .font(.subheadline)
                    .foregroundColor(.green)
            } else {
                Text("You've exceeded your budget by \(CurrencyFormatter.format(summary.totalRemaining)).")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
