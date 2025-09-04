//
//  AddBudgetUseCase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 03/09/25.
//

import Foundation

public final class AddBudgetUseCase {
    private let repository: RemoteBudgetRepositoryProtocol

    public init(repository: RemoteBudgetRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(request: NewBudgetRequest) async throws -> BudgetCasha {
        return try await repository.createBudget(request: request)
    }
}
