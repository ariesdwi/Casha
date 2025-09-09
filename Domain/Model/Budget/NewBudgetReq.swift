//
//  NewBudgetReq.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import Foundation

// MARK: - New Budget Request Model
public struct NewBudgetRequest: Codable {
    public let amount: Double
    public let month: String
    public let category: String
    
    public init(
        amount: Double,
        month: String,
        category: String
    ) {
        self.amount = amount
        self.month = month
        self.category = category
    }
}
