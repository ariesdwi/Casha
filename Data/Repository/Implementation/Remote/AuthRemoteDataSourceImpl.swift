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
   
    public init(client: NetworkClient) {
        self.client = client
    }
    
    
    public func getProfile() async throws -> UserCasha {
        let endpoint = Endpoint.getProfile
        
        let headers: [String: String] = [
            "Authorization": "Bearer " + (AuthManager.shared.getToken() ?? "")
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
        
       
        
        return response.data.accessToken ?? ""
    }
    
    public func register(email: String, password: String, name: String, phone: String) async throws -> String {
        let endpoint = Endpoint.signup
        
        let body: [String: Any] = [
            "email": email,
            "password": password,
            "name": name,
            "phone": phone,
            "avatar": ""
        ]
        
        let headers: [String: String] = [
            "Content-Type": "application/json",
        ]
        
        let response: LoginResponse = try await client.request(
            endpoint,
            parameters: body,
            headers: headers,
            responseType: LoginResponse.self
        )
        
        return response.data.accessToken ?? ""

    }
    
    
}
