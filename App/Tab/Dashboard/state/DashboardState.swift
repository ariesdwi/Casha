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
    @Published public var isLoading: Bool = false
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
    func loadData() async {
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
    func sendTransaction() async {
        guard !messageInput.isEmpty || selectedImageURL != nil else {
            errorMessage = "Please input a message or select an image"
            return
        }

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
            await loadData()
        } catch {
            errorMessage = error.localizedDescription
        }

        isSending = false
    }

    @MainActor
    func sendTransactionFromImage() async {
        guard let imageURL = selectedImageURL else {
            errorMessage = "Please select an image first"
            return
        }

        isSending = true
        errorMessage = nil

        let request = AddTransactionRequest(
            message: nil,
            imageURL: imageURL
        )

        do {
            try await transactionSyncManager.syncAddTransaction(request)
            selectedImageURL = nil
            await loadData()
        } catch {
            errorMessage = error.localizedDescription
        }

        isSending = false
    }
    
    @MainActor
    func syncTransactionList() async {
        isLoading = true
        errorMessage = nil

        do {
            try await transactionSyncManager.syncAllTransactions(
                periodStart: "2025-07-01",
                periodEnd: "2025-07-30",
                page: 1,
                limit: 50
            )

            await loadData() // Refresh Core Data view
        } catch let networkError as NetworkError {
            switch networkError {
            case .serverError(let message):
                errorMessage = "Server error: \(message)"
            case .invalidResponse(let code):
                errorMessage = "Invalid response (code: \(code))"
            case .requestFailed(let description):
                errorMessage = "Request failed: \(description)"
            case .decodingFailed(let underlying):
                errorMessage = "Failed to decode response: \(underlying.localizedDescription)"
            case .invalidURL, .invalidRequest:
                errorMessage = "Invalid request"
            case .unknown(let err):
                errorMessage = "Unexpected error: \(err.localizedDescription)"
            }
            print("[Sync Error] \(errorMessage ?? "Unknown")")
        } catch {
            // fallback for non-NetworkError
            errorMessage = "Unexpected: \(error.localizedDescription)"
            print("[Sync Error] \(error.localizedDescription)")
        }
    }




}


