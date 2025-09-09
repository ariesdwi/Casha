//
//  DeleteAllLocalDataUsecase.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 09/09/25.
//

import Foundation

public final class DeleteAllLocalDataUseCase {
    private let repository: LocalTransactionRepositoryProtocol

    public init(repository: LocalTransactionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws  {
        try await repository.deleteAllLocal()
    }
}
