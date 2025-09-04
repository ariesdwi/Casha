//
//  GetTotalSummaryBudget.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import Foundation

public final class GetTotalSummaryBudget {
    private let repository: RemoteBudgetRepositoryProtocol

    public init(repository: RemoteBudgetRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> BudgetSummary {
        return try await repository.fetchsummaryBudgets()
    }
}
