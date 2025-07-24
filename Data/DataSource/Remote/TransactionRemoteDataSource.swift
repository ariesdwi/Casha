//
//  TransactionRemoteDataSource.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import Domain

public protocol TransactionRemoteDataSource {
    func addTransaction(text: String, image: URL?) async throws -> TransactionCasha
}

