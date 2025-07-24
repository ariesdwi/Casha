//
//  TransactionRemoteDataSourceImpl.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//



import Foundation
import Core
import Domain

public final class TransactionRemoteDataSourceImpl: TransactionRemoteDataSource {
    private let client: NetworkClient
    private let sessionUserID: String
    private let authorizationToken: String

    public init(client: NetworkClient, sessionUserID: String, authorizationToken: String) {
        self.client = client
        self.sessionUserID = sessionUserID
        self.authorizationToken = authorizationToken
    }

//    public func addTransaction(_ request: AddTransactionRequest) async throws -> TransactionCasha {
//        let endpoint = Endpoint.spending
//        let headers: [String: String] = [
//            "Authorization": "Basic \(authorizationToken)",
//            "session_user_id": sessionUserID
//        ]
//       
//        
//        // Check that at least one input exists
//        guard request.message != nil || request.imageURL != nil else {
//            throw NetworkError.invalidRequest
//        }
//
//        if let image = request.imageURL {
//            // Multipart upload (text is optional)
//            var formFields: [String: String] = [:]
//            if let message = request.message {
//                formFields["text"] = message
//            }
//            let files = [UploadFile(fieldName: "image", fileURL: image)]
//            let response: TransactionResponse = try await client.uploadForm(
//                endpoint,
//                formFields: formFields,
//                headers: headers,
//                files: files,
//                responseType: TransactionResponse.self
//            )
//            return response.data.toDomain()
//        } else {
//            // Only text (no image)
//            let parameters = ["text": request.message ?? ""]
//            let response: TransactionResponse = try await client.request(
//                endpoint,
//                
//                parameters: parameters,
//                headers: headers,
//                responseType: TransactionResponse.self
//            )
//            return response.data.toDomain()
//        }
//    }
    
    public func addTransaction(_ request: AddTransactionRequest) async throws -> TransactionCasha {
        let endpoint = Endpoint.spending
        let headers: [String: String] = [
            "Authorization": "Basic \(authorizationToken)",
            "session_user_id": sessionUserID
        ]

        // ✅ Validate input
        guard request.message != nil || request.imageURL != nil else {
            throw NetworkError.invalidRequest
        }

        // ✅ Always send as multipart/form-data
        var formFields: [String: String] = [:]
        if let message = request.message {
            formFields["text"] = message
        }

        var files: [UploadFile] = []
        if let image = request.imageURL {
            files.append(UploadFile(fieldName: "file", fileURL: image))
        }

        let response: TransactionResponse = try await client.uploadForm(
            endpoint,
            formFields: formFields,
            headers: headers,
            files: files,
            responseType: TransactionResponse.self
        )

        return response.data.toDomain()
    }


}


