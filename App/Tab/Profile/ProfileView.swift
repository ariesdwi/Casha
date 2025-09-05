//
//  Profile.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//


import SwiftUI
import Domain

struct ProfileView: View {
    @EnvironmentObject var state: ProfileState
    @State private var showSnackbar = false
    @State private var snackbarMessage = ""
    @State private var snackbarIsError = false

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ZStack {
                    Color.cashaBackground.ignoresSafeArea()

                    if state.isLoading {
                        ProgressView("Loading profile...")
                    } else if let profile = state.profile {
                        VStack(spacing: 24) {
                            // MARK: - Profile Picture
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.cashaPrimary)
                                .padding(.top, 32)

                            // MARK: - User Info
                            VStack(spacing: 4) {
                                Text(profile.name)
                                    .font(.title2.bold())

                                Text(profile.email)
                                    .font(.subheadline)
                                    .foregroundColor(.cashaTextSecondary)
                            }

                            // MARK: - Menu Section
                            List {
                                Section {
                                    ProfileRow(icon: "pencil", title: "Edit Profile")
                                    ProfileRow(icon: "lock", title: "Change PIN")
                                    ProfileRow(icon: "gearshape", title: "Settings")
                                }
                                .listRowBackground(Color(.systemGray6))

                                Section {
                                    Button(role: .destructive) {
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
                            .scrollContentBackground(.hidden)
                            .listStyle(.insetGrouped)

                            Spacer()
                        }
                        .padding(.horizontal)

                    } else if let error = state.errorMessage {
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.red)
                            Text(error)
                                .foregroundColor(.red)
                        }
                    }

                    // Snackbar
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
                .navigationTitle("Profile")
                .task {
                    await state.fetchProfile()
                }
                .onChange(of: state.errorMessage) { newValue in
                    if let error = newValue {
                        showSnackbarMessage(error, isError: true)
                    }
                }
            }
        } else {
            Text("Only supported on iOS 16+")
        }
    }

    private func showSnackbarMessage(_ message: String, isError: Bool) {
        snackbarMessage = message
        snackbarIsError = isError
        withAnimation { showSnackbar = true }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation { showSnackbar = false }
        }
    }
}


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

//#Preview {
//    ProfileView()
//}
