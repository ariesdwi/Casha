
//
//  BudgetView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//

import SwiftUI
import Domain
import Core

struct BudgetView: View {
    @EnvironmentObject var state: BudgetState
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddBudget = false
    
    // Current month name
    private var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            VStack(spacing: 0) {
                // Inline banner for error messages
                if let error = state.errorMessage {
                    ErrorBanner(message: error)
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        SummaryView(summary: state.budgetSummary, month: currentMonth)
                        BudgetsHeaderView(count: state.budgets.count)
                        BudgetListView(budgets: state.budgets)
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    await state.fetchBudgets()
                    await state.fetchSummaryBudgets()
                }
            }
            .navigationTitle("Budgets")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                loadingIndicator
                addBudgetButton
            }
            .sheet(isPresented: $showingAddBudget) {
                AddBudgetView { newBudget in
                    Task { await state.addBudget(request: newBudget) }
                }
            }
            .task {
                await state.fetchBudgets()
                await state.fetchSummaryBudgets()
            }
        }
    }
}

// MARK: - Toolbar
private extension BudgetView {
    var loadingIndicator: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if state.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
    
    var addBudgetButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showingAddBudget = true
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundColor(.cashaAccent)
            }
        }
    }
}

// MARK: - Subviews

private struct SummaryView: View {
    let summary: BudgetSummary?
    let month: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(month) Budget")
                .font(.headline)
            
            if let summary {
                Text("\(CurrencyFormatter.format(summary.totalSpent)) of \(CurrencyFormatter.format(summary.totalBudget)) spent")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if summary.totalRemaining >= 0 {
                    Text("Great job! You have \(CurrencyFormatter.format(summary.totalRemaining)) left.")
                        .font(.subheadline)
                        .foregroundColor(.green)
                } else {
                    Text("You've exceeded your budget by \(CurrencyFormatter.format(abs(summary.totalRemaining))).")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            } else {
                Text("Loading...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .redacted(reason: .placeholder)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

private struct BudgetsHeaderView: View {
    let count: Int
    
    var body: some View {
        HStack {
            Text("Monthly Budgets")
                .font(.headline)
            Spacer()
            Text("\(count)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
}

private struct BudgetListView: View {
    let budgets: [BudgetCasha]
    
    var body: some View {
        if budgets.isEmpty {
            EmptyStateView(message: "Budgets")
        } else {
            LazyVStack(spacing: 12) {
                ForEach(budgets) { budget in
                    BudgetCardView(budget: budget)
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct ErrorBanner: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.red)
    }
}
