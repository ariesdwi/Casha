//
//  GetTotalSpendingUseCase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import Foundation

public struct GetTotalSpendingUseCase {
    private let repository: TransactionRepositoryProtocol

    public init(repository: TransactionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() -> Double {
        return repository.fetchTotalSpending()
    }
}
