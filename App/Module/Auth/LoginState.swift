
import Foundation
import SwiftUI
import Domain
import Core
import Data

@MainActor
final class LoginState: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    // Unified toast message (success or error)
    @Published var toastMessage: String? = nil
    
    @Published private(set) var accessToken: String? = nil
    @Published private(set) var isLoggedIn: Bool = false
    
    private let loginUseCase: LoginUseCase
    private let deleteAllLocalDataUsecase: DeleteAllLocalDataUseCase
    private let transactionSyncManager: TransactionSyncUseCase
    
    init(
        loginUsecase: LoginUseCase,
        deleteAllLocalDataUsecase: DeleteAllLocalDataUseCase,
        transactionSyncManager: TransactionSyncUseCase
    ) {
        self.loginUseCase = loginUsecase
        self.transactionSyncManager = transactionSyncManager
        self.deleteAllLocalDataUsecase = deleteAllLocalDataUsecase
        
        // 🔑 Auto-load stored token on init
        if let token = AuthManager.shared.getToken(), !token.isEmpty {
            self.accessToken = token
            self.isLoggedIn = true
        }
    }
    
    @MainActor
    func login() async {
        do {
            let token = try await loginUseCase.execute(email: email, password: password)
            
            // 🔑 Save token persistently
            AuthManager.shared.saveToken(token)
            accessToken = token
            
//             📡 Sync transactions right after login
            try await transactionSyncManager.syncAllTransactions(
                periodStart: "2025-07-01",
                periodEnd: "2025-09-30",
                page: 1,
                limit: 50
            )
                               
            isLoggedIn = true
            toastMessage = "Login successful ✅" // show success
        } catch let error as NetworkError {
            // Handle your custom NetworkError
            switch error {
            case .serverError(let message):
                toastMessage = message
            default:
                toastMessage = error.localizedDescription
            }
            accessToken = nil
            isLoggedIn = false
        } catch {
            // Handle any other error
            toastMessage = error.localizedDescription
            accessToken = nil
            isLoggedIn = false
        }
    }
    
    func logout() async {
        AuthManager.shared.clearToken()
        accessToken = nil
        isLoggedIn = false
        toastMessage = nil
        await deleteLocalData()
    }
    
    func checkStoredToken() {
        if let token = AuthManager.shared.getToken() {
            accessToken = token
            isLoggedIn = true
        }
    }
    
    func deleteLocalData() async {
        do {
            try await deleteAllLocalDataUsecase.execute()
        } catch {
            toastMessage = "Failed to delete local data: \(error.localizedDescription)"
        }
    }
}


