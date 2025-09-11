//import SwiftUI
//import Core
//import Domain
//

import SwiftUI
import Core
import Domain

struct DashboardView: View {
    // MARK: - State
    @State private var selectedTab: Tab = .week
    @State private var showAddTransaction = false
    @State private var showAddManual = false
    @State private var showAddChat = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceDialog = false
    @State private var showSyncConfirmation = false

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
                        // syncStatusBanner
                        reportSection
                        recentTransactionsSection
                        Spacer(minLength: 40)
                    }
                    .padding()
                }
                .navigationTitle(dashboardState.isOnline ? "Home" : "")
                .navigationBarTitleDisplayMode(dashboardState.isOnline ? .large : .inline)
                .toolbar {
                    // Combine both toolbar configurations
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
                .task { await dashboardState.refreshDashboard() }
                .onChange(of: scenePhase, perform: handleScenePhaseChange)
                .background(confirmationDialogs)
                .background(fullScreenCovers)
                .sheet(isPresented: $showAddManual) { addTransactionView }
            }
        } else {
            // Fallback on earlier versions
        }
    }

}

// MARK: - Sections
private extension DashboardView {
    var cardBalanceSection: some View {
        CardBalanceView(balance: CurrencyFormatter.format(dashboardState.totalSpending))
    }
    
    var syncStatusBanner: some View {
        Group {
            if dashboardState.unsyncedCount > 0 {
                SyncStatusBanner(
                    unsyncedCount: dashboardState.unsyncedCount,
                    onSyncNow: { showSyncConfirmation = true }
                )
            }
        }
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
                EmptyStateView(message: "No recent transactions")
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
                Button { showSourceDialog = true } label: {
                    Image(systemName: "camera")
                }
                Button { withAnimation { showAddTransaction = true } } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }

}

// MARK: - Confirmation Dialogs
private extension DashboardView {
    var confirmationDialogs: some View {
        Group {
            EmptyView()
        }
        .confirmationDialog("Choose Image Source", isPresented: $showSourceDialog) {
            Button("Camera") {
                imageSource = .camera
                showImagePicker = true
            }
            Button("Photo Library") {
                imageSource = .photoLibrary
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .confirmationDialog("Add Transaction", isPresented: $showAddTransaction) {
            Button("Manual Entry") { showAddManual = true }
            Button("Chat AI") { showAddChat = true }
            Button("Cancel", role: .cancel) {}
        }
        .confirmationDialog("Sync Transactions", isPresented: $showSyncConfirmation) {
            Button("Sync Now") {
                Task { await dashboardState.sendTransaction() } // reuse sendTransaction()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You have \(dashboardState.unsyncedCount) unsynced transaction(s). Sync them to the cloud now?")
        }
    }
}

// MARK: - Full Screen Covers
private extension DashboardView {
    var fullScreenCovers: some View {
        Group {
            EmptyView()
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(sourceType: imageSource) { image in
                Task {
                    if let url = image.saveToTemporaryDirectory() {
                        dashboardState.selectedImageURL = url
                        await dashboardState.sendTransaction()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showAddChat) {
            ZStack {
                VisualEffectBlur(blurStyle: .systemThinMaterialDark).ignoresSafeArea()
                VStack {
                    Spacer()
                    MessageFormCard {
                        showAddManual = false
                        showAddChat = false
                    }
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Sheets
private extension DashboardView {
    var addTransactionView: some View {
        AddTransactionView { newTransaction in
            Task {
                await dashboardState.addTransactionManually(newTransaction)
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
