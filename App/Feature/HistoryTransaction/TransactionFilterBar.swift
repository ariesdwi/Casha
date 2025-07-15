//
//  tr.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//

import SwiftUI

struct TransactionFilterBar: View {
    @Binding var selected: String
    let options: [String] = ["04 / 2025", "05 / 2025", "Last month", "This month", "Future"]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selected = option
                    }) {
                        Text(option)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 14)
                            .background(selected == option ? Color.cashaPrimary : Color(.systemGray5))
                            .foregroundColor(selected == option ? .white : .black)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
        }
    }
}
