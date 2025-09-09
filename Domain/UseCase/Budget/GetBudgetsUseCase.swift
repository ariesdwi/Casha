//
//  GetAllBudgetUseCase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 03/09/25.
//

import Foundation

public final class GetBudgetsUseCase {
    private let repository: RemoteBudgetRepositoryProtocol

    public init(repository: RemoteBudgetRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Fetch budgets, optionally filtered by month/year (e.g. "2025-09")
    public func execute(monthYear: String? = nil) async throws -> [BudgetCasha] {
        return try await repository.fetchBudgets(monthYear: monthYear)
    }
}

