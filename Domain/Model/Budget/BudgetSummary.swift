//
//  BudgetSummary.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import Foundation

public struct BudgetSummary: Codable {
    public let totalBudget: Double
    public let totalSpent: Double
    public let totalRemaining: Double
   
    public init(
        totalBudget: Double,
        totalSpent: Double,
        totalRemaining: Double,
    ) {
        self.totalBudget = totalBudget
        self.totalSpent = totalSpent
        self.totalRemaining = totalRemaining
    }
}
