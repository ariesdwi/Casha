//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import Domain

public struct TransactionDTO: Decodable {
    public let id: String?
    public let name: String?
    public let amount: Double?
    public let datetime: String?
    public let category: String?
    
    enum CodingKeys: String, CodingKey {
        case id
         case name
         case amount
         case datetime
         case category
     }

    public func toDomain() -> TransactionCasha {
        let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        return TransactionCasha(
            id: id ?? "",
            name: name ?? "",
            category: category ?? "",
            amount: amount ?? 0.0,
            datetime: formatter.date(from: datetime ?? "") ?? Date(),
            isConfirm: true,
            createdAt: formatter.date(from: datetime ?? "") ?? Date(),   // Or parse if provided
            updatedAt: formatter.date(from: datetime ?? "") ?? Date(),   // Or parse if provided
        )
    }
}
