
import SwiftUI
import Domain

struct MainTabView: View {
    @State private var selectedTab = 1
    @State private var showAddTransaction = false
    @EnvironmentObject private var dashboardState: DashboardState

    var body: some View {
        TabView(selection: $selectedTab) {
            if #available(iOS 16.0, *) {
                NavigationStack { ReportView() }.tag(0)
            }

            if #available(iOS 16.0, *) {
                NavigationStack { DashboardView() }
                    .tag(1)
            }

            if #available(iOS 16.0, *) {
                NavigationStack { TransactionListView() }.tag(2)
            }

            if #available(iOS 16.0, *) {
                NavigationStack { BudgetView() }.tag(3)
            }

            if #available(iOS 16.0, *) {
                NavigationStack { ProfileView() }.tag(4)
            }
        }
        .accentColor(.cashaPrimary)
        .customTabBar(
            selectedTab: $selectedTab,
            tabs: [
                TabItem(title: "Report", icon: "chart.pie", tag: 0, isCenterButton: false),
                TabItem(title: "Home", icon: "house.fill", tag: 1, isCenterButton: false),
                TabItem(title: "Add", icon: "plus", tag: 5, isCenterButton: true) {
                    showAddTransaction = true
                },
                TabItem(title: "Transactions", icon: "list.bullet.rectangle", tag: 2, isCenterButton: false),
                TabItem(title: "Budget", icon: "creditcard", tag: 3, isCenterButton: false)
            ]
        )
        // ✅ AddTransactionCoordinator handles all the add flow
        .overlay {
            AddTransactionCoordinator(isPresented: $showAddTransaction)
                .environmentObject(dashboardState)
        }
    }
}

