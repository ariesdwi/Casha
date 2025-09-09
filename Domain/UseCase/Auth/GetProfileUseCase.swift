//
//  GetProfileUsecase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import Foundation

public final class GetProfileUseCase {
    private let repository: RemoteAuthRepositoryProtocol

    public init(repository: RemoteAuthRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> UserCasha {
        return try await repository.getProfile()
    }
}
