//
//  ListHistoryTransaction.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//

import SwiftUI
import Domain
import Charts
import Core

struct TransactionListView: View {
    @State private var selectedMonth: String = "This month"
    @State private var searchText: String = ""
    @EnvironmentObject var state: TransactionListState
    
    var body: some View {
        if #available(iOS 16.0, *) {
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
                            EmptyStateView(message: "Transactions")
                        } else {
                            ForEach(state.filteredTransactions) { section in
                                TransactionCardView(section: section)
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color.clear)
            .navigationTitle("Transaction")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                state.load()
            }
        } else {
            // Fallback on earlier versions
        }
    }
}


