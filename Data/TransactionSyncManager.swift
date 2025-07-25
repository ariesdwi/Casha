//
//  TransactionSyncManager.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 24/07/25.
//


import Foundation
import Domain

public final class TransactionSyncManager {
    private let remoteDataSource: TransactionRemoteDataSource
    private let repository: TransactionRepositoryProtocol

    public init(
        remoteDataSource: TransactionRemoteDataSource,
        repository: TransactionRepositoryProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.repository = repository
    }

    /// AI-driven transaction input flow:
    /// 1. Send message/image to remote AI.
    /// 2. Receive structured transaction.
    /// 3. Save to CoreData.
    public func syncAddTransaction(_ request: AddTransactionRequest) async throws {
        let transaction = try await remoteDataSource.addTransaction(request)
        
        try await repository.addTransaction(transaction)
    }
    
    public func syncAllTransactions(
        periodStart: String,
        periodEnd: String,
        page: Int = 1,
        limit: Int = 50
    ) async throws {
        let remoteTransactions = try await remoteDataSource.fetchTransactionList(
            periodStart: periodStart,
            periodEnd: periodEnd,
            page: page,
            limit: limit
        )

        try await repository.mergeTransactions(remoteTransactions)
    }

}
