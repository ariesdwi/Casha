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
    public let period: String
    public let startDate: String
    public let endDate: String
    public let category: String
    
    public init(
        amount: Double,
        period: String,
        startDate: String,
        endDate: String,
        category: String
    ) {
        self.amount = amount
        self.period = period
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
    }
}
