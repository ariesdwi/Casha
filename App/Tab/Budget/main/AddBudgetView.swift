//////
//////  AddBudgetView.swift
//////  Casha
//////
//////  Created by PT Siaga Abdi Utama on 29/08/25.
///
import SwiftUI
import Domain
import Core

struct AddBudgetView: View {
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    @State private var amount: String = ""
    @State private var selectedMonth: String = ""
    @State private var selectedCategory: String = ""
    @State private var errorMessage: String? = nil
    
    // MARK: - Callback
    let onSave: (NewBudgetRequest) -> Void
    
    // MARK: - Categories
    private let categories = [
        "Food", "Shopping", "Entertainment", "Transportation", "Utilities",
        "Rent", "Healthcare", "Education", "Travel", "Subscriptions",
        "Gifts", "Investments", "Taxes", "Insurance", "Savings", "Other"
    ]
    
    // MARK: - Month Year Options
    private let monthYearOptions: [String] = {
        let calendar = Calendar.current
        let currentDate = Date()
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        
        let months = ["January", "February", "March", "April", "May", "June",
                     "July", "August", "September", "October", "November", "December"]
        
        var options: [String] = []
        
        // Current year + next year
        for year in [currentYear, currentYear + 1] {
            let startMonth = year == currentYear ? currentMonth : 1
            for month in startMonth...12 {
                options.append("\(months[month - 1]) \(year)")
            }
        }
        
        return options
    }()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Budget Details")) {
                    
                    // Amount Field with live IDR formatting
                    TextField("Enter amount", text: $amount)
                        .keyboardType(.numberPad)
                        .onChange(of: amount) { newValue in
                            let formatted = CurrencyFormatter.format(input: newValue)
                            if formatted != amount {
                                amount = formatted
                            }
                        }
                    
                    // Month + Year Picker
                    Picker("Month", selection: $selectedMonth) {
                        Text("Select Month").tag("")
                        ForEach(monthYearOptions, id: \.self) { monthYear in
                            Text(monthYear).tag(monthYear)
                        }
                    }
                    
                    // Category Picker
                    Picker("Category", selection: $selectedCategory) {
                        Text("Select Category").tag("")
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }
                
                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Add Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveBudget() }
                        .disabled(!isFormValid)
                }
            }
            .onAppear {
                // Set default selection to current month if not already set
                if selectedMonth.isEmpty {
                    let currentMonthYear = Self.monthYearFormatter.string(from: Date())
                    selectedMonth = currentMonthYear
                }
            }
        }
    }
    
    // MARK: - Helpers
    private var isFormValid: Bool {
        let rawAmount = CurrencyFormatter.extractRawValue(from: amount)
        return rawAmount > 0 && !selectedCategory.isEmpty && !selectedMonth.isEmpty
    }
    
    private func saveBudget() {
        let rawAmount = CurrencyFormatter.extractRawValue(from: amount)
        guard rawAmount > 0 else {
            errorMessage = "Please enter a valid amount greater than 0"
            return
        }
        guard !selectedCategory.isEmpty else {
            errorMessage = "Please select a category"
            return
        }
        guard !selectedMonth.isEmpty else {
            errorMessage = "Please select a month"
            return
        }
        
        let newBudget = NewBudgetRequest(
            amount: rawAmount,
            month: selectedMonth,
            category: selectedCategory
        )
        
        onSave(newBudget)
        dismiss()
    }
    
    private static let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
}
