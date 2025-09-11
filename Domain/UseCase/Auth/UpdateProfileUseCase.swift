//
//  UpdateProfileUseCase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 10/09/25.
//

import Foundation

public final class UpdateProfileUseCase {
    private let repository: RemoteAuthRepositoryProtocol

    public init(repository: RemoteAuthRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(user: UpdateProfileRequest) async throws -> UserCasha {
        return try await repository.updateProfile(request: user )
    }
}
