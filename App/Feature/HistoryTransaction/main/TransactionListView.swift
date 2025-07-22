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
    @State private var searchText: String = ""
    @StateObject private var state = TransactionListState()

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            SearchBar(text: $searchText)
                .padding(.horizontal)
                .padding(.top, 8)
                .onChange(of: searchText) { newValue in
                    state.searchTransactions(with: newValue)
                }
            
            // Month filter horizontal scroll
            TransactionFilterBar(selected: $selectedMonth)
                .onChange(of: selectedMonth) { newValue in
                    state.filterTransactions(by: newValue)
                }

            ScrollView {
                VStack(spacing: 16) {
                    if state.filteredTransactions.isEmpty {
                        EmptyStateView()
                    } else {
                        ForEach(state.filteredTransactions) { section in
                            TransactionCardView(section: section)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.cashaBackground.ignoresSafeArea())
        .navigationTitle("Transaction")
        .onAppear {
            state.loadTransactions()
        }
    }
}




//#Preview {
//    TransactionListView()
//}
