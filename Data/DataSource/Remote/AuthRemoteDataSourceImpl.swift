//
//  ProfileRemoteDataSourceImpl.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//


import Foundation
import Core
import Domain

public final class AuthRemoteDataSourceImpl: RemoteAuthRepositoryProtocol {
    
    private let client: NetworkClient
    private let sessionUserID: String
    private let authorizationToken: String
    
    public init(client: NetworkClient, sessionUserID: String, authorizationToken: String) {
        self.client = client
        self.sessionUserID = sessionUserID
        self.authorizationToken = authorizationToken
    }
    
    
    public func getProfile() async throws -> UserCasha {
        let endpoint = Endpoint.getProfile
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(authorizationToken)",
            "session_user_id": sessionUserID
        ]
        
        let parameters: [String: Any] = [ :
                                            //            "period_start": periodStart,
                                          //            "period_end": periodEnd
        ]
        
        let response: ProfileResponse = try await client.request(
            endpoint,
            parameters: parameters,
            headers: headers,
            responseType: ProfileResponse.self
        )
        
        return response.data.toDomain()
    }
    
    
    public func login(email: String, password: String) async throws -> String {
        let endpoint = Endpoint.login
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        let headers: [String: String] = [
            "Content-Type": "application/json",
        ]
        
        let response: LoginResponse = try await client.request(
            endpoint,
            parameters: body,
            headers: headers, // Usually no auth needed for login
            responseType: LoginResponse.self
        )
        
       
        
        return response.data.accessToken
    }
    
}
