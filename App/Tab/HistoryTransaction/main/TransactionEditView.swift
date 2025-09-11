//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 11/09/25.
//


import SwiftUI
import Domain
//
//struct TransactionEditView: View {
//    let transaction: TransactionCasha
//    @EnvironmentObject var state: TransactionListState
//    @Environment(\.dismiss) private var dismiss
//    @State private var name: String
//    @State private var amount: String
//    @State private var selectedCategory: String
//    
//    init(transaction: TransactionCasha) {
//        self.transaction = transaction
//        _name = State(initialValue: transaction.name)
//        _amount = State(initialValue: String(transaction.amount))
//        _selectedCategory = State(initialValue: transaction.category ?? "")
//    }
//    
//    var body: some View {
//        Form {
//            Section(header: Text("Transaction Details")) {
//                TextField("Name", text: $name)
//                TextField("Amount", text: $amount)
//                    .keyboardType(.decimalPad)
//                TextField("Category", text: $selectedCategory)
//            }
//        }
//        .navigationTitle("Edit Transaction")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .cancellationAction) {
//                Button("Cancel") {
//                    dismiss()
//                }
//            }
//            
//            ToolbarItem(placement: .confirmationAction) {
//                Button("Save") {
//                    Task {
//                        await saveChanges()
//                    }
//                   
//                    dismiss()
//                }
//                .disabled(!isFormValid)
//            }
//        }
//    }
//    
//    private var isFormValid: Bool {
//        !name.isEmpty && !amount.isEmpty && Double(amount) != nil
//    }
//    
//    private func saveChanges() async {
//        // Implement your save logic here
//        print("Saving changes for transaction: \(name), \(amount), \(selectedCategory)")
//        // You would typically call a use case to update the transaction
//        
//        guard let newAmount = Double(amount) else { return }
//        
//        let updated = TransactionCasha(
//            id: transaction.id,
//            name: name,
//            category: selectedCategory,
//            amount: newAmount,
//            datetime: transaction.datetime,
//            isConfirm: transaction.isConfirm,
//            createdAt: transaction.createdAt,
//            updatedAt: Date() // 👈 refresh update timestamp
//        )
//        
//        await state.updateTransaction(updated)
//        await dismiss()
//        
//    }
//}



struct TransactionEditView: View {
    let transaction: TransactionCasha
    var onSave: ((TransactionCasha) -> Void)? // Add callback
    @EnvironmentObject var state: TransactionListState
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var amount: String
    @State private var selectedCategory: String
    
    init(transaction: TransactionCasha, onSave: ((TransactionCasha) -> Void)? = nil) {
        self.transaction = transaction
        self.onSave = onSave
        _name = State(initialValue: transaction.name)
        _amount = State(initialValue: String(transaction.amount))
        _selectedCategory = State(initialValue: transaction.category ?? "")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Transaction Details")) {
                TextField("Name", text: $name)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Category", text: $selectedCategory)
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
