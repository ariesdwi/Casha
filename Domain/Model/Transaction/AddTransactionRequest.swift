//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 24/07/25.
//
import Foundation

public struct AddTransactionRequest {
    public let message: String?
    public let imageURL: URL?

    public init(message: String? = nil, imageURL: URL? = nil) {
        self.message = message
        self.imageURL = imageURL
    }
}


