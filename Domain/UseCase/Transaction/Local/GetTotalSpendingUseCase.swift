//
//  GetTotalSpendingUseCase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import Foundation

public struct GetTotalSpendingUseCase {
    private let repository: LocalTransactionRepositoryProtocol

    public init(repository: LocalTransactionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(period: SpendingPeriod) -> Double {
        return repository.fetchTotalSpending(period: period)
    }
}
