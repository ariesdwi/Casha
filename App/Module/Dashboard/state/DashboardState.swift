
import Foundation
import Domain
import Data
import Core


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
    @Published var lastCreatedTransaction: TransactionCasha?


    
  
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
        transactionSyncManager: TransactionSyncUseCase
    ) {
        self.getRecentTransactions = getRecentTransactions
        self.getTotalSpending = getTotalSpending
        self.getSpendingReport = getSpendingReport
        self.getUnsyncTransactionCount = getUnsyncTransactionCount
        self.addLocalTransaction = addLocalTransaction
        self.transactionSyncManager = transactionSyncManager
    }
    
    // MARK: - Load Data
    func refreshDashboard() async {
        print(" Refresh ")

        async let tx = getRecentTransactions.execute(limit: 5)
        async let spending = getTotalSpending.execute()
        async let reports = getSpendingReport.execute()
        async let unsynced = getUnsyncTransactionCount.execute()
        
        do {
            let (transactions, spendingVal, reportsVal, unsyncedVal) = try await (tx, spending, reports, unsynced)
            print("📊 Refresh result: \(transactions.count) transactions, spending: \(spendingVal)")

            self.recentTransactions = transactions
            self.totalSpending = spendingVal
            self.report = reportsVal.first ?? self.report
            self.unsyncedCount = unsyncedVal
        } catch {
            print("⚠️ Refresh failed: \(error.localizedDescription)")
        }
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
    
    //     MARK: - Send Transaction
    func sendTransaction() async -> TransactionCasha? {
        guard !messageInput.isEmpty || selectedImageURL != nil else { return nil }
        
        let request = AddTransactionRequest(
            message: messageInput.isEmpty ? nil : messageInput,
            imageURL: selectedImageURL
        )
        
        isSyncing = true
        defer { isSyncing = false }
        
        do {
            let transaction = try await transactionSyncManager.syncAddTransaction(request)
            
            // reset state
            messageInput = ""
            selectedImageURL = nil
            lastCreatedTransaction = transaction
            
            // 0.1 seconds
            
            await refreshDashboard()
            return transaction   // 👈 return the actual transaction
        } catch {
            print("❌ Send failed: \(error.localizedDescription)")
            lastCreatedTransaction = nil
            return nil           // 👈 failure
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



