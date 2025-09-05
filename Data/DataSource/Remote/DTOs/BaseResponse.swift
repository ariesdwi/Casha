//
//  BaseResponse.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//
import Foundation

public struct BaseResponse<T: Decodable>: Decodable {
    public let code: Int
    public let status: String
    public let message: String
    public let data: T
    
    private enum CodingKeys: String, CodingKey {
        case code, status, message, data
    }
}

// Then you can use them like this:
typealias BudgetResponse = BaseResponse<BudgetDTO>
typealias BudgetListResponse = BaseResponse<[BudgetDTO]>
typealias TransactionResponse = BaseResponse<TransactionDTO>
typealias TransactionListResponse = BaseResponse<[TransactionDTO]>
typealias BudgetSummaryResponse = BaseResponse<BudgetSummaryDTO>
typealias ProfileResponse = BaseResponse<ProfileDTO>
