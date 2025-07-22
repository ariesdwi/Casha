//
//  Transaction.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//
import Foundation

public struct TransactionCasha: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let category: String
    public let amount: Double
    public let datetime: Date
    public let isConfirm: Bool
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: String,
        name: String,
        category: String,
        amount: Double,
        datetime: Date,
        isConfirm: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.amount = amount
        self.datetime = datetime
        self.isConfirm = isConfirm
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

