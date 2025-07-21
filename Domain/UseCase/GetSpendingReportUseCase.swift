//
//  GetSpendingReportUseCase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import Foundation


public struct GetSpendingReportUseCase {
    private let repository: TransactionRepositoryProtocol

    public init(repository: TransactionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(period: ReportPeriod) -> [SpendingReport] {
        return repository.fetchSpendingReport(period: period)
    }
}
