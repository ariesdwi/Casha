//
//  ProfileState.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//


import Foundation
import Domain
import Core

@MainActor
final class ProfileState: ObservableObject {
    // Data
    @Published var profile: UserCasha?
    
    // Metadata
    @Published var lastUpdated: Date? = nil
    @Published var lastError: String? = nil
    
    private let getProfileUsecase: GetProfileUsecase
    // later: private let updateProfileUsecase: UpdateProfileUsecase
    
    init(getProfileUsecase: GetProfileUsecase) {
        self.getProfileUsecase = getProfileUsecase
    }
    
    func refreshProfile() async {
        do {
            let result = try await getProfileUsecase.execute()
            self.profile = result
            self.lastUpdated = Date()
            self.lastError = nil
            print("✅ Profile refreshed at \(self.lastUpdated!)")
        } catch {
            self.lastError = error.localizedDescription
            print("❌ Failed to refresh profile: \(error.localizedDescription)")
        }
    }
    
    
    
}
