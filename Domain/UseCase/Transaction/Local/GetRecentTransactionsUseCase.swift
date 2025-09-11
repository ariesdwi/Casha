//
//  GetRecentTransactionsUseCase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import Foundation

public struct GetRecentTransactionsUseCase {
    private let repository: LocalTransactionRepositoryProtocol

    public init(repository: LocalTransactionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(limit: Int = 5) async -> [TransactionCasha] {
        return await repository.fetchRecentTransactions(limit: limit)
    }
}

