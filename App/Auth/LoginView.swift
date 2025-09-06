//
//  LoginView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 06/09/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginState: LoginState
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $loginState.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $loginState.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Login") {
                Task {
                    await loginState.login()
                }
            }
        }
        .padding()
    }
}

