//
//  TransactionRemoteDataSource.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation

public protocol RemoteTransactionRepositoryProtocol {
    func addTransaction(_ request: AddTransactionRequest) async throws -> TransactionCasha
    func fetchTransactionList(
        periodStart: String,
        periodEnd: String,
        page: Int,
        limit: Int
    ) async throws -> [TransactionCasha]
    
    // MARK: - Update
    func updateTransaction(
        id: String,
        request: UpdateTransactionRequest
    ) async throws -> TransactionCasha
    
    // MARK: - Delete
    func deleteTransaction(id: String) async throws -> Bool
}

