//
//  ProfileEditView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 10/09/25.
//


import SwiftUI
import Domain

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var state: ProfileState
    
    @State private var name: String
    @State private var email: String
    @State private var phone: String
    @State private var isSaving = false
    @State private var errorMessage: String?
    
    init(profile: UserCasha) {
        _name = State(initialValue: profile.name)
        _email = State(initialValue: profile.email)
        _phone = State(initialValue: profile.phone ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                        .autocapitalization(.words)
                    
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    TextField("Phone", text: $phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
                
                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    if isSaving {
                        ProgressView()
                    } else {
                        Button("Save") {
                            saveProfile()
                        }
                        .disabled(!isFormValid)
                    }
                }
            }
            .interactiveDismissDisabled(isSaving) // Prevent dismiss while saving
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && isValidEmail(email)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func saveProfile() {
        isSaving = true
        errorMessage = nil
        
        let updatedProfile = UpdateProfileRequest(
            name: name,
            email: email,
            phone: phone.isEmpty ? nil : phone
        )
        
        Task {
            do {
                try await state.updateProfile(updatedProfile)
                await MainActor.run {
                    isSaving = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isSaving = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
