////
////  RecentTransactionList.swift
////  Casha
////
////  Created by PT Siaga Abdi Utama on 17/07/25.


import SwiftUI
import Domain
import Core

struct RecentTransactionList: View {
    let transactions: [TransactionCasha]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(transactions) { transaction in
                NavigationLink(destination: TransactionDetailView(transaction: transaction)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.category)
                                .font(.subheadline)
                            Text(transaction.name)
                                .font(.caption)
                            Text(DateHelper.format(transaction.datetime, style: .sectionDate))
                                .font(.caption)
                        }
                        Spacer()
                        Text(CurrencyFormatter.format(transaction.amount))
                            .fontWeight(.bold)
                            .foregroundColor(Color(.red))
                            
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
                }
                .buttonStyle(.plain)
            }
        }
    }
}



