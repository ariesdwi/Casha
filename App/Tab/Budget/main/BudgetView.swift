import SwiftUI
import Domain
import Core

struct BudgetView: View {
    @EnvironmentObject var state: BudgetState
    @State private var selectedMonthYear: String = ""
    @State private var showingAddBudget = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Inline error banner
            if let error = state.errorMessage {
                ToastView(message: error)
                    .padding(.bottom, 50)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation { state.errorMessage = nil }
                        }
                    }
            }
            
            // 👇 Month/year filter bar
            ScrollView {
                VStack(spacing: 20) {
                    SummaryView(summary: state.budgetSummary, month: selectedMonthYear)
                    BudgetsHeaderView(count: state.budgets.count)
                    BudgetListView(budgets: state.budgets)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Budgets")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            loadingIndicator
            addBudgetButton
            monthFilterButton
        }
        .sheet(isPresented: $showingAddBudget) {
            AddBudgetView { newBudget in
                Task { await state.addBudget(request: newBudget) }
            }
        }
        .task {
            let current = DateHelper.generateMonthYearOptions().first ?? ""
            selectedMonthYear = current
            
            await state.refreshBudgetData(monthYear: current)
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

private extension BudgetView {
    var monthFilterButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            // Generate month options once
            let monthOptions = DateHelper.generateMonthYearOptions()

            Menu {
                ForEach(monthOptions, id: \.self) { option in
                    Button {
                        selectedMonthYear = option
                        Task {
                            await state.refreshBudgetData(monthYear: option)
                        }
                    } label: {
                        HStack {
                            Text(option)
                            if option == selectedMonthYear {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.headline)
                    .foregroundColor(.cashaAccent)
            }
        }
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

