//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 11/09/25.
//

import Foundation

public struct UpdateTransactionRequest: Codable, Equatable {
    public let name: String
    public let amount: Double
    public let category: String

    public init(
        name: String,
        amount: Double,
        category: String
    ) {
        self.name = name
        self.amount = amount
        self.category = category
    }
}
