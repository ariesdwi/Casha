
//
//  LoginState.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 06/09/25.
//

import Foundation
import SwiftUI
import Domain
import Core
import Data

@MainActor
final class LoginState: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var accessToken: String? = nil
    @Published private(set) var isLoggedIn: Bool = false
    
    private let loginUseCase: LoginUseCase
    private let transactionSyncManager: TransactionSyncManager
    
    init(
        loginUsecase: LoginUseCase,
        transactionSyncManager: TransactionSyncManager
    ) {
        self.loginUseCase = loginUsecase
        self.transactionSyncManager = transactionSyncManager
        
        // 🔑 Auto-load stored token on init
        if let token = AuthManager.shared.getToken(), !token.isEmpty {
            self.accessToken = token
            self.isLoggedIn = true
        }
    }
    
    func login() async {
        do {
            let token = try await loginUseCase.execute(email: email, password: password)
            
            // 🔑 Save token persistently
            AuthManager.shared.saveToken(token)
            
            accessToken = token
            // 📡 Sync transactions right after login
            try await transactionSyncManager.syncAllTransactions(
                periodStart: "2025-07-01",
                periodEnd: "2025-09-30",
                page: 1,
                limit: 50
            )
            
            isLoggedIn = true
            
        } catch {
            print("❌ Login failed: \(error)")
            accessToken = nil
            isLoggedIn = false
        }
    }
    
    func logout() {
        AuthManager.shared.clearToken()
        accessToken = nil
        isLoggedIn = false
    }
    
    func checkStoredToken() {
        if let token = AuthManager.shared.getToken() {
            accessToken = token
            isLoggedIn = true
        }
    }
}


