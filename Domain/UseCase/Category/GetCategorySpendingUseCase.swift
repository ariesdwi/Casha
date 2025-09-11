//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//

import Foundation

public struct GetCategorySpendingUseCase {
    private let repository: LocalCategoryRepositoryProtocol

    public init(repository: LocalCategoryRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(startDate: Date, endDate: Date) async -> [ChartCategorySpending] {
        return await repository.fetchCategorySpending(startDate: startDate, endDate: endDate)
     }
}


