
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
