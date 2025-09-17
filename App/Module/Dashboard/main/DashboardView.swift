import SwiftUI
import Core
import Domain

struct DashboardView: View {
    // MARK: - State
    @State private var selectedTab: Tab = .week
    @State private var showAddTransaction = false
    
    // MARK: - Environment
    @EnvironmentObject private var dashboardState: DashboardState
    @Environment(\.scenePhase) private var scenePhase
    
    // MARK: - Types
    enum Tab: String, CaseIterable {
        case week, month
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        cardBalanceSection
                        reportSection
                        recentTransactionsSection
                        Spacer(minLength: 40)
                    }
                    .padding()
                }
                .navigationTitle( "Home" )
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    if dashboardState.isOnline {
                        navigationToolbar
                    } else {
                        ToolbarItem(placement: .principal) {
                            HStack(spacing: 8) {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                Text("Waiting for network")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                .onAppear {
                    Task {
                        await dashboardState.refreshDashboard()
                    }
                }
                .onChange(of: scenePhase, perform: handleScenePhaseChange)
                .overlay {
                    AddTransactionCoordinator(isPresented: $showAddTransaction)
                        .environmentObject(dashboardState)
                }
            }
        } else {
            Text("Please upgrade to iOS 16 or later")
        }
    }
}

// MARK: - Sections
private extension DashboardView {
    var cardBalanceSection: some View {
           CardBalanceView(
               balance: CurrencyFormatter.format(dashboardState.totalSpending),
               period: dashboardState.selectedPeriod,
               onPeriodChange: { newPeriod in
                   dashboardState.changePeriod(to: newPeriod)
               }
           )
    }
    
    var reportSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Report This Month")
                    .font(.headline)
                Spacer()
            }
            
            ReportChartView(
                selectedTab: $selectedTab,
                weekTotal: CurrencyFormatter.format(dashboardState.report.thisWeekTotal),
                monthTotal: CurrencyFormatter.format(dashboardState.report.thisMonthTotal),
                weekData: dashboardState.report.dailyBars,
                monthData: dashboardState.report.weeklyBars
            )
        }
    }
    
    var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Recent Transactions")
                    .font(.headline)
                Spacer()
            }
            
            if dashboardState.recentTransactions.isEmpty {
                EmptyStateView(message: "recent transactions")
            } else {
                RecentTransactionList(transactions: dashboardState.recentTransactions)
            }
        }
        .padding(.top)
    }
}

// MARK: - Toolbar
private extension DashboardView {
    var navigationToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            if dashboardState.isSyncing {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 18))
                        .foregroundColor(.cashaPrimary)
                }
            }
        }
    }
}

// MARK: - Event Handlers
private extension DashboardView {
    func handleScenePhaseChange(_ newPhase: ScenePhase) {
        guard newPhase == .active else { return }
        Task { await dashboardState.refreshDashboard() }
    }
}




