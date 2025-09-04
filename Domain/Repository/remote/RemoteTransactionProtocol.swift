//
//  TransactionRemoteDataSource.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import Domain

public protocol RemoteTransactionRepositoryProtocol {
    func addTransaction(_ request: AddTransactionRequest) async throws -> TransactionCasha
    func fetchTransactionList(
        periodStart: String,
        periodEnd: String,
        page: Int,
        limit: Int
    ) async throws -> [TransactionCasha]

}

