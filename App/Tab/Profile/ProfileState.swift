//
//  ProfileState.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import Foundation
import Domain

@MainActor
final class ProfileState: ObservableObject {
    @Published var profile: ProfileCasha?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let getProfileUsecase: GetProfileUsecase
    // later you can add: private let updateProfileUsecase: UpdateProfileUsecase

    init(getProfileUsecase: GetProfileUsecase) {
        self.getProfileUsecase = getProfileUsecase
    }

    func fetchProfile() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await getProfileUsecase.execute()
            self.profile = result
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
