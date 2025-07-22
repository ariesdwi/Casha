//
//  Tran.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//

import SwiftUI
import Domain
import Core

struct TransactionCardView: View {
    let section: TransactionDateSection

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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

            ForEach(section.items) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.category)
                            .font(.subheadline)
                        Text(item.name)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Text(CurrencyFormatter.format(Double(item.amount)))
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    
}
