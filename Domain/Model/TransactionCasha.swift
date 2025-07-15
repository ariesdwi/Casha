//
//  Transaction.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//


import Foundation

public struct TransactionCasha: Identifiable {
    public let id: UUID
    public let name: String
    public let category: String
    public let amount: Double
    public let date: Date

    public init(id: UUID, name: String, category: String, amount: Double, date: Date) {
        self.id = id
        self.name = name
        self.category = category
        self.amount = amount
        self.date = date
    }
}

