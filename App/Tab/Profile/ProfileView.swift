//
//  Profile.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//

import SwiftUI
import Domain

struct ProfileView: View {
    // MARK: - Environment & State
    @EnvironmentObject var state: ProfileState
    @EnvironmentObject var loginState: LoginState

    // MARK: - Body
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ZStack(alignment: .top) {
                    Color.clear.ignoresSafeArea()

                    VStack(spacing: 0) {
                        // Error banner
                        if let error = state.lastError {
                            Text(error)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                        }

                        // Content
                        if let profile = state.profile {
                            profileContent(profile)
                        } else {
                            placeholderContent
                        }
                    }
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(.hidden, for: .navigationBar)
                .toolbar {
                    loadingIndicator
                }
                .task { await state.refreshProfile() }
            }
        } else {
            Text("Only supported on iOS 16+")
        }
    }
}

// MARK: - Toolbar
private extension ProfileView {
    var loadingIndicator: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if state.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
}

// MARK: - Content Sections
private extension ProfileView {
    func profileContent(_ profile: UserCasha) -> some View {
        VStack(spacing: 24) {
            profileHeader(profile)
            profileMenu
            Spacer()
        }
        .padding(.horizontal)
    }

    func profileHeader(_ profile: UserCasha) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.cashaPrimary)
                .padding(.top, 32)

            VStack(spacing: 4) {
                Text(profile.name)
                    .font(.title2.bold())

                Text(profile.email)
                    .font(.subheadline)
                    .foregroundColor(.cashaTextSecondary)
            }

            if let updated = state.lastUpdated {
                Text("Last updated: \(updated.formatted(.dateTime.hour().minute()))")
                    .font(.footnote)
                    .foregroundColor(.cashaTextSecondary)
            }
        }
    }

    var profileMenu: some View {
        List {
            Section {
                ProfileRow(icon: "pencil", title: "Edit Profile")
                ProfileRow(icon: "lock", title: "Change PIN")
                ProfileRow(icon: "gearshape", title: "Settings")
            }
            .listRowBackground(Color(.systemGray6))

            Section {
                Button(role: .destructive) {
                    loginState.logout()
                    print("Logout tapped")
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                        Text("Logout")
                    }
                }
            }
            .listRowBackground(Color(.systemGray6))
        }
        .modifier(ScrollContentBackgroundHiddenIfAvailable())
        .listStyle(.insetGrouped)
    }

    var placeholderContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.badge.exclam")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No profile loaded")
                .foregroundColor(.cashaTextSecondary)
        }
        .padding(.top, 40)
    }

    struct ScrollContentBackgroundHiddenIfAvailable: ViewModifier {
        func body(content: Content) -> some View {
            if #available(iOS 16.0, *) {
                content.scrollContentBackground(.hidden)
            } else {
                content
            }
        }
    }
}

// MARK: - Profile Row
struct ProfileRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
        }
    }
}
