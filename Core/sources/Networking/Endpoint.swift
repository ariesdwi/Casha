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

    public static let spending = Endpoint(path: "v1/spending", method: .post)
    public static let spendingList = Endpoint(path: "v1/spending/list", method: .get)

}

public enum HTTPMethod {
    case get, post, put, delete
}
