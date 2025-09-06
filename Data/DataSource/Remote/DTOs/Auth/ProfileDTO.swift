//
//  ProfileDTO.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//


import Foundation
import Domain

public struct ProfileDTO: Decodable {
    public let id: String
    public let email: String
    public let name: String
    public let avatar: String
    public let phone: String
    public let createdAt: String
    public let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case avatar
        case phone
        case createdAt
        case updatedAt
    }

    public func toDomain() -> UserCasha {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return UserCasha(
            id: id,
            email: email,
            name: name,
            avatar: avatar,
            phone: phone,
            createdAt: formatter.date(from: createdAt) ?? Date(),
            updatedAt: formatter.date(from: updatedAt) ?? Date()
        )
    }
}
