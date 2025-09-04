//
//  BudgetSumarryDTO.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import Foundation
import Domain

public struct BudgetSummaryDTO: Decodable {
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
    
    public func toDomain() -> BudgetSummary {
        return BudgetSummary(totalBudget: totalBudget, totalSpent: totalSpent, totalRemaining: totalRemaining)
    }
}
