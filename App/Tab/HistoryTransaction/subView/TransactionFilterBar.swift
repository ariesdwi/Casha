//
//  tr.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//

import SwiftUI
import Core

struct TransactionFilterBar: View {
    @Binding var selected: String
    @State private var monthOptions: [String] = []
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(monthOptions, id: \.self) { option in
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
        .onAppear {
            monthOptions = DateHelper.generateMonthOptions()
            selected = "This month" // Default selection
        }
    }
}
