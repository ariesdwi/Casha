//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//
import Foundation

public final class GetAllTransactionsUseCase {
    private let repository: TransactionRepositoryProtocol

    public init(repository: TransactionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async -> [TransactionCasha] {
        return await repository.fetchAllTransactions()
    }
}
