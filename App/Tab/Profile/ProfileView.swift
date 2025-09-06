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
    
    @State private var showSnackbar = false
    @State private var snackbarMessage = ""
    @State private var snackbarIsError = false

    // MARK: - Body
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ZStack {
                    backgroundLayer
                    contentLayer
                    snackbarOverlay
                }
                .navigationTitle("Profile")
                .task { await state.refreshProfile() }
                .onChange(of: state.lastError, perform: handleErrorChange)
            }
        } else {
            Text("Only supported on iOS 16+")
        }
    }
}

// MARK: - Layers
private extension ProfileView {
    var backgroundLayer: some View {
        Color.clear.ignoresSafeArea()
    }

    @ViewBuilder
    var contentLayer: some View {
        if let profile = state.profile {
            profileContent(profile)
        } else {
            placeholderContent
        }
    }

    var snackbarOverlay: some View {
        Group {
            if showSnackbar {
                VStack {
                    Spacer()
                    SnackbarView(message: snackbarMessage, isError: snackbarIsError)
                        .onTapGesture {
                            withAnimation { showSnackbar = false }
                        }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut, value: showSnackbar)
                .zIndex(1)
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

// MARK: - Event Handlers
private extension ProfileView {
    func handleErrorChange(_ newValue: String?) {
        if let error = newValue {
            showSnackbarMessage(error, isError: true)
        }
    }

    func showSnackbarMessage(_ message: String, isError: Bool) {
        snackbarMessage = message
        snackbarIsError = isError
        withAnimation { showSnackbar = true }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation { showSnackbar = false }
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
