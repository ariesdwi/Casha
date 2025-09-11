//
//  SearchTransactionsUseCase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation

public final class SearchTransactionsUseCase {
    private let repository: LocalTransactionRepositoryProtocol

    public init(repository: LocalTransactionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(query: String) async -> [TransactionCasha] {
        await repository.searchTransactions(text: query)
    }
}
