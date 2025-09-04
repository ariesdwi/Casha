//
//  MainTabbar.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.

import SwiftUI
import Domain

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
            } else { }

            // MARK: - Transactions
            if #available(iOS 16.0, *) {
                NavigationStack {
                    TransactionListView()
                }
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet.rectangle")
                }
            } else { }
            
            // MARK: - Report
            if #available(iOS 16.0, *) {
                NavigationStack {
                    ReportView()
                }
                .tabItem {
                    Label("Report", systemImage: "doc.plaintext")
                }
            } else {}
            // MARK: - Profile
            if #available(iOS 16.0, *) {
                NavigationStack {
                    BudgetView()
                }
                .tabItem {
                    Label("Budget", systemImage: "creditcard")
                }
            } else {}
        }
        .accentColor(.cashaPrimary)
        .background(Color.cashaBackground)
    }
}

//#Preview {
//    MainTabView()
//}



