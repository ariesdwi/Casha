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
    @Published var phone = ""
    @Published private(set) var isLoading: Bool = false

    private let registerUseCase: RegisterUseCase
    
    // MARK: - Init
    init(
        registerUseCase: RegisterUseCase,
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
        } catch {
            print("❌ Registration failed: \(error)")
            
        }
    }
}
