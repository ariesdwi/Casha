//
//  Budget.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 29/08/25.
//


import Foundation

public struct BudgetCasha: Identifiable, Equatable {
    public let id: String
    public let amount: Double
    public let spent: Double
    public let remaining: Double
    public let period: String
    public let startDate: Date
    public let endDate: Date
    public let category: String

    public init(
        id: String,
        amount: Double,
        spent: Double,
        remaining: Double,
        period: String,
        startDate: Date,
        endDate: Date,
        category: String
    ) {
        self.id = id
        self.amount = amount
        self.spent = spent
        self.remaining = remaining
        self.period = period
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
    }
}
