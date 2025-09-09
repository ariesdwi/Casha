//
//  RegisterUseCase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 08/09/25.
//

import Foundation

public final class RegisterUseCase {
    private let repository: RemoteAuthRepositoryProtocol

    public init(repository: RemoteAuthRepositoryProtocol) {
        self.repository = repository
    }

    /// Perform register and return access token
    public func execute(email: String, password: String, name: String, phone: String) async throws -> String {
        return try await repository.register(
            email: email,
            password: password,
            name: name,
            phone: phone
        )
    }
}
