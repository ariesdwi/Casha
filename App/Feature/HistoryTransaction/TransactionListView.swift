//
//  ListHistoryTransaction.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//

import SwiftUI
import Domain

struct TransactionListView: View {
    @State private var selectedMonth: String = "This month"
    @State private var transactionsByDate: [TransactionDateSection] = TransactionDateSection.sampleData

    var body: some View {
        VStack(spacing: 0) {
            TransactionFilterBar(selected: $selectedMonth)

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(transactionsByDate) { section in
                        TransactionCardView(section: section)
                    }
                }
                .padding()
            }
        }
        .background(Color.cashaBackground.ignoresSafeArea())
        .navigationTitle("Transaction")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { print("Camera tapped") }) {
                    Image(systemName: "camera")
                        .foregroundColor(.cashaPrimary)
                }
                Button(action: { print("Add tapped") }) {
                    Image(systemName: "plus")
                        .foregroundColor(.cashaPrimary)
                }
            }
        }
    }
}



//#Preview {
//    TransactionListView()
//}
