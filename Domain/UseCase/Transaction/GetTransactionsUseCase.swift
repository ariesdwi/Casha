//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//
import Foundation

public final class GetTransactionsUseCase{
    private let repository: LocalTransactionRepositoryProtocol

    public init(repository: LocalTransactionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async -> [TransactionCasha] {
        return await repository.fetchAllTransactions()
    }
}
