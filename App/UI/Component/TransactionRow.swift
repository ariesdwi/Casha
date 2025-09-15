//
//  TransactionRow.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 12/09/25.
//

import SwiftUI
import Domain
import Core

struct TransactionRow: View {
    let transaction: TransactionCasha
    let index: Int
    @Binding var selectedTransaction: TransactionCasha?
    @State private var isVisible = false

    // Custom init so selectedTransaction is optional
    init(
        transaction: TransactionCasha,
        index: Int,
        selectedTransaction: Binding<TransactionCasha?>? = nil
    ) {
        self.transaction = transaction
        self.index = index
        self._selectedTransaction = selectedTransaction ?? .constant(nil)
    }

    var body: some View {
        Button {
            selectedTransaction = transaction
        } label: {
            HStack(spacing: 16) {
                // Category icon with gradient background
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: iconForCategory(transaction.category))
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .medium))
                    )
                    .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)

                VStack(alignment: .leading, spacing: 6) {
                    Text(transaction.name)
                        .font(.body.weight(.medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    Text(DateHelper.format(transaction.datetime, style: .sectionDate))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text(transaction.amount, format: .currency(code: "IDR"))
                    .font(.body.weight(.semibold))
                    .foregroundColor(transaction.amount < 0 ? .red : Color.red.opacity(0.8))
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain) // removes highlight
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.05)) {
                isVisible = true
            }
        }
    }

    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "food": return "fork.knife"
        case "shopping": return "bag"
        case "transport": return "car"
        case "entertainment": return "film"
        case "utilities": return "bolt"
        default: return "creditcard"
        }
    }
}



