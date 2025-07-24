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
    public let categoryId: String
    public let name: String
    public let amount: Double
    public let datetime: String
    public let category: String
    public let createdAt: String
    public let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
         case categoryId = "category_id"
         case name
         case amount
         case datetime
         case category
         case createdAt = "created_at"
         case updatedAt = "updated_at"
     }

    public func toDomain() -> TransactionCasha {
        TransactionCasha(
            id: id,
            name: name,
            category: category,
            amount: amount,
            datetime: ISO8601DateFormatter().date(from: datetime) ?? Date(),
            isConfirm: true,
            createdAt: ISO8601DateFormatter().date(from: createdAt) ?? Date(),   // Or parse if provided
            updatedAt: ISO8601DateFormatter().date(from: updatedAt) ?? Date()    // Or parse if provided
        )
    }
}
