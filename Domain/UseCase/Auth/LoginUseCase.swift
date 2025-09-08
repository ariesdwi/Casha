//
//  LoginUseCase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 06/09/25.
//

import Foundation

public final class LoginUseCase {
    private let repository: RemoteAuthRepositoryProtocol

    public init(repository: RemoteAuthRepositoryProtocol) {
        self.repository = repository
    }

    /// Perform login and return token
    public func execute(email: String, password: String) async throws -> String {
        return try await repository.login(email: email, password: password)
    }
}
