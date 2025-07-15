//
//  MainTabbar.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
import SwiftUI

struct MainTabView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.cashaBackground)
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }

    var body: some View {
        TabView {
            
            // MARK: - Home
            if #available(iOS 16.0, *) {
                NavigationStack {
                    DashboardView()
                }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            } else {
                // Fallback on earlier versions
            }

            // MARK: - Transactions
            if #available(iOS 16.0, *) {
                NavigationStack {
                    TransactionListView()
                }
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet.rectangle")
                }
            } else {
                // Fallback on earlier versions
            }

            // MARK: - Profile
            if #available(iOS 16.0, *) {
                NavigationStack {
                    ProfileView()
                }
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
            } else {
                // Fallback on earlier versions
            }
        }
        .accentColor(.cashaPrimary) // active tab icon/text color
        .background(Color.cashaBackground)
    }
}

#Preview {
    MainTabView()
}



