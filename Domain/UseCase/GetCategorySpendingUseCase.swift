//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//

import Foundation

public struct GetCategorySpendingUseCase {
    private let repository: CategoryRepositoryProtocol

    public init(repository: CategoryRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(startDate: Date, endDate: Date) -> [ChartCategorySpending] {
         return repository.fetchCategorySpending(startDate: startDate, endDate: endDate)
     }
}


