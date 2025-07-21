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
    @StateObject private var state = TransactionListState()

    var body: some View {
        VStack(spacing: 0) {
            // Month filter horizontal scroll
            TransactionFilterBar(selected: $selectedMonth)
                .onChange(of: selectedMonth) { newValue in
                    state.filterTransactions(by: newValue)
                }

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(state.filteredTransactions) { section in
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
        .onAppear {
            state.loadTransactions()
        }
    }
}




//#Preview {
//    TransactionListView()
//}
