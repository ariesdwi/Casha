//
//  Profile.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//


import Foundation

public struct ProfileCasha: Identifiable, Equatable {
    public let id: String
    public let email: String
    public let name: String
    public let avatar: String
    public let phone: String
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: String,
        email: String,
        name: String,
        avatar: String,
        phone: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.avatar = avatar
        self.phone = phone
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
