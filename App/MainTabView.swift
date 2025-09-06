////
////  MainTabbar.swift
////  Casha
////
////  Created by PT Siaga Abdi Utama on 14/07/25.
//

import SwiftUI
import Domain

struct MainTabView: View {
    @State private var selectedTab = 2 // 👈 Set default tab index (0 = first tab)

    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.cashaBackground)
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            
            
            
            // MARK: - Report
            if #available(iOS 16.0, *) {
                NavigationStack {
                    ReportView()
                }
                .tabItem {
                    Label("Report", systemImage: "chart.pie.fill")
                }
                .tag(1)
            }
            
            // MARK: - Budget
            if #available(iOS 16.0, *) {
                NavigationStack {
                    BudgetView()
                }
                .tabItem {
                    Label("Budget", systemImage: "creditcard")
                }
                .tag(3)
            }
            
            // MARK: - Home
            if #available(iOS 16.0, *) {
                NavigationStack {
                    DashboardView()
                }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(2) // 👈 Default tab (set in @State)
            }
            
            // MARK: - Transactions
            if #available(iOS 16.0, *) {
                NavigationStack {
                    TransactionListView()
                }
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet.rectangle")
                }
                .tag(0) // 👈 Give each tab a tag
            }
            
            // MARK: - Profile
            if #available(iOS 16.0, *) {
                NavigationStack {
                    ProfileView()
                }
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tag(4)
            }
        }
        .accentColor(.cashaPrimary)
        .background(Color.cashaBackground)
    }
}
