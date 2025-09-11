//
//  DeleteDTO.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 11/09/25.
//

import Domain

public struct DeleteDTO: Decodable {
    public let success: Bool?

    enum CodingKeys: String, CodingKey {
        case success = "success"
    }
}
