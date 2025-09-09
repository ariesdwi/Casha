//
//  GetUns.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 09/09/25.
//

import Foundation

public final class GetUnsyncTransactionCountUseCase {
    private let repository: LocalTransactionRepositoryProtocol

    public init(repository: LocalTransactionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> Int {
        try await repository.getUnsyncedTransactionsCount()
    }
}
