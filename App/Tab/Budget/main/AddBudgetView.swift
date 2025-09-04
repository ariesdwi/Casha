//
//  AddBudgetView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 29/08/25.
//
import SwiftUI
import Domain

struct AddBudgetView: View {
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    @State private var amount: String = ""
    @State private var selectedPeriod: String = "monthly"
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var selectedCategory: String = ""
    
    @State private var errorMessage: String? = nil
    
    // MARK: - Callback
    let onSave: (NewBudgetRequest) -> Void
    
    // MARK: - Static Data
    private let periods = ["daily", "weekly", "monthly", "yearly"]
    private let categories = ["Food", "Shopping", "Entertainment", "Transportation", "Utilities", "Rent", "Other"]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Budget Details")) {
                    
                    // Amount Field
                    TextField("Enter amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Period", selection: $selectedPeriod) {
                        ForEach(periods, id: \.self) { period in
                            Text(period.capitalized).tag(period)
                        }
                    }
                    
                    Picker("Category", selection: $selectedCategory) {
                        Text("Select Category").tag("")
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }
                
                Section(header: Text("Date Range")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: .date)
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
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveBudget()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    // MARK: - Helpers
    private var isFormValid: Bool {
        guard let amountValue = Double(amount), amountValue > 0 else { return false }
        return !selectedCategory.isEmpty && endDate >= startDate
    }
    
    private func saveBudget() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            errorMessage = "Please enter a valid amount greater than 0"
            return
        }
        
        guard endDate >= startDate else {
            errorMessage = "End date must be after start date"
            return
        }
        
        let newBudget = NewBudgetRequest(
            amount: amountValue,
            period: selectedPeriod,
            startDate: Self.dateFormatter.string(from: startDate),
            endDate: Self.dateFormatter.string(from: endDate),
            category: selectedCategory
        )
        
        onSave(newBudget)
        dismiss()
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

