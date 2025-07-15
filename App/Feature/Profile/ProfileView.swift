//
//  Profile.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack(spacing: 24) {
                    
                    // MARK: - Profile Picture
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.cashaPrimary)
                        .padding(.top, 32)
                    
                    // MARK: - User Info
                    VStack(spacing: 4) {
                        Text("Aries Dwi Prasetiyo")
                            .font(.title2.bold())
                           
                        
                        Text("aries@example.com")
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
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                    .background(Color.cashaBackground)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .background(Color.cashaBackground)
                .navigationTitle("Profile")
            }
        } else {
            Text("Only supported on iOS 16+")
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
