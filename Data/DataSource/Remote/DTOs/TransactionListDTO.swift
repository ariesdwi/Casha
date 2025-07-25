//
//  TransactionListDTO.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//

import Foundation
import Domain

public struct TransactionItemResponse: Decodable {
    public let id: String
    public let userSessionId: String
    public let category: String
    public let categoryId: String?
    public let name: String
    public let amount: Double
    public let datetime: String
    public let isConfirm: Bool
    public let createdAt: String
    public let updatedAt: String

    private enum CodingKeys: String, CodingKey {
        case id
        case userSessionId = "user_session_id"
        case category
        case categoryId = "category_id"
        case name
        case amount
        case datetime
        case isConfirm = "is_confirm"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    public func toDomain() -> TransactionCasha {
        return TransactionCasha(
            id: id,
            name: name,
            category: category,
            amount: amount,
            datetime: ISO8601DateFormatter().date(from: datetime) ?? Date(),
            isConfirm: true,
            createdAt: ISO8601DateFormatter().date(from: createdAt) ?? Date(),   // Or parse if provided
            updatedAt: ISO8601DateFormatter().date(from: updatedAt) ?? Date()
        )
    }
}
