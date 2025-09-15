import SwiftUI
import Domain
import Core

struct BudgetView: View {
    @EnvironmentObject var state: BudgetState
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
            
            // Main content
            ScrollView {
                VStack(spacing: 20) {
                    SummaryView(summary: state.budgetSummary,
                                month: state.currentMonthYear ?? "")
                    
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
            await state.refreshBudgetData()
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
    
    var monthFilterButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            let monthOptions = DateHelper.generateMonthYearOptions()
            
            Menu {
                ForEach(monthOptions, id: \.self) { option in
                    Button {
                        Task {
                            await state.setMonth(option)
                        }
                    } label: {
                        HStack {
                            Text(option)
                            if option == state.currentMonthYear {
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



// MARK: - Header
private struct BudgetsHeaderView: View {
    let count: Int
    
    var body: some View {
        HStack {
            Text("Budget Categories")
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("\(count) \(count == 1 ? "category" : "categories")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

