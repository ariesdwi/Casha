//
//  GetTransactionbyCategory.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 11/09/25.
//

import Foundation

public struct GetTransactionbyCategoryUseCase {
    private let repository: LocalCategoryRepositoryProtocol

    public init(repository: LocalCategoryRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(category: String,startDate: Date, endDate: Date) async -> [TransactionCasha] {
        return await repository.fetchTransactionsForCategory(category: category, startDate: startDate, endDate: endDate)
     }
}

