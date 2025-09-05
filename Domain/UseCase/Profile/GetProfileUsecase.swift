//
//  GetProfileUsecase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import Foundation

public final class GetProfileUsecase {
    private let repository: RemoteProfileRepository

    public init(repository: RemoteProfileRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> ProfileCasha {
        return try await repository.getProfile()
    }
}
