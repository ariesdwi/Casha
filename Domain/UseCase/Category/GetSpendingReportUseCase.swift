//
//  GetSpendingReportUseCase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import Foundation


public struct GetSpendingReportUseCase {
    private let repository: LocalTransactionRepositoryProtocol

    public init(repository: LocalTransactionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() -> [SpendingReport] {
        return repository.fetchSpendingReport()
    }
}
