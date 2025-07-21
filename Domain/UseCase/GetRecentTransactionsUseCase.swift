//
//  GetRecentTransactionsUseCase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import Foundation

public struct GetRecentTransactionsUseCase {
    private let repository: TransactionRepositoryProtocol

    public init(repository: TransactionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(limit: Int = 5) -> [TransactionCasha] {
        return repository.fetchRecentTransactions(limit: limit)
    }
}

