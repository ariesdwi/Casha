//
//  RecentTransactionList.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 17/07/25.
//
import SwiftUI
import Domain
import Core

struct RecentTransactionList: View {
    let transactions: [TransactionCasha]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(transactions) { transaction in
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
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
        }
    }
}

