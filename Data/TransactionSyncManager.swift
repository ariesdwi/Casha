//
//  TransactionSyncManager.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 24/07/25.
//


import Foundation
import Domain

public final class TransactionSyncManager {
    private let remoteRepository: RemoteTransactionRepositoryProtocol
    private let localRepository: LocalTransactionRepositoryProtocol
    
    public init(
        remoteDataSource: RemoteTransactionRepositoryProtocol,
        repository: LocalTransactionRepositoryProtocol
    ) {
        self.remoteRepository = remoteDataSource
        self.localRepository = repository
    }
    
    /// AI-driven transaction input flow:
    /// 1. Send message/image to remote AI.
    /// 2. Receive structured transaction.
    /// 3. Save to CoreData.
    public func syncAddTransaction(_ request: AddTransactionRequest) async throws {
        let transaction = try await remoteRepository.addTransaction(request)
        
        try await localRepository.addTransaction(transaction)
    }
    
    /// AI-driven transaction input flow:
    /// 1. Trigger fetch all transactio when .active  from remote
    /// 2. Receive list of  transaction from remote.
    /// 3. cek on coredata if data i avail skip and update data if in coredata not availbale.
    public func syncAllTransactions(
        periodStart: String,
        periodEnd: String,
        page: Int = 1,
        limit: Int = 50
    ) async throws {
        let remoteTransactions = try await remoteRepository.fetchTransactionList(
            periodStart: periodStart,
            periodEnd: periodEnd,
            page: page,
            limit: limit
        )
        
        try await localRepository.mergeTransactions(remoteTransactions)
    }
    
    
    // Add Function Local
    public func localAddTransaction(_ request: TransactionCasha) async throws {
        try await localRepository.addTransaction(request)
    }
    
    public func syncLocalTransactionsToRemote() async throws {
        // 1. Get all unsynced transactions from local repository
        let unsyncedTransactions = try await localRepository.getUnsyncedTransactions()
        
        guard !unsyncedTransactions.isEmpty else {
            print("✅ No unsynced transactions found")
            return
        }
        
        print("🔄 Syncing \(unsyncedTransactions.count) transactions to remote...")
        
        // 2. Sync each unsynced transaction one by one
        for transaction in unsyncedTransactions {
            do {
                // Convert local transaction to remote request format
                let request = AddTransactionRequest(
                    message: "\(transaction.name) - \(transaction.category) - \(transaction.amount)",
                    imageURL: nil // Add image URL if you store receipt images
                )
                
                // 3. Send to remote server
                let remoteTransaction = try await remoteRepository.addTransaction(request)
                
                // 4. Mark as synced in local database
                try await localRepository.markAsSynced(
                    transactionId: transaction.id,
                    remoteData: remoteTransaction
                )
                
                print("✅ Successfully synced transaction: \(transaction.name)")
                
            } catch {
                print("❌ Failed to sync transaction \(transaction.id): \(error)")
                // Continue with other transactions instead of stopping
                // Remove this if you want to stop on first error: throw error
            }
        }
        
        print("🎉 All transactions synced successfully!")
    }
    
    // Add Function Local
    public func getUnsyncTransactionCount() async throws -> Int{
        try await localRepository.getUnsyncedTransactionsCount()
    }
    
}
