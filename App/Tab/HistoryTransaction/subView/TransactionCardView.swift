
//
//  TransactionCardView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//

import SwiftUI
import Domain
import Core

struct TransactionCardView: View {
    let section: TransactionDateSection
    @State private var selectedTransaction: TransactionCasha?
    
    var body: some View {
        if #available(iOS 17.0, *) {
            VStack(alignment: .leading, spacing: 8) {
                // Section Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(section.date)
                            .font(.title.bold())
                        Text(section.day)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("- \(CurrencyFormatter.format(section.totalAmount))")
                        .font(.headline)
                        .foregroundColor(.red)
                }
                .padding(.bottom, 8)
                
                // Transaction Items
                ForEach(section.items) { item in
                    transactionRow(item)
                        .contentShape(Rectangle()) // Make entire row tappable
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .navigationDestination(item: $selectedTransaction) { transaction in
                TransactionDetailView(transaction: transaction)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - Transaction Row
    private func transactionRow(_ item: TransactionCasha) -> some View {
        Button {
            selectedTransaction = item
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.category)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Text(item.name)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
//                    // Show time if available
//                    Text(item.datetime, style: .time)
//                        .font(.caption2)
//                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("- \(CurrencyFormatter.format(Double(item.amount)))")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                    
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle()) // Remove default button styling
    }
}
