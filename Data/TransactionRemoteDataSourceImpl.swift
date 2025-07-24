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

    public func addTransaction(text: String, image: URL?) async throws -> TransactionCasha {
        let endpoint = Endpoint.spending
        let headers: [String: String] = [
            "Authorization": "Basic \(authorizationToken)",
            "session_user_id": sessionUserID
        ]
        
        if let image = image {
            // Multipart upload
            let formFields = ["text": text]
            let files = [UploadFile(fieldName: "image", fileURL: image)]
            let response: TransactionResponse = try await client.uploadForm(
                endpoint,
                formFields: formFields,
                headers: headers,
                files: files,
                responseType: TransactionResponse.self
            )
            return response.data.toDomain()
        } else {
            // Text only
            let parameters = ["text": text]
            let response: TransactionResponse = try await client.request(
                endpoint,
                parameters: parameters,
                headers: headers,
                responseType: TransactionResponse.self
            )
            return response.data.toDomain()
        }
    }
}


