//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 11/09/25.
//


import SwiftUI
import Domain

struct TransactionEditView: View {
    let transaction: TransactionCasha
    var onSave: ((TransactionCasha) -> Void)? // Add callback
    @EnvironmentObject var state: TransactionListState
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var amount: String
    @State private var selectedCategory: String
    
    private let categories = [
        "Food", "Shopping", "Entertainment", "Transportation", "Utilities",
        "Rent", "Healthcare", "Education", "Travel", "Subscriptions",
        "Gifts", "Investments", "Taxes", "Insurance", "Savings", "Other"
    ]
    
    init(transaction: TransactionCasha, onSave: ((TransactionCasha) -> Void)? = nil) {
        self.transaction = transaction
        self.onSave = onSave
        _name = State(initialValue: transaction.name)
        _amount = State(initialValue: String(transaction.amount))
        _selectedCategory = State(initialValue: transaction.category ?? "Other")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Transaction Details")) {
                TextField("Name", text: $name)
                
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
        .navigationTitle("Edit Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        await saveChanges()
                    }
                    dismiss()
                }
                .disabled(!isFormValid)
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !amount.isEmpty && Double(amount) != nil
    }
    
    private func saveChanges() async {
        guard let newAmount = Double(amount) else { return }
        
        let updated = TransactionCasha(
            id: transaction.id,
            name: name,
            category: selectedCategory,
            amount: newAmount,
            datetime: transaction.datetime,
            isConfirm: transaction.isConfirm,
            createdAt: transaction.createdAt,
            updatedAt: Date()
        )
        
        await state.updateTransaction(updated)
        
        // Call the callback with the updated transaction
        onSave?(updated)
    }
}
