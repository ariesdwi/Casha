//
//  TransactionResponse.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import Domain

public struct TransactionResponse: Decodable {
    public let code: Int
    public let status: String
    public let message: String
    public let data: TransactionDTO
}

