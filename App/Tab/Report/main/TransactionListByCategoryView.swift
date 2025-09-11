//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 11/09/25.
//


import SwiftUI
import Domain
import Core

struct TransactionListByCategoryView: View {
    let category: String
    @EnvironmentObject var reportState: ReportState
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    private var totalAmount: Double {
        reportState.transactionsByCategory.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            if isLoading {
                ProgressView("Loading transactions...")
                    .scaleEffect(1.2)
            } else if reportState.transactionsByCategory.isEmpty {
                EmptyStateView(message: category)
            } else {
                contentView
            }
        }
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .task {
            await loadTransactions()
        }
        .refreshable {
            await loadTransactions()
        }
    }
    
    private var contentView: some View {
        List {
            Section {
                SummaryCardView(totalAmount: totalAmount, transactionCount: reportState.transactionsByCategory.count)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }
            
            Section("Transactions") {
                ForEach(reportState.transactionsByCategory) { transaction in
                    TransactionRow(transaction: transaction)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                // Add delete functionality here
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .headerProminence(.increased)
        }
        .listStyle(.insetGrouped)
        .animation(.easeInOut(duration: 0.3), value: reportState.transactionsByCategory)
    }
    
    private func loadTransactions() async {
        isLoading = true
        do {
            try await Task.sleep(nanoseconds: 500_000_000) // Simulate loading
            await reportState.loadTransactionsByCategory(category: category)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        isLoading = false
    }
}

// MARK: - Supporting Views

struct TransactionRow: View {
    let transaction: TransactionCasha
    
    var body: some View {
        HStack(spacing: 16) {
            // Category icon placeholder - you can replace with actual icons
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "creditcard")
                        .foregroundColor(.blue)
                        .font(.system(size: 18))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("\(DateHelper.format(transaction.datetime, style: .sectionDate))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(transaction.amount, format: .currency(code: "IDR"))
                .font(.body.weight(.semibold))
                .foregroundColor(transaction.amount < 0 ? .red : .green)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

struct SummaryCardView: View {
    let totalAmount: Double
    let transactionCount: Int
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Total")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(totalAmount, format: .currency(code: "IDR"))
                        .font(.title2.weight(.bold))
                        .foregroundColor(totalAmount < 0 ? .red : .green)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Transactions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(transactionCount)")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.primary)
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding()
    }
}


