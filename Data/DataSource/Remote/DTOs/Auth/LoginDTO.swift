//
//  LoginDTO.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 06/09/25.
//
import Domain

public struct LoginDTO: Decodable {
    public let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
