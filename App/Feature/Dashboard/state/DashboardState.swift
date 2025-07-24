//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import Foundation
import Domain
import Data
import Core

final class DashboardState: ObservableObject {
    @Published var recentTransactions: [TransactionCasha] = []
    @Published var totalSpending: Double = 0.0
    @Published var report: SpendingReport = SpendingReport(
        thisWeekTotal: 0,
        thisMonthTotal: 0,
        dailyBars: [],
        weeklyBars: []
    )
    
    @Published var messageInput: String = ""
    @Published var selectedImageURL: URL? = nil
    @Published var isSending: Bool = false
    @Published var errorMessage: String?

    private let getRecentTransactions: GetRecentTransactionsUseCase
    private let getTotalSpending: GetTotalSpendingUseCase
    private let getSpendingReport: GetSpendingReportUseCase
    private let transactionSyncManager: TransactionSyncManager

    init(
        getRecentTransactions: GetRecentTransactionsUseCase,
        getTotalSpending: GetTotalSpendingUseCase,
        getSpendingReport: GetSpendingReportUseCase,
        transactionSyncManager: TransactionSyncManager
    ) {
        self.getRecentTransactions = getRecentTransactions
        self.getTotalSpending = getTotalSpending
        self.getSpendingReport = getSpendingReport
        self.transactionSyncManager = transactionSyncManager

    }

    @MainActor
    func loadData() {
        Task {
            async let recentTransactionsTask = getRecentTransactions.execute(limit: 5)
            async let totalSpendingTask = getTotalSpending.execute()
            async let spendingReportTask = getSpendingReport.execute()

            let (transactions, spending, reportResults) = await (
                recentTransactionsTask,
                totalSpendingTask,
                spendingReportTask
            )

            self.recentTransactions = transactions
            self.totalSpending = spending
            
            if let result = reportResults.first {
                self.report = result
            }
        }
    }
    
    @MainActor
     func sendTransaction() {
         guard !messageInput.isEmpty || selectedImageURL != nil else {
             errorMessage = "Please input a message or select an image"
             return
         }

         Task {
             isSending = true
             errorMessage = nil

             let request = AddTransactionRequest(
                 message: messageInput.isEmpty ? nil : messageInput,
                 imageURL: selectedImageURL
             )

             do {
                 try await transactionSyncManager.syncAddTransaction(request)
                 messageInput = ""
                 selectedImageURL = nil
                 loadData() // Reload dashboard data after successful sync
             } catch {
                
                 errorMessage = error.localizedDescription
                 print(errorMessage)
             }

             isSending = false
         }
     }
}


