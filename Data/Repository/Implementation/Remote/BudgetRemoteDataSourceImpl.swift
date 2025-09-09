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

    public init(client: NetworkClient) {
        self.client = client
    }
    
    public func fetchBudgets(monthYear: String? = nil) async throws -> [BudgetCasha] {
        let endpoint = Endpoint.budgetList
        
        var parameters: [String: Any] = [:]
        if let monthYear = monthYear {
            let apiMonth = DateHelper.convertToApiMonth(monthYear)
            parameters["month"] = apiMonth
        }
        
        let headers: [String: String] = [
            "Authorization": "Bearer " + (AuthManager.shared.getToken() ?? "")
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
        let endpoint = Endpoint.budgetCreate
        
        let headers: [String: String] = [
            "Authorization": "Bearer " + (AuthManager.shared.getToken() ?? ""),
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "amount": request.amount,
            "month": request.month,
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

    public func fetchSummaryBudgets(monthYear: String? = nil) async throws -> BudgetSummary {
        let endpoint = Endpoint.budgetSummary
        
        var parameters: [String: Any] = [:]
        if let monthYear = monthYear {
            let apiMonth = DateHelper.convertToApiMonth(monthYear)
            parameters["month"] = apiMonth
        }
        
        let headers: [String: String] = [
            "Authorization": "Bearer " + (AuthManager.shared.getToken() ?? "")
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

