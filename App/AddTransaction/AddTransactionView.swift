////
////  AddTransactionView.swift
////  Casha
////
////  Created by PT Siaga Abdi Utama on 05/09/25.
////
//
//import SwiftUI
//import Domain
//import Core
//
//struct AddTransactionView: View {
//    @Environment(\.dismiss) private var dismiss
//    
//    // MARK: - State
//    @State private var name: String = ""
//    @State private var amount: String = ""
//    @State private var selectedCategory: String = ""
//    @State private var datetime: Date = Date()
//    @State private var isConfirm: Bool = false
//    
//    @State private var errorMessage: String? = nil
//    
//    // MARK: - Callback
//    let onSave: (TransactionCasha) -> Void
//    
//    // MARK: - Static Data
//    private let categories = [
//        "Food",             // Restaurants, groceries, cafes
//        "Shopping",         // Clothes, electronics, goods
//        "Entertainment",    // Movies, games, events, hobbies
//        "Transportation",   // Gas, public transport, taxis, flights
//        "Utilities",        // Electricity, water, internet, phone
//        "Rent",             // Housing payments
//        "Healthcare",       // Doctor visits, medicine, insurance
//        "Education",        // Tuition, courses, books
//        "Travel",           // Hotels, flights, tours
//        "Subscriptions",    // Netflix, Spotify, apps
//        "Gifts",            // Presents, donations
//        "Investments",      // Stocks, crypto, funds
//        "Taxes",            // Income tax, property tax
//        "Insurance",        // Life, car, health
//        "Savings",          // Bank deposits, emergency funds
//        "Other"             // Anything else not listed
//    ]
//    
//    // MARK: - Body
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Transaction Details")) {
//                    
//                    // Name Field
//                    TextField("Transaction name", text: $name)
//                    
//                    // Amount Field
//                    TextField("Enter amount", text: $amount)
//                        .keyboardType(.numberPad)
//                        .onChange(of: amount) { newValue in
//                            // Format with your CurrencyFormatter
//                            let formatted = CurrencyFormatter.format(input: newValue)
//                            if formatted != amount {
//                                amount = formatted
//                            }
//                        }
//
//                    
//                    Picker("Category", selection: $selectedCategory) {
//                        Text("Select Category").tag("")
//                        ForEach(categories, id: \.self) { category in
//                            Text(category).tag(category)
//                        }
//                    }
//                    
//                }
//                
//                Section(header: Text("Date & Time")) {
//                    DatePicker("Date & Time", selection: $datetime, displayedComponents: [.date, .hourAndMinute])
//                }
//                
//                if let errorMessage {
//                    Section {
//                        Text(errorMessage)
//                            .font(.footnote)
//                            .foregroundColor(.red)
//                    }
//                }
//            }
//            .navigationTitle("Add Transaction")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Save") {
//                        saveTransaction()
//                    }
//                    .disabled(!isFormValid)
//                }
//            }
//        }
//    }
//    
//    // MARK: - Helpers
//    private var isFormValid: Bool {
//        guard let amountValue = Double(amount), amountValue > 0 else { return false }
//        return !name.isEmpty && !selectedCategory.isEmpty
//    }
//    
//    private func saveTransaction() {
//        guard let amountValue = Double(amount), amountValue > 0 else {
//            errorMessage = "Please enter a valid amount greater than 0"
//            return
//        }
//        
//        guard !name.isEmpty else {
//            errorMessage = "Please enter a transaction name"
//            return
//        }
//        
//        guard !selectedCategory.isEmpty else {
//            errorMessage = "Please select a category"
//            return
//        }
//        
//        // Generate local UUID
//        let id = UUID().uuidString
//        let currentDate = Date()
//        
//        let newTransaction = TransactionCasha(
//            id: id,
//            name: name,
//            category: selectedCategory,
//            amount: amountValue,
//            datetime: datetime,
//            isConfirm: isConfirm,
//            createdAt: currentDate,
//            updatedAt: currentDate
//        )
//        
//        onSave(newTransaction)
//        dismiss()
//    }
//}



import SwiftUI
import Domain
import Core

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var selectedCategory: String = ""
    @State private var datetime: Date = Date()
    @State private var isConfirm: Bool = false
    
    @State private var errorMessage: String? = nil
    
    // MARK: - Callback
    let onSave: (TransactionCasha) -> Void
    
    // MARK: - Static Data
    private let categories = [
        "Food", "Shopping", "Entertainment", "Transportation", "Utilities",
        "Rent", "Healthcare", "Education", "Travel", "Subscriptions",
        "Gifts", "Investments", "Taxes", "Insurance", "Savings", "Other"
    ]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Transaction Details")) {
                    
                    TextField("Transaction name", text: $name)
                    
                    TextField("Enter amount", text: $amount)
                        .keyboardType(.numberPad)
                        .onChange(of: amount) { newValue in
                            let formatted = CurrencyFormatter.format(input: newValue)
                            if formatted != amount {
                                amount = formatted
                            }
                        }
                    
                    Picker("Category", selection: $selectedCategory) {
                        Text("Select Category").tag("")
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }
                
                Section(header: Text("Date & Time")) {
                    DatePicker("Date & Time", selection: $datetime, displayedComponents: [.date, .hourAndMinute])
                }
                
                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveTransaction() }
                        .disabled(!isFormValid)
                }
            }
        }
    }
    
    // MARK: - Helpers
    private var isFormValid: Bool {
        let rawAmount = CurrencyFormatter.extractRawValue(from: amount)
        return rawAmount > 0 && !selectedCategory.isEmpty
    }
    
   
    
    private func saveTransaction() {
        let amountValue = CurrencyFormatter.extractRawValue(from: amount)
        guard amountValue > 0 else {
            errorMessage = "Please enter a valid amount greater than 0"
            return
        }
        guard !name.isEmpty else {
            errorMessage = "Please enter a transaction name"
            return
        }
        guard !selectedCategory.isEmpty else {
            errorMessage = "Please select a category"
            return
        }
        
        let newTransaction = TransactionCasha(
            id: UUID().uuidString,
            name: name,
            category: selectedCategory,
            amount: amountValue,
            datetime: datetime,
            isConfirm: isConfirm,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        onSave(newTransaction)
        dismiss()
    }
}
