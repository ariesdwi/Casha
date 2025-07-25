//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//
import Foundation

public struct ChartCategorySpending: Identifiable, Equatable {
    public let id: String
    public let category: String
    public let total: Double
    public let percentage: Double

    public init(category: String, total: Double, percentage: Double) {
        self.id = category
        self.category = category
        self.total = total
        self.percentage = percentage
    }
}
