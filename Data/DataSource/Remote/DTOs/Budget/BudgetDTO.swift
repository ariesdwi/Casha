//
//  BudgetDTO.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 03/09/25.
//

import Foundation
import Domain

public struct BudgetDTO: Decodable {
    public let id: String?
    public let amount: Double?
    public let spent: Double?
    public let remaining: Double?
    public let period: String?
    public let startDate: String?
    public let endDate: String?
    public let category: CategoryDTO?

    public struct CategoryDTO: Decodable {
        public let id: String
        public let name: String
    }

    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case spent
        case remaining
        case period
        case startDate
        case endDate
        case category
    }

    public func toDomain() -> BudgetCasha {
        let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        return BudgetCasha(
            id: id ?? "",
            amount: amount ?? 0.0,
            spent: spent ?? 0.0,
            remaining: remaining ?? 0.0,
            period: period ?? "",
            startDate: formatter.date(from: startDate ?? "") ?? Date(),
                   endDate: formatter.date(from: endDate ?? "") ?? Date(),
            category: category?.name ?? "" // use category name in domain model
        )
    }
}
