//
//  BudgetRemoteDataSourceImpl.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 03/09/25.
//

import Foundation
import Core
import Domain

public final class BudgetRemoteDataSourceImpl: RemoteBudgetRepositoryProtocol {
  
    
    private let client: NetworkClient
    private let sessionUserID: String
    private let authorizationToken: String
    
    public init(client: NetworkClient, sessionUserID: String, authorizationToken: String) {
        self.client = client
        self.sessionUserID = sessionUserID
        self.authorizationToken = authorizationToken
    }
    
    public func fetchBudgets() async throws -> [BudgetCasha] {
        let endpoint = Endpoint.budgetList
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(authorizationToken)",
            "session_user_id": sessionUserID
        ]
        
        let parameters: [String: Any] = [ :
//            "period_start": periodStart,
//            "period_end": periodEnd
        ]
        
        let response: BudgetListResponse = try await client.request(
            endpoint,
            parameters: parameters,
            headers: headers,
            responseType: BudgetListResponse.self
        )
        
        return response.data.map { $0.toDomain() }
    }
    
    public func createBudget(request: NewBudgetRequest) async throws -> BudgetCasha {
        let endpoint = Endpoint.budgetCreate // You'll need to define this endpoint
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(authorizationToken)",
            "session_user_id": sessionUserID,
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "amount": request.amount,
            "period": request.period,
            "startDate": request.startDate,
            "endDate": request.endDate,
            "category": request.category
        ]
        
        let response: BudgetResponse = try await client.request(
            endpoint,
            parameters: parameters,
            headers: headers,
            responseType: BudgetResponse.self
        )
        
        return response.data.toDomain()
    }
    
    public func fetchsummaryBudgets() async throws -> BudgetSummary {
        let endpoint = Endpoint.budgetSummary
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(authorizationToken)",
            "session_user_id": sessionUserID
        ]
        
        let parameters: [String: Any] = [ :
//            "period_start": periodStart,
//            "period_end": periodEnd
        ]
        
        let response: BudgetSummaryResponse = try await client.request(
            endpoint,
            parameters: parameters,
            headers: headers,
            responseType: BudgetSummaryResponse.self
        )
        
        return response.data.toDomain()
    }
    
}
