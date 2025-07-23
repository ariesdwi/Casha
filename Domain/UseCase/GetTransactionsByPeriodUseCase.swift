//
//  GetTransactionsByPeriodUseCase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation

public final class GetTransactionsByPeriodUseCase {
    private let repository: TransactionRepositoryProtocol

    public init(repository: TransactionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(startDate: Date, endDate: Date?) async -> [TransactionCasha] {
        await repository.fetchTransactions(startDate: startDate, endDate: endDate)
    }
}
