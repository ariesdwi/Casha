//import Foundation
//import Domain
//import Data
//import Core
//import Network
//
//final class DashboardState: ObservableObject {
//    @Published var recentTransactions: [TransactionCasha] = []
//    @Published var totalSpending: Double = 0.0
//    @Published var report: SpendingReport = SpendingReport(
//        thisWeekTotal: 0,
//        thisMonthTotal: 0,
//        dailyBars: [],
//        weeklyBars: []
//    )
//    
//    @Published var messageInput: String = ""
//    @Published var selectedImageURL: URL? = nil
//    @Published var isSending: Bool = false
//    @Published public var isLoading: Bool = false
//    @Published var errorMessage: String?
//    @Published var unsyncedCount: Int = 0
//    @Published var isSyncing: Bool = false
//    @Published var isOnline: Bool = false
//       
//    private var networkMonitor: NetworkMonitorProtocol
//    private let getRecentTransactions: GetRecentTransactionsUseCase
//    private let getTotalSpending: GetTotalSpendingUseCase
//    private let getSpendingReport: GetSpendingReportUseCase
//    private let transactionSyncManager: TransactionSyncManager
//    
//    // Network monitoring
//    private let monitor = NWPathMonitor()
//    private let queue = DispatchQueue(label: "com.casha.networkMonitor")
//    private var lastSyncAttempt: Date = Date.distantPast
//
//    init(
//        getRecentTransactions: GetRecentTransactionsUseCase,
//        getTotalSpending: GetTotalSpendingUseCase,
//        getSpendingReport: GetSpendingReportUseCase,
//        transactionSyncManager: TransactionSyncManager,
//        networkMonitor: NetworkMonitorProtocol
//    ) {
//        self.getRecentTransactions = getRecentTransactions
//        self.getTotalSpending = getTotalSpending
//        self.getSpendingReport = getSpendingReport
//        self.transactionSyncManager = transactionSyncManager
//        self.networkMonitor = networkMonitor
//
//        setupNetworkMonitoring()
//    }
//
//    deinit {
//        monitor.cancel()
//    }
//
//    // MARK: - Network Monitoring
//    private func setupNetworkMonitoring() {
//        networkMonitor.statusDidChange = { [weak self] online in
//            guard let self = self else { return }
//            self.isOnline = online
//            if online {
//                Task { await self.triggerAutoSync() }
//            }
//        }
//        networkMonitor.startMonitoring()
//    }
//
//
//    // MARK: - Data Loading
//    @MainActor
//    func loadData() async {
//        isLoading = true
//        defer { isLoading = false }
//        
//        do {
//            async let recentTransactionsTask = getRecentTransactions.execute(limit: 5)
//            async let totalSpendingTask = getTotalSpending.execute()
//            async let spendingReportTask = getSpendingReport.execute()
//            async let unsyncedCountTask = checkUnsyncedCount()
//
//            let (transactions, spending, reportResults, _) = await (
//                recentTransactionsTask,
//                totalSpendingTask,
//                spendingReportTask,
//                unsyncedCountTask
//            )
//
//            self.recentTransactions = transactions
//            self.totalSpending = spending
//            
//            if let result = reportResults.first {
//                self.report = result
//            }
//            
//        } catch {
//            errorMessage = "Failed to load data: \(error.localizedDescription)"
//        }
//    }
//    
//    // MARK: - Sync Management
//    @MainActor
//    private func checkUnsyncedCount() async {
//        do {
//            unsyncedCount = try await transactionSyncManager.getUnsyncTransactionCount()
//            print("📊 Unsynced transactions: \(unsyncedCount)")
//        } catch {
//            print("❌ Failed to get unsynced count: \(error)")
//            unsyncedCount = 0
//        }
//    }
//    
//    @MainActor
//    private func triggerAutoSync() async {
//        // Prevent too frequent sync attempts (minimum 30 seconds between syncs)
//        let now = Date()
//        if now.timeIntervalSince(lastSyncAttempt) < 30 {
//            print("⏸️ Sync skipped - too soon since last attempt")
//            return
//        }
//        
//        lastSyncAttempt = now
//        
//        guard unsyncedCount > 0 else {
//            print("✅ No unsynced transactions to sync")
//            return
//        }
//        
//        print("🔄 Auto-syncing \(unsyncedCount) transactions...")
//        await syncLocalTransactions()
//    }
//    
//    @MainActor
//    func syncLocalTransactions() async {
////        isSyncing = true
////        errorMessage = nil
//
//        do {
//            try await transactionSyncManager.syncLocalTransactionsToRemote()
//            await loadData() // Refresh data after sync
//            print("✅ Sync completed successfully")
//        } catch {
//            errorMessage = "Failed to sync transactions: \(error.localizedDescription)"
//            print("❌ Sync error: \(error)")
//        }
//
////        isSyncing = false
//    }
//    
//    // MARK: - Transaction Operations
//    @MainActor
//    func sendTransaction() async {
//        guard !messageInput.isEmpty || selectedImageURL != nil else {
//            errorMessage = "Please input a message or select an image"
//            return
//        }
//
//        isSending = true
//        errorMessage = nil
//
//        let request = AddTransactionRequest(
//            message: messageInput.isEmpty ? nil : messageInput,
//            imageURL: selectedImageURL
//        )
//
//        do {
//            try await transactionSyncManager.syncAddTransaction(request)
//            messageInput = ""
//            selectedImageURL = nil
//            await loadData()
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//
//        isSending = false
//    }
//    
//    @MainActor
//    func addTransactionManually(_ transaction: TransactionCasha) async {
//        isLoading = true
//        errorMessage = nil
//
//        do {
//            try await transactionSyncManager.localAddTransaction(transaction)
//            await loadData()
//            // Trigger auto-sync after adding transaction (with delay)
//            try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds delay
//            await triggerAutoSync()
//        } catch {
//            errorMessage = "Failed to add transaction: \(error.localizedDescription)"
//        }
//
//        isLoading = false
//    }
//
//    @MainActor
//    func sendTransactionFromImage() async {
//        guard let imageURL = selectedImageURL else {
//            errorMessage = "Please select an image first"
//            return
//        }
//
//        isSending = true
//        errorMessage = nil
//
//        let request = AddTransactionRequest(
//            message: nil,
//            imageURL: imageURL
//        )
//
//        do {
//            try await transactionSyncManager.syncAddTransaction(request)
//            selectedImageURL = nil
//            await loadData()
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//
//        isSending = false
//    }
//    
//    @MainActor
//    func syncTransactionList() async {
//        isLoading = true
//        errorMessage = nil
//
//        do {
//            try await transactionSyncManager.syncAllTransactions(
//                periodStart: "2025-07-01",
//                periodEnd: "2025-07-30",
//                page: 1,
//                limit: 50
//            )
//
//            await loadData()
//        } catch let networkError as NetworkError {
//            handleNetworkError(networkError)
//        } catch {
//            errorMessage = "Unexpected: \(error.localizedDescription)"
//            print("[Sync Error] \(error.localizedDescription)")
//        }
//        
//        isLoading = false
//    }
//    
//    // MARK: - Manual Sync Trigger
//    @MainActor
//    func manualSync() async {
//        await checkUnsyncedCount()
//        await syncLocalTransactions()
//    }
//    
//    // MARK: - Error Handling
//    private func handleNetworkError(_ error: NetworkError) {
//        switch error {
//        case .serverError(let message):
//            errorMessage = "Server error: \(message)"
//        case .invalidResponse(let code):
//            errorMessage = "Invalid response (code: \(code))"
//        case .requestFailed(let description):
//            errorMessage = "Request failed: \(description)"
//        case .decodingFailed(let underlying):
//            errorMessage = "Failed to decode response: \(underlying.localizedDescription)"
//        case .invalidURL, .invalidRequest:
//            errorMessage = "Invalid request"
//        case .unknown(let err):
//            errorMessage = "Unexpected error: \(err.localizedDescription)"
//        }
//        print("[Sync Error] \(errorMessage ?? "Unknown")")
//    }
//}


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
