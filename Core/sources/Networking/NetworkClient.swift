//
//  APIClient.swift
//  MusicPlayer_Nusatech
//
//  Created by Aries Prasetyo on 25/03/25.
//


import Foundation

public struct UploadFile {
    public let fieldName: String
    public let fileURL: URL

    public init(fieldName: String, fileURL: URL) {
        self.fieldName = fieldName
        self.fileURL = fileURL
    }
}

public protocol NetworkClient {
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        parameters: [String: Any]?,
        headers: [String: String]?,
        responseType: T.Type
    ) async throws -> T
    
    func uploadForm<T: Decodable>(
        _ endpoint: Endpoint,
        formFields: [String: String],
        headers: [String: String]?,
        files: [UploadFile],
        responseType: T.Type
    ) async throws -> T
}
