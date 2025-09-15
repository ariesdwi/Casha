//////
//////  ListHistoryTransaction.swift
//////  Casha
//////
//////  Created by PT Siaga Abdi Utama on 14/07/25.
//////
////
//
//
import SwiftUI
import Domain
import Core


struct TransactionListView: View {
    @State private var selectedMonth: String = "This month"
    @State private var searchText: String = ""
    @EnvironmentObject var state: TransactionListState
    @State private var isLoading = true
    @State private var showingRefreshIndicator = false
    @State private var selectedTransaction: TransactionCasha? = nil
    
    var body: some View {
        if #available(iOS 16.0, *) {
            if #available(iOS 17.0, *) {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Header
                        VStack(spacing: 0) {
                            SearchBar(text: $searchText)
                                .padding(.horizontal)
                                .padding(.top, 12)
                                .onChange(of: searchText) { newValue in
                                    Task {
                                       try await state.searchTransactions(with: newValue)
                                    }
                                }
                            
                            TransactionFilterBar(selected: $selectedMonth)
                                .padding(.top, 12)
                                .onChange(of: selectedMonth) { newValue in
                                    Task {
                                       try await state.filterTransactions(by: newValue)
                                    }
                                }
                        }
                        
                        // Content
                        if isLoading {
                            LoadingShimmerView()
                                .padding(.top)
                        } else if state.filteredTransactions.isEmpty {
                            Spacer()
                            EmptyStateView(message: "Transactions")
                            Spacer()
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 16) {
                                    ForEach(state.filteredTransactions) { section in
                                        TransactionCardView(
                                            section: section,
                                            selectedTransaction: $selectedTransaction
                                        )
                                        .transition(.asymmetric(
                                            insertion: .opacity.combined(with: .move(edge: .top)),
                                            removal: .opacity
                                        ))
                                    }
                                }
                                .padding()
                            }
                            .refreshable {
                                await refreshData()
                            }
                        }
                    }
                }
                .background(Color.clear)
                .navigationTitle("Transactions")
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(.hidden, for: .navigationBar)
                .navigationDestination(item: $selectedTransaction) { transaction in
                    TransactionDetailView(transaction: transaction)
                }
                .task {
                    isLoading = false
                    await state.load()
                }
            } else {
                Text("Requires iOS 17 or later")
            }
        } else {
            Text("Requires iOS 16 or later")
        }
    }
    
    private func refreshData() async {
        showingRefreshIndicator = true
        await state.load()
        showingRefreshIndicator = false
    }
}


