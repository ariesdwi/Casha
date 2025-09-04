//
//  BudgetRepositoryProtocol.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 03/09/25.
//

import Foundation

public protocol RemoteBudgetRepositoryProtocol {
    func fetchBudgets() async throws -> [BudgetCasha]
    func createBudget(request: NewBudgetRequest) async throws -> BudgetCasha
    func fetchsummaryBudgets() async throws -> BudgetSummary
}
