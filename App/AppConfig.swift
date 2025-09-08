//
//  AppConfig.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//


import Foundation

enum AppConfig {
    static let baseURL = "https://0b1f8da97613.ngrok-free.app/"
    static let appName = "Casha"
    
    #if DEBUG
    static let environment: Environment = .development
    static let isDebug = true
    #else
    static let environment: Environment = .production
    static let isDebug = false
    #endif
    
    enum Environment {
        case development
        case staging
        case production
        
        var name: String {
            switch self {
            case .development: return "Development"
            case .staging: return "Staging"
            case .production: return "Production"
            }
        }
    }
}
