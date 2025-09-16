//
//  RegisterState.swift
//  Casha
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
    @Published var phone = ""
    @Published private(set) var isLoading: Bool = false
    
    // MARK: - Toast message
    @Published var toastMessage: String? = nil
    
    private let registerUseCase: RegisterUseCase
    
    // MARK: - Init
    init(
        registerUseCase: RegisterUseCase
    ) {
        self.registerUseCase = registerUseCase
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
                phone: phone
            )
            
            // Show success toast
            toastMessage = "Registration successful ✅"
            
            // Optionally, auto-clear after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { self.toastMessage = nil }
            }
            
        } catch let error as NetworkError {
            // Handle custom NetworkError
            switch error {
            case .serverError(let message):
                toastMessage = message
            default:
                toastMessage = error.localizedDescription
            }
            print("❌ Registration failed: \(error)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { self.toastMessage = nil }
            }
            
        } catch {
            // Handle other errors
            toastMessage = error.localizedDescription
            print("❌ Registration failed: \(error)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { self.toastMessage = nil }
            }
        }
    }
}
