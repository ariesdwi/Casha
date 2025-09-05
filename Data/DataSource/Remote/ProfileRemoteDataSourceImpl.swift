//
//  ProfileRemoteDataSourceImpl.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//


import Foundation
import Core
import Domain

public final class ProfileRemoteDataSourceImpl: RemoteProfileRepository {
    
    private let client: NetworkClient
    private let sessionUserID: String
    private let authorizationToken: String
    
    public init(client: NetworkClient, sessionUserID: String, authorizationToken: String) {
        self.client = client
        self.sessionUserID = sessionUserID
        self.authorizationToken = authorizationToken
    }
    
    
    public func getProfile() async throws -> ProfileCasha {
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
    
    
}
