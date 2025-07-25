//
//  TransactionListResponse.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//

import Foundation

public struct TransactionListResponse: Decodable {
    public let code: Int
    public let status: String
    public let message: String
    public let results: [TransactionItemResponse]
    public let page: Int
    public let limit: Int
    public let totalPages: Int
    public let totalResults: Int

    private enum CodingKeys: String, CodingKey {
        case code, status, message, results, page, limit
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
