//
//  TransactionSection.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//
import Foundation

public struct TransactionDateSection: Identifiable, Equatable {
    public let id: UUID
    public let date: String
    public let day: String
    public let items: [TransactionCasha]

    public init(id: UUID = UUID(), date: String, day: String, items: [TransactionCasha]) {
        self.id = id
        self.date = date
        self.day = day
        self.items = items
    }

    public var totalAmount: Double {
        items.reduce(0) { $0 + $1.amount }
    }
}

