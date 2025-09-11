//
//  UpdateProfileRequest.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 10/09/25.
//

import Foundation

public struct UpdateProfileRequest: Codable {
    public let name: String?
    public let email: String?
    public let phone: String?
    
    public init(name: String? = nil,email: String? = nil,phone: String? = nil) {
        self.name = name
        self.email = email
        self.phone = phone
    }
}


