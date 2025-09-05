//
//  AddTransactionLocal.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 05/09/25.
//

import Foundation

public final class AddTransactionLocal {
    private let repository: LocalTransactionRepositoryProtocol

    public init(repository: LocalTransactionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(transaction: TransactionCasha) async throws {
        try await repository.addTransaction( transaction )
    }
}
