//
//  CategoryDTO.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 03/09/25.
//

import Foundation
import Domain

// MARK: - CategoryDTO
public struct CategoryDTO: Decodable {
    public let id: String
    public let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
