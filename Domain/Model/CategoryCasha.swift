//
//  CategoryCasha.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import Foundation

public struct CategoryCasha: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let isActive: Bool
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: String,
        name: String,
        isActive: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
