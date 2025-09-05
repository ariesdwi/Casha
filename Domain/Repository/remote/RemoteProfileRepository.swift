//
//  RemoteProfileRepository.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import Foundation

public protocol RemoteProfileRepository {
    func getProfile() async throws -> ProfileCasha
}
