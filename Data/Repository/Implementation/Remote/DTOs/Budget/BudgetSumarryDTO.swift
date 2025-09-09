//
//  BudgetSumarryDTO.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import Foundation
import Domain

public struct BudgetSummaryDTO: Decodable {
    public let totalBudget: Double?
    public let totalSpent: Double?
    public let totalRemaining: Double?
   
    public init(
        totalBudget: Double,
        totalSpent: Double,
        totalRemaining: Double,
    ) {
        self.totalBudget = totalBudget
        self.totalSpent = totalSpent
        self.totalRemaining = totalRemaining
    }
    
    public func toDomain() -> BudgetSummary {
        return BudgetSummary(
            totalBudget: totalBudget ?? 0.0,
            totalSpent: totalSpent ?? 0.0,
            totalRemaining: totalRemaining ?? 0.0
        )
    }
}
