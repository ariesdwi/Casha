//
//  Endpoint.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 23/07/25.
//

import Foundation
import Alamofire

public struct Endpoint {
    public let path: String
    public let method: HTTPMethod

    public init(path: String, method: HTTPMethod) {
        self.path = path
        self.method = method
    }

    // MARK: - Transactions
    public static let spending = Endpoint(path: "transactions/create", method: .post)
    public static let spendingList = Endpoint(path: "transactions", method: .get)
    
    public static func spendingUpdate(id: String) -> Endpoint {
        Endpoint(path: "transactions/\(id)", method: .put) // pakai PATCH biar partial update
    }
    
    public static func spendingDelete(id: String) -> Endpoint {
        Endpoint(path: "transactions/\(id)", method: .delete)
    }

    // MARK: - Budgets
    public static let budgetList = Endpoint(path: "budgets/", method: .get)
    public static let budgetSummary = Endpoint(path: "budgets/summary", method: .get)
    public static let budgetCreate = Endpoint(path: "budgets/", method: .post)
    public static let budegtUpdate = Endpoint(path: "budgets/", method: .put)
    public static let budgetDelete = Endpoint(path: "budgets/", method: .delete)

    // MARK: - Auth
    public static let getProfile = Endpoint(path: "auth/profile", method: .get)
    public static let login = Endpoint(path: "auth/login", method: .post)
    public static let signup = Endpoint(path: "auth/signup", method: .post)
    public static let updateProfile = Endpoint(path: "auth/profile/", method: .patch)
}

public enum HTTPMethod {
    case get, post, put, delete, patch
}

