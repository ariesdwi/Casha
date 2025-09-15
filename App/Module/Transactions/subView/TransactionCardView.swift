////
//////
//////  TransactionCardView.swift
//////  Casha
//////
//////  Created by PT Siaga Abdi Utama on 15/07/25.
//////
////

import SwiftUI
import Domain
import Core


struct TransactionCardView: View {
    let section: TransactionDateSection
    @State private var isExpanded = true
    @Binding var selectedTransaction: TransactionCasha?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with smooth expand/collapse
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(section.day)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(section.date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    let totalAmount = section.items.reduce(0) { $0 + $1.amount }
                    Text("\(section.items.count) transactions • \(totalAmount, format: .currency(code: "IDR"))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            // Transactions list with smooth appearance
            if isExpanded {
                LazyVStack(spacing: 0) {
                    ForEach(Array(section.items.enumerated()), id: \.element.id) { index, transaction in
                        TransactionRow(transaction: transaction, index: index, selectedTransaction: $selectedTransaction) // Pass binding
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                        
                        if index < section.items.count - 1 {
                            Divider()
                                .padding(.leading, 52)
                        }
                    }
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.top, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}



