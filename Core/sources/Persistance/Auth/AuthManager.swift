//
//  AuthManager.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 06/09/25.
//

import Foundation

/// A simple token manager using UserDefaults (replace with Keychain for production)
public final class AuthManager {
    public static let shared = AuthManager()
    private let tokenKey = "accessToken"
    
    private init() {}
    
    /// Save token
    public func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    /// Retrieve token
    public func getToken() -> String? {
        UserDefaults.standard.string(forKey: tokenKey)
    }
    
    /// Check if token exists and is valid
    public func hasValidToken() -> Bool {
        guard let token = getToken(), !token.isEmpty else { return false }
        // Optionally, decode JWT and check expiry
        return true
    }
    
    /// Clear token (logout)
    public func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
