//
//  TransactionDetailView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 11/09/25.
//


import SwiftUI
import Domain

struct TransactionDetailView: View {
    let initialTransaction: TransactionCasha // Change to initialTransaction
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @EnvironmentObject var state: TransactionListState
    @State private var currentTransaction: TransactionCasha // Add state to hold current data
    
    init(transaction: TransactionCasha) {
        self.initialTransaction = transaction
        _currentTransaction = State(initialValue: transaction)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section - use currentTransaction
                headerSection
                
                // Amount & Status Section - use currentTransaction
                amountStatusSection
                
                // Category Section - use currentTransaction
                categorySection
                
                // Details Section - use currentTransaction
                detailsSection
                
                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Transaction Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit Transaction", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete Transaction", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationView {
                TransactionEditView(transaction: currentTransaction) { updatedTransaction in
                    // Update the current transaction with the edited data
                    currentTransaction = updatedTransaction
                    
                    // Optional: Refresh the list state if needed
                    Task {
                        await state.load()
                    }
                }
            }
        }
        .alert("Delete Transaction", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteTransaction()
            }
        } message: {
            Text("Are you sure you want to delete this transaction? This action cannot be undone.")
        }
    }
    
    // MARK: - Header Section (updated to use currentTransaction)
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "arrow.down.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
                .padding()
                .background(
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 80, height: 80)
                )
            
            Text(currentTransaction.name) // Use currentTransaction
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Amount & Status Section (updated to use currentTransaction)
    private var amountStatusSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("Amount Spent")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(amountFormatted) // This uses currentTransaction via computed property
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.red)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Details Section (updated to use currentTransaction)
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Transaction Details")
                .font(.headline)
                .padding(.bottom, 4)
            
            detailRow(title: "Date", value: fullDateFormatted) // Uses currentTransaction
            detailRow(title: "Updated", value: updatedAtFormatted) // Uses currentTransaction
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Category Section (updated to use currentTransaction)
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category")
                .font(.headline)
            
            HStack {
                Image(systemName: "tag.fill")
                    .foregroundColor(.blue)
                
                Text(currentTransaction.category) // Use currentTransaction
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Helper Views
    private func detailRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
            
            Spacer()
        }
    }
    
    // MARK: - Computed Properties (updated to use currentTransaction)
    private var amountFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: NSNumber(value: abs(currentTransaction.amount))) ?? "Rp \(Int(abs(currentTransaction.amount)))"
    }
    
    private var fullDateFormatted: String {
        DateFormatter.localizedString(from: currentTransaction.datetime, dateStyle: .full, timeStyle: .none)
    }
    
    private var timeFormatted: String {
        DateFormatter.localizedString(from: currentTransaction.datetime, dateStyle: .none, timeStyle: .short)
    }
    
    private var createdAtFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: currentTransaction.createdAt)
    }
    
    private var updatedAtFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: currentTransaction.updatedAt)
    }
    
    // MARK: - Actions
    private func deleteTransaction() {
        Task {
            await state.deleteTransaction(id: currentTransaction.id)
            dismiss()
        }
    }
}

// MARK: - Preview
//#Preview {
//    NavigationView {
//        TransactionDetailView(transaction: TransactionCasha(
//            id: "trans_123456789",
//            name: "Grocery Shopping at Supermarket",
//            category: "Food & Beverages",
//            amount: -250000,
//            datetime: Date(),
//            isConfirm: true,
//            createdAt: Date().addingTimeInterval(-86400),
//            updatedAt: Date()
//        ))
//        .environmentObject(TransactionListState())
//    }
//}
