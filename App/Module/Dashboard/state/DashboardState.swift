
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
    
    // Metadata
    @Published var unsyncedCount: Int = 0
    @Published var isOnline: Bool = false
    @Published var lastSyncTime: Date? = nil
    
    // UI State
    @Published var isSyncing: Bool = false
    
    private var networkMonitor: NetworkMonitorProtocol
    private let getRecentTransactions: GetRecentTransactionsUseCase
    private let getTotalSpending: GetTotalSpendingUseCase
    private let getSpendingReport: GetSpendingReportUseCase
    private let transactionSyncManager: TransactionSyncUseCase
    private let getUnsyncTransactionCount: GetUnsyncTransactionCountUseCase
    private let addLocalTransaction: AddTransactionLocalUseCase
    
    private var lastSyncAttempt: Date = .distantPast
    
    init(
        getRecentTransactions: GetRecentTransactionsUseCase,
        getTotalSpending: GetTotalSpendingUseCase,
        getSpendingReport: GetSpendingReportUseCase,
        getUnsyncTransactionCount: GetUnsyncTransactionCountUseCase,
        addLocalTransaction: AddTransactionLocalUseCase,
        networkMonitor: NetworkMonitorProtocol,
        transactionSyncManager: TransactionSyncUseCase
    ) {
        self.getRecentTransactions = getRecentTransactions
        self.getTotalSpending = getTotalSpending
        self.getSpendingReport = getSpendingReport
        self.getUnsyncTransactionCount = getUnsyncTransactionCount
        self.addLocalTransaction = addLocalTransaction
        self.transactionSyncManager = transactionSyncManager
        self.networkMonitor = networkMonitor
        setupNetworkMonitoring()
    }
    
    // MARK: - Load Data
    func refreshDashboard() async {
        async let tx = getRecentTransactions.execute(limit: 5)
        async let spending = getTotalSpending.execute()
        async let reports = getSpendingReport.execute()
        async let unsynced = getUnsyncTransactionCount.execute()
        
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
        print(unsyncedCount)
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
        
        isSyncing = true   // 👈 start spinner
        defer { isSyncing = false } // 👈 always reset
        
        do {
            try await transactionSyncManager.syncAddTransaction(request)
            messageInput = ""
            selectedImageURL = nil
            await refreshDashboard()
        } catch {
            print("❌ Send failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Send Massage
    func sendMTransaction() async -> Bool {
        guard !messageInput.isEmpty || selectedImageURL != nil else { return false }
        
        let request = AddTransactionRequest(
            message: messageInput.isEmpty ? nil : messageInput,
            imageURL: selectedImageURL
        )
        
        isSyncing = true
        defer { isSyncing = false }
        
        do {
            try await transactionSyncManager.syncAddTransaction(request)
            messageInput = ""
            selectedImageURL = nil
            await refreshDashboard()
            return true   // 👈 success
        } catch {
            print("❌ Send failed: \(error.localizedDescription)")
            return false  // 👈 failure
        }
    }

    
    // MARK: - Manual Add
    @MainActor
    func addTransactionManually(_ transaction: TransactionCasha) async {
        do {
            try await addLocalTransaction.execute(transaction: transaction)
            await refreshDashboard()
            await triggerAutoSync()
            print("✅ Transaction added manually")
        } catch {
            print("❌ Failed to add transaction manually: \(error.localizedDescription)")
        }
    }
}
