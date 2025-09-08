

import Foundation
import Domain
import Data
import Core
import Network

@MainActor
final class DashboardState: ObservableObject {
    // Data
    @Published var recentTransactions: [TransactionCasha] = []
    @Published var totalSpending: Double = 0
    @Published var report: SpendingReport = SpendingReport(
        thisWeekTotal: 0,
        thisMonthTotal: 0,
        dailyBars: [],
        weeklyBars: []
    )
    
    // Input
    @Published var messageInput: String = ""
    @Published var selectedImageURL: URL? = nil
    
    // Metadata (instead of isLoading/spinners)
    @Published var unsyncedCount: Int = 0
    @Published var isOnline: Bool = false
    @Published var lastSyncTime: Date? = nil
    
    private var networkMonitor: NetworkMonitorProtocol
    private let getRecentTransactions: GetRecentTransactionsUseCase
    private let getTotalSpending: GetTotalSpendingUseCase
    private let getSpendingReport: GetSpendingReportUseCase
    private let transactionSyncManager: TransactionSyncManager
    
    private var lastSyncAttempt: Date = .distantPast
    
    init(
        getRecentTransactions: GetRecentTransactionsUseCase,
        getTotalSpending: GetTotalSpendingUseCase,
        getSpendingReport: GetSpendingReportUseCase,
        transactionSyncManager: TransactionSyncManager,
        networkMonitor: NetworkMonitorProtocol
    ) {
        self.getRecentTransactions = getRecentTransactions
        self.getTotalSpending = getTotalSpending
        self.getSpendingReport = getSpendingReport
        self.transactionSyncManager = transactionSyncManager
        self.networkMonitor = networkMonitor
        
        setupNetworkMonitoring()
    }
    
    // MARK: - Load Data (no blocking spinner)
    func refreshDashboard() async {
        async let tx = getRecentTransactions.execute(limit: 5)
        async let spending = getTotalSpending.execute()
        async let reports = getSpendingReport.execute()
        async let unsynced = transactionSyncManager.getUnsyncTransactionCount()
        
        do {
            let (transactions, spendingVal, reportsVal, unsyncedVal) = try await (tx, spending, reports, unsynced)
            self.recentTransactions = transactions
            self.totalSpending = spendingVal
            self.report = reportsVal.first ?? self.report
            self.unsyncedCount = unsyncedVal
        } catch {
            print("⚠️ Refresh failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Auto Sync
    private func setupNetworkMonitoring() {
        networkMonitor.statusDidChange = { [weak self] online in
            guard let self else { return }
            self.isOnline = online
            if online {
                Task { await self.triggerAutoSync() }
            }
        }
        networkMonitor.startMonitoring()
    }
    
    private func triggerAutoSync() async {
        let now = Date()
        guard now.timeIntervalSince(lastSyncAttempt) > 30 else { return }
        lastSyncAttempt = now
        
        guard unsyncedCount > 0 else { return }
        
        do {
            try await transactionSyncManager.syncLocalTransactionsToRemote()
            lastSyncTime = Date()
            await refreshDashboard()
        } catch {
            print("❌ Sync failed: \(error.localizedDescription)")
        }
        
        
    }
    
    // MARK: - Send Transaction
    func sendTransaction() async {
        guard !messageInput.isEmpty || selectedImageURL != nil else { return }
        
        let request = AddTransactionRequest(
            message: messageInput.isEmpty ? nil : messageInput,
            imageURL: selectedImageURL
        )
        
        do {
            try await transactionSyncManager.syncAddTransaction(request)
            messageInput = ""
            selectedImageURL = nil
            await refreshDashboard()
        } catch {
            print("❌ Send failed: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func addTransactionManually(_ transaction: TransactionCasha) async {
        do {
            try await transactionSyncManager.localAddTransaction(transaction)
            await refreshDashboard()
            
            // Trigger auto-sync after adding transaction (with delay)
            try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds delay
            await triggerAutoSync()
            
            print("✅ Transaction added manually")
        } catch {
            print("❌ Failed to add transaction manually: \(error.localizedDescription)")
        }
    }
    
    
    
}
