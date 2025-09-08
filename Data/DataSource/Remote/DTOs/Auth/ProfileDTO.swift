//
//  ProfileDTO.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//


//
//  ProfileDTO.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import Foundation
import Domain

public struct ProfileDTO: Decodable {
    public let id: String?
    public let email: String?
    public let name: String?
    public let avatar: String?
    public let phone: String?
    public let createdAt: String?
    public let updatedAt: String?

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
            id: id ?? "",
            email: email ?? "",
            name: name ?? "",
            avatar: avatar ?? "",   // fallback empty string
            phone: phone ?? "",     // fallback empty string
            createdAt: createdAt.flatMap { formatter.date(from: $0) } ?? Date(),
            updatedAt: updatedAt.flatMap { formatter.date(from: $0) } ?? Date()
        )
    }
}

