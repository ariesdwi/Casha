//
//  RegisterState.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 08/09/25.
//


import Foundation
import SwiftUI
import Domain
import Core
import Data

@MainActor
final class RegisterState: ObservableObject {
    // MARK: - Input fields
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var avatar = ""
    
    // MARK: - State
    @Published private(set) var isLoading: Bool = false
    
    
    private let registerUseCase: RegisterUseCase
    private let transactionSyncManager: TransactionSyncManager
    
    // MARK: - Init
    init(
        registerUseCase: RegisterUseCase,
        transactionSyncManager: TransactionSyncManager
    ) {
        self.registerUseCase = registerUseCase
        self.transactionSyncManager = transactionSyncManager
    }
    
    // MARK: - Actions
    func register() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let token = try await registerUseCase.execute(
                email: email,
                password: password,
                name: name,
                avatar: avatar
            )
            
            // Save token persistently
            AuthManager.shared.saveToken(token)
            
             
            // Sync transactions after register (optional)
            try await transactionSyncManager.syncAllTransactions(
                periodStart: "2025-07-01",
                periodEnd: "2025-09-30",
                page: 1,
                limit: 50
            )
            
        } catch {
            print("❌ Registration failed: \(error)")
            
        }
    }
}
