import SwiftUI
import Domain
import Core

struct BudgetView: View {
    @EnvironmentObject var state: BudgetState
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddBudget = false
    
    // Snackbar states
    @State private var showSnackbar = false
    @State private var snackbarMessage = ""
    @State private var snackbarIsError = false
    
    // Get current month name for the header
    private var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            
            if state.isLoading {
                ProgressView("Loading budgets...")
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        summarySection
                        budgetsHeader
                        budgetListOrEmptyState
                    }
                    .padding(.vertical)
                }
            }
            
            // Snackbar Overlay
            if showSnackbar {
                VStack {
                    Spacer()
                    SnackbarView(message: snackbarMessage, isError: snackbarIsError)
                        .onTapGesture {
                            withAnimation { showSnackbar = false }
                        }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut, value: showSnackbar)
                .zIndex(1)
            }
        }
        .navigationTitle("Budgets")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddBudget = true
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundColor(.cashaAccent)
                }
                .disabled(state.isLoading)
            }
        }
        .sheet(isPresented: $showingAddBudget) {
            AddBudgetView { newBudget in
                Task {
                    await state.addBudget(request: newBudget)
                }
            }
        }
        .task {
            await state.fetchBudgets()
            await state.fetchSummaryBudgets()
        }
        .onChange(of: state.errorMessage) { newValue in
            if let error = newValue {
                showSnackbarMessage(error, isError: true)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var summarySection: some View {
        Group {
            if let summary = state.budgetSummary {
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
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(currentMonth) Budget")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("No data available")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
    }
    
    private var budgetsHeader: some View {
        HStack {
            Text("Monthly Budgets")
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("\(state.budgets.count)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
    
    private var budgetListOrEmptyState: some View {
        Group {
            if state.budgets.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("No budgets yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Add a budget to start tracking your expenses")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(state.budgets) { budget in
                        BudgetCardView(budget: budget)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Methods
    
    private func showSnackbarMessage(_ message: String, isError: Bool) {
        snackbarMessage = message
        snackbarIsError = isError
        withAnimation { showSnackbar = true }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation { showSnackbar = false }
        }
    }
}
