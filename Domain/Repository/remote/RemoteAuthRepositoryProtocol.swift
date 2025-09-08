//
//  RemoteProfileRepository.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import Foundation

public protocol RemoteAuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> String
    func getProfile() async throws -> UserCasha
    func register(email: String, password: String, name: String, avatar: String) async throws -> String
}
