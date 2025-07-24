//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import Domain

public struct TransactionDTO: Decodable {
    public let id: String
    public let used: String
    public let total: Double
    public let datetime: String
    public let category: String

    public func toDomain() -> TransactionCasha {
        TransactionCasha(
            id: id,
            name: used,
            category: category,
            amount: total,
            datetime: ISO8601DateFormatter().date(from: datetime) ?? Date(),
            isConfirm: true,
            createdAt: Date(),   // Or parse if provided
            updatedAt: Date()    // Or parse if provided
        )
    }
}
