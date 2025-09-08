//
//  LoginView.swift
//  Casha
//
//  Created by Aries on 08/09/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var state: LoginState
    @State private var isPasswordVisible: Bool = false
    @State private var isLoading: Bool = false
    @State private var showRegisterSheet: Bool = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        if #available(iOS 16.4, *) {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 32) {
                        // MARK: - Header
                        VStack(spacing: 16) {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.cashaPrimary)
                                .symbolRenderingMode(.hierarchical)
                            
                            VStack(spacing: 8) {
                                Text("Welcome Back")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.cashaTextPrimary)
                                
                                Text("Sign in to manage your expenses and track your financial goals")
                                    .font(.subheadline)
                                    .foregroundColor(.cashaTextSecondary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(.top, 40)
                        
                        // MARK: - Login Form
                        VStack(spacing: 20) {
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.caption)
                                    .foregroundColor(.cashaTextSecondary)
                                    .padding(.horizontal, 4)
                                
                                TextField("Enter your email", text: $state.email)
                                    .focused($focusedField, equals: .email)
                                    .padding()
                                    .background(Color.cashaCard)
                                    .cornerRadius(12)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                                    .textContentType(.emailAddress)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .password
                                    }
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.caption)
                                    .foregroundColor(.cashaTextSecondary)
                                    .padding(.horizontal, 4)
                                
                                HStack {
                                    if isPasswordVisible {
                                        TextField("Enter your password", text: $state.password)
                                            .focused($focusedField, equals: .password)
                                            .textContentType(.password)
                                    } else {
                                        SecureField("Enter your password", text: $state.password)
                                            .focused($focusedField, equals: .password)
                                            .textContentType(.password)
                                    }
                                    
                                    Button(action: { isPasswordVisible.toggle() }) {
                                        if #available(iOS 17.0, *) {
                                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                                .foregroundColor(.cashaTextSecondary)
                                                .contentTransition(.symbolEffect(.replace))
                                        } else {
                                            // Fallback on earlier versions
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.cashaCard)
                                .cornerRadius(12)
                                .submitLabel(.go)
                                .onSubmit {
                                    Task {
                                        await performLogin()
                                    }
                                }
                            }
                            
                            // Forgot Password
                            HStack {
                                Spacer()
                                Button("Forgot Password?") {
                                    // TODO: Navigate to forgot password
                                }
                                .font(.footnote)
                                .foregroundColor(.cashaPrimary)
                                .fontWeight(.medium)
                            }
                        }
                        .padding(.horizontal)
                        
                        // MARK: - Login Button
                        Button(action: {
                            Task {
                                await performLogin()
                            }
                        }) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign In")
                                    .fontWeight(.semibold)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.cashaPrimary)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .disabled(isLoading || state.email.isEmpty || state.password.isEmpty)
                        .opacity((isLoading || state.email.isEmpty || state.password.isEmpty) ? 0.6 : 1)
                        
                        // MARK: - Divider
                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.cashaTextSecondary)
                            
                            Text("or continue with")
                                .font(.caption)
                                .foregroundColor(.cashaPrimary)
                                .padding(.horizontal, 8)
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.cashaTextSecondary)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        
                        // MARK: - Social Login
                        HStack(spacing: 16) {
                            // Apple Sign In
                            SignInWithAppleButton(.signIn) { request in
                                request.requestedScopes = [.fullName, .email]
                            } onCompletion: { result in
                                handleAppleSignIn(result: result)
                            }
                            .signInWithAppleButtonStyle(.black)
                            .frame(height: 50)
                            .cornerRadius(12)
                            
                            // Google Sign In
                            Button(action: {
                                // TODO: Handle Google login
                            }) {
                                Image(systemName: "g.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.red)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        
                        // MARK: - Sign Up
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.cashaTextSecondary)
                            
                            Button("Sign Up") {
                                showRegisterSheet = true
                            }
                            .foregroundColor(.cashaPrimary)
                            .fontWeight(.semibold)
                        }
                        .font(.subheadline)
                        .padding(.top, 8)
                    }
                    .padding(.vertical, 32)
                }
                .scrollDismissesKeyboard(.interactively)
                .background(Color.cashaBackground.ignoresSafeArea())
                .sheet(isPresented: $showRegisterSheet) {
                    RegisterView()
                        .environmentObject(state)
                        .presentationDetents([ .large])
                        .presentationDragIndicator(.visible)
                        .presentationCornerRadius(20)
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - Private Methods
    private func performLogin() async {
        isLoading = true
        hideKeyboard()
        await state.login()
        isLoading = false
    }
    
    private func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            print("Apple sign-in success: \(authResults)")
            // TODO: Process Apple sign-in and connect with LoginState
        case .failure(let error):
            print("Apple sign-in failed: \(error.localizedDescription)")
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
