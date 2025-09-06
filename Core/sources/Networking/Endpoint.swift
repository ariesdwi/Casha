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

    public static let spending = Endpoint(path: "transactions/create", method: .post)
    public static let spendingList = Endpoint(path: "transactions", method: .get)
    public static let budgetList = Endpoint(path: "budgets/", method: .get)
    public static let budgetSummary = Endpoint(path: "budgets/summary", method: .get)
    public static let budgetCreate = Endpoint(path: "budgets/", method: .post)
    public static let budegtUpdate = Endpoint(path: "budgets/", method: .put)
    public static let budgetDelete = Endpoint(path: "budgets/", method: .delete)
    public static let getProfile = Endpoint(path: "auth/profile", method: .get)
    public static let login = Endpoint(path: "auth/login", method: .post)
}

public enum HTTPMethod {
    case get, post, put, delete
}
