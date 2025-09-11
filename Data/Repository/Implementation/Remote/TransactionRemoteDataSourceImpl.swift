//
//  TransactionRemoteDataSourceImpl.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//


import Foundation
import Core
import Domain

public final class TransactionRemoteDataSourceImpl: RemoteTransactionRepositoryProtocol {
    private let client: NetworkClient
  
    public init(client: NetworkClient) {
        self.client = client
    }
    
    public func addTransaction(_ request: AddTransactionRequest) async throws -> TransactionCasha {
        let endpoint = Endpoint.spending
        let headers: [String: String] = [
            "Authorization": "Bearer " + (AuthManager.shared.getToken() ?? ""),
        ]

        // ✅ Validate input
        guard request.message != nil || request.imageURL != nil else {
            throw NetworkError.invalidRequest
        }

        // ✅ Always send as multipart/form-data
        var formFields: [String: String] = [:]
        if let message = request.message {
            formFields["input"] = message
        }

        var files: [UploadFile] = []
        if let image = request.imageURL {
            files.append(UploadFile(fieldName: "receipt", fileURL: image))
        }
        
//        let parameters: [String: Any] = [
////            "period_start": periodStart,
////            "period_end": periodStart,
////            "page": page,
//            "input": request.message ?? ""
//                                         
//        ]

        let response: TransactionResponse = try await client.uploadForm(
            endpoint,
            formFields: formFields,
            headers: headers,
            files: files,
            responseType: TransactionResponse.self
        )
        
//        let response: TransactionResponse = try await client.request(
//            endpoint,
//            parameters: parameters,
//            headers: headers,
//            responseType: TransactionResponse.self
//        )

        return response.data.toDomain()
    }
    
    
    public func fetchTransactionList(
        periodStart: String,
        periodEnd: String,
        page: Int,
        limit: Int
    ) async throws -> [TransactionCasha] {
        let endpoint = Endpoint.spendingList

        let headers: [String: String] = [
            "Authorization": "Bearer " + (AuthManager.shared.getToken() ?? ""),
//            "session_user_id": sessionUserID
        ]

        let parameters: [String: Any] = [:
//            "period_start": periodStart,
//            "period_end": periodStart,
//            "page": page,
//            "limit": limit
        ]

        let response: TransactionListResponse = try await client.request(
            endpoint,
            parameters: parameters,
            headers: headers,
            responseType: TransactionListResponse.self
        )

        return response.data.map { $0.toDomain() }
    }

    public func updateTransaction(id: String, request: UpdateTransactionRequest) async throws -> TransactionCasha {
        let endpoint = Endpoint.spendingUpdate(id: id)

        let headers: [String: String] = [
            "Authorization": "Bearer " + (AuthManager.shared.getToken() ?? "")
        ]
        
        // body JSON
        let parameters: [String: Any] = [
            "name": request.name,
            "amount": request.amount,
            "category": request.category
        ]
        
        let response: TransactionResponse = try await client.request(
            endpoint,
            parameters: parameters,
            headers: headers,
            responseType: TransactionResponse.self
        )
        
        return response.data.toDomain()
    }

    public func deleteTransaction(id: String) async throws -> Bool  {
        let endpoint = Endpoint.spendingDelete(id: id)

        let headers: [String: String] = [
            "Authorization": "Bearer " + (AuthManager.shared.getToken() ?? "")
        ]
        
        // biasanya API delete return kosong atau { "success": true }
        let response: DeleteResponse = try await client.request(
            endpoint,
            parameters: nil,
            headers: headers,
            responseType: DeleteResponse.self // kamu bisa bikin struct kosong: struct EmptyResponse: Codable {}
        )
        
        return response.data.success ?? false
    }
}


