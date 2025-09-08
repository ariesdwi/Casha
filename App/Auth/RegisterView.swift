//
//  RegisterView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 08/09/25.
//
//

import SwiftUI
import AuthenticationServices

struct RegisterView: View {
    @EnvironmentObject var state: RegisterState
    @EnvironmentObject var loginState: LoginState
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case name, email, password, avatar
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        formView
                        termsView
                        registerButton
                        dividerView
                        socialLoginView
                        signInLink
                    }
                    .padding(.vertical, 24)
                }
                .scrollDismissesKeyboard(.interactively)
                .background(Color.cashaBackground.ignoresSafeArea())
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                            .foregroundColor(.cashaPrimary)
                            .disabled(state.isLoading)
                    }
                    ToolbarItem(placement: .principal) {
                        if state.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    }
                }
                .onTapGesture { hideKeyboard() }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.cashaPrimary)
                .symbolRenderingMode(.hierarchical)
            
            VStack(spacing: 28) {
                Text("Create Account")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.cashaTextPrimary)
                
                Text("Join Casha to take control of your finances and achieve your financial goals")
                    .font(.subheadline)
                    .foregroundColor(.cashaTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 16)
            }
        }
        .padding(.top, 20)
    }
    
    private var formView: some View {
        VStack(spacing: 20) {
            // Full Name
            formField(
                title: "Full Name",
                text: $state.name,
                field: .name,
                placeholder: "Enter your full name",
                contentType: .name,
                submitField: .email,           // next focus field
                submitLabel: .next
            )
            
            // Email
            formField(
                title: "Email",
                text: $state.email,
                field: .email,
                placeholder: "Enter your email",
                contentType: .emailAddress,
                keyboard: .emailAddress,
                submitField: .password,        // next focus field
                submitLabel: .next
            )
            
            // Password
            secureFormField(
                title: "Password",
                text: $state.password,
                field: .password,
                placeholder: "Create a password",
                submit: .avatar           // next focus field
            )
            
            // Avatar URL (optional)
            formField(
                title: "Avatar URL (optional)",
                text: $state.avatar,
                field: .avatar,
                placeholder: "Paste avatar image URL",
                contentType: .URL,
                keyboard: .URL,
                submitLabel: .done,            // Done key for last field
                onSubmit: {
                    Task { await performRegistration() }
                }
            )
        }
        .padding(.horizontal)
    }

    
    private var termsView: some View {
        Text("By signing up, you agree to our Terms of Service and Privacy Policy")
            .font(.caption)
            .foregroundColor(.cashaTextSecondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
    
    private var registerButton: some View {
        Button(action: { Task { await performRegistration() } }) {
            if state.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text("Create Account")
                    .fontWeight(.semibold)
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.cashaPrimary)
        .cornerRadius(12)
        .padding(.horizontal)
        .disabled(state.isLoading || !isFormValid)
        .opacity((state.isLoading || !isFormValid) ? 0.6 : 1)
    }
    
    private var dividerView: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.cashaTextSecondary)
            Text("or")
                .font(.caption)
                .foregroundColor(.cashaPrimary)
                .padding(.horizontal, 8)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.cashaTextSecondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var socialLoginView: some View {
        HStack(spacing: 16) {
            // Apple Sign Up
            SignInWithAppleButton(.signUp) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                handleAppleSignUp(result: result)
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .cornerRadius(12)
            
            // Google Sign Up (placeholder)
            Button(action: { /* TODO: Handle Google registration */ }) {
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
    }
    
    private var signInLink: some View {
        HStack {
            Text("Already have an account?")
                .foregroundColor(.cashaTextSecondary)
            if #available(iOS 16.0, *) {
                Button("Sign In") { dismiss() }
                    .foregroundColor(.cashaPrimary)
                    .fontWeight(.semibold)
            } else {
                // Fallback on earlier versions
            }
        }
        .font(.subheadline)
        .padding(.top, 8)
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        !state.name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !state.email.trimmingCharacters(in: .whitespaces).isEmpty &&
        state.password.count >= 6
    }
    
    // MARK: - Private Methods
    private func performRegistration() async {
        hideKeyboard()
        
        Task {
            await state.register()
            loginState.checkStoredToken()
        }
        // Dismiss after registration
        if !state.isLoading {
            dismiss()
        }
    }
    
    private func handleAppleSignUp(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            print("Apple sign-up success: \(authResults)")
        case .failure(let error):
            print("Apple sign-up failed: \(error.localizedDescription)")
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // MARK: - Helper Views
    private func formField(
        title: String,
        text: Binding<String>,
        field: Field,
        placeholder: String,
        contentType: UITextContentType,
        keyboard: UIKeyboardType = .default,
        submitField: Field? = nil,             // next field to focus
        submitLabel: SubmitLabel = .next,      // return key type
        onSubmit: (() -> Void)? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.cashaTextSecondary)
                .padding(.horizontal, 4)
            
            TextField(placeholder, text: text)
                .textContentType(contentType)
                .keyboardType(keyboard)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding()
                .background(Color.cashaCard)
                .cornerRadius(12)
                .focused($focusedField, equals: field)
                .submitLabel(submitLabel)              // use SubmitLabel here
                .onSubmit {
                    if let action = onSubmit {
                        action()
                    } else if let next = submitField {
                        focusedField = next
                    }
                }
        }
    }

    
    private func secureFormField(title: String, text: Binding<String>, field: Field, placeholder: String, submit: Field) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.cashaTextSecondary)
                .padding(.horizontal, 4)
            
            SecureField(placeholder, text: text)
                .textContentType(.newPassword)
                .padding()
                .background(Color.cashaCard)
                .cornerRadius(12)
                .focused($focusedField, equals: field)
                .submitLabel(.next)
                .onSubmit { focusedField = submit }
        }
    }
}



