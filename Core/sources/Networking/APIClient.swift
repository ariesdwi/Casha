//
//  Endpoints.swift
//  MusicPlayer_Nusatech
//
//  Created by Aries Prasetyo on 25/03/25.
//


import Foundation
import Alamofire

public final class APIClient: NetworkClient {
    
    private let session: Session
    private let baseURL: String
    
    public init(baseURL: String) {
        self.baseURL = baseURL
        self.session = Session()
    }
    
    // MARK: - Standard JSON Request
    
    public func request<T: Decodable>(
        _ endpoint: Endpoint,
        parameters: [String: Any]?,
        headers: [String: String]?,
        responseType: T.Type
    ) async throws -> T {
        let url = baseURL + endpoint.path
        let afMethod = convertToAFMethod(endpoint.method)
        let afHeaders = HTTPHeaders(headers ?? [:])
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: afMethod,
                parameters: parameters,
                encoding: afMethod == .get ? URLEncoding.default : JSONEncoding.default,
                headers: afHeaders
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    if let data = response.data,
                       let rawJSON = String(data: data, encoding: .utf8) {
                        print("✅ Raw Response JSON:\n\(rawJSON)")
                    }
                    continuation.resume(returning: value)
                case .failure(let error):
                    if let data = response.data,
                       let jsonString = String(data: data, encoding: .utf8) {
                        print("❌ Response JSON Body:\n\(jsonString)")
                        continuation.resume(throwing: NetworkError.serverError(message: jsonString))
                    } else {
                        continuation.resume(throwing: NetworkError.fromAFError(error))
                    }
                }
            }
        }
    }
    
    // MARK: - Multipart Form Upload
    
    public func uploadForm<T: Decodable>(
        _ endpoint: Endpoint,
        formFields: [String: String],
        headers: [String: String]?,
        files: [UploadFile],
        responseType: T.Type
    ) async throws -> T {
        let url = baseURL + endpoint.path
        let afHeaders = HTTPHeaders(headers ?? [:])
        
        return try await withCheckedThrowingContinuation { continuation in
            session.upload(
                multipartFormData: { multipartFormData in
                    // Add form fields
                    for (key, value) in formFields {
                        if let data = value.data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                    
                    // Add files
                    for file in files {
                        multipartFormData.append(file.fileURL, withName: file.fieldName)
                    }
                },
                to: url,
                method: .post,
                headers: afHeaders
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Helper
    
    private func convertToAFMethod(_ method: HTTPMethod) -> Alamofire.HTTPMethod {
        switch method {
        case .get: return .get
        case .post: return .post
        case .put: return .put
        case .delete: return .delete
        }
    }
}




