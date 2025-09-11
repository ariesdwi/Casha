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
    @Published var isLoading: Bool = false
    
    private let getProfileUsecase: GetProfileUseCase
    private let updateProfileUsecase: UpdateProfileUseCase
    
    init(getProfileUsecase: GetProfileUseCase, updateProfileUsecase: UpdateProfileUseCase) {
        self.getProfileUsecase = getProfileUsecase
        self.updateProfileUsecase = updateProfileUsecase
    }
    
    func refreshProfile() async {
        isLoading = true
        defer { isLoading = false }
        
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
    
    func updateProfile(_ request: UpdateProfileRequest) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let updatedProfile = try await updateProfileUsecase.execute(user: request)
            self.profile = updatedProfile
            self.lastUpdated = Date()
            self.lastError = nil
            print("✅ Profile updated successfully at \(self.lastUpdated!)")
        } catch {
            self.lastError = error.localizedDescription
            print("❌ Failed to update profile: \(error.localizedDescription)")
            throw error
        }
    }
}
