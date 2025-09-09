//
//  GetTotalSummaryBudget.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import Foundation

public final class GetBudgetSummaryUseCase {
    private let repository: RemoteBudgetRepositoryProtocol

    public init(repository: RemoteBudgetRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Execute fetching summary with optional monthYear filter (e.g. "2025-09")
    public func execute(monthYear: String? = nil) async throws -> BudgetSummary {
        return try await repository.fetchSummaryBudgets(monthYear: monthYear)
    }
}
