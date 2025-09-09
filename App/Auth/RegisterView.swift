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
    @State private var showCountryPicker = false
    @State private var selectedCountry: Country = .indonesia
    
    enum Field: Hashable {
        case name, email, password, phone
    }
    
    struct Country: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let code: String
        let flag: String
        let dialCode: String
        
        static let indonesia = Country(name: "Indonesia", code: "ID", flag: "🇮🇩", dialCode: "+62")
        static let singapore = Country(name: "Singapore", code: "SG", flag: "🇸🇬", dialCode: "+65")
        static let malaysia = Country(name: "Malaysia", code: "MY", flag: "🇲🇾", dialCode: "+60")
        static let vietnam = Country(name: "Vietnam", code: "VN", flag: "🇻🇳", dialCode: "+84")
        static let thailand = Country(name: "Thailand", code: "TH", flag: "🇹🇭", dialCode: "+66")
        
        static let popularCountries: [Country] = [
            .indonesia, .singapore, .malaysia, .vietnam, .thailand,
            Country(name: "United States", code: "US", flag: "🇺🇸", dialCode: "+1"),
            Country(name: "United Kingdom", code: "GB", flag: "🇬🇧", dialCode: "+44"),
            Country(name: "Australia", code: "AU", flag: "🇦🇺", dialCode: "+61"),
            Country(name: "Japan", code: "JP", flag: "🇯🇵", dialCode: "+81"),
            Country(name: "South Korea", code: "KR", flag: "🇰🇷", dialCode: "+82"),
            Country(name: "China", code: "CN", flag: "🇨🇳", dialCode: "+86"),
            Country(name: "India", code: "IN", flag: "🇮🇳", dialCode: "+91")
        ]
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
                .sheet(isPresented: $showCountryPicker) {
                    CountryPickerView(selectedCountry: $selectedCountry, isPresented: $showCountryPicker)
                }
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
                submitField: .email,
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
                submitField: .password,
                submitLabel: .next
            )
            
            // Password
            secureFormField(
                title: "Password",
                text: $state.password,
                field: .password,
                placeholder: "Create a password",
                submit: .phone
            )
            
            // Phone with country code selection
            phoneField
        }
        .padding(.horizontal)
    }
    
    private var phoneField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Phone")
                .font(.caption)
                .foregroundColor(.cashaTextSecondary)
                .padding(.horizontal, 4)
            
            HStack(spacing: 0) {
                // Country Code Button
                Button(action: { showCountryPicker = true }) {
                    HStack(spacing: 4) {
                        Text(selectedCountry.flag)
                        Text(selectedCountry.dialCode)
                            .foregroundColor(.cashaTextPrimary)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.cashaTextSecondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.cashaCard)
                }
                
                // Phone Number TextField
                TextField("Phone Number", text: Binding(
                    get: {
                        // Remove country code prefix for display
                        if state.phone.hasPrefix(selectedCountry.dialCode) {
                            return String(state.phone.dropFirst(selectedCountry.dialCode.count))
                        }
                        return state.phone
                    },
                    set: { newValue in
                        // Automatically add country code prefix and filter non-numeric characters
                        let numericString = newValue.filter { $0.isNumber }
                        state.phone = selectedCountry.dialCode + numericString
                    }
                ))
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .onSubmit {
                    Task { await performRegistration() }
                }
                .focused($focusedField, equals: .phone)
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
            }
            .background(Color.cashaCard)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(focusedField == .phone ? Color.cashaPrimary : Color.clear, lineWidth: 1)
            )
        }
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
        state.password.count >= 6 &&
        state.phone.count > selectedCountry.dialCode.count // Country code plus at least 1 digit
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
        submitField: Field? = nil,
        submitLabel: SubmitLabel = .next,
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
                .submitLabel(submitLabel)
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

// MARK: - Country Picker View
struct CountryPickerView: View {
    @Binding var selectedCountry: RegisterView.Country
    @Binding var isPresented: Bool
    @State private var searchText = ""
    
    var filteredCountries: [RegisterView.Country] {
        if searchText.isEmpty {
            return RegisterView.Country.popularCountries
        } else {
            return RegisterView.Country.popularCountries.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.dialCode.localizedCaseInsensitiveContains(searchText) ||
                $0.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredCountries) { country in
                Button(action: {
                    selectedCountry = country
                    isPresented = false
                }) {
                    HStack {
                        Text(country.flag)
                            .font(.title2)
                        VStack(alignment: .leading) {
                            Text(country.name)
                                .foregroundColor(.primary)
                            Text(country.dialCode)
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        Spacer()
                        if country.id == selectedCountry.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search country")
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}
