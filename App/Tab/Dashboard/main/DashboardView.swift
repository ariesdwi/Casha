//import SwiftUI
//import Core
//import Domain
//
//struct DashboardView: View {
//    // MARK: - State
//    @State private var selectedTab: Tab = .week
//    @State private var showAddTransaction = false
//    @State private var showAddManual = false
//    @State private var showAddChat = false
//    @State private var showImagePicker = false
//    @State private var selectedImage: UIImage? = nil
//    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
//    @State private var showSourceDialog = false
//    @State private var showSyncConfirmation = false
//    @State private var showSnackbar = false
//    @State private var snackbarMessage = ""
//
//    // MARK: - Environment
//    @EnvironmentObject private var dashboardState: DashboardState
//    @Environment(\.scenePhase) private var scenePhase
//    
//    // MARK: - Types
//    enum Tab: String, CaseIterable {
//        case week, month
//    }
//    
//    // MARK: - Body
//    var body: some View {
//        ZStack {
//            mainContent
//            overlays
//        }
//        .navigationTitle("Home")
//        .navigationBarTitleDisplayMode(.large)
//        .toolbar{navigationToolbar}
//        .task { await dashboardState.loadData() }
//        .onChange(of: scenePhase, perform: handleScenePhaseChange)
//        .onChange(of: dashboardState.errorMessage, perform: handleErrorMessage)
//        .background(confirmationDialogs)
//        .background(fullScreenCovers)
//        .sheet(isPresented: $showAddManual) { addTransactionView }
//
//    }
//}
//
//// MARK: - Main Content
//private extension DashboardView {
//    var mainContent: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                cardBalanceSection
//                syncStatusBanner
//                reportSectionTitle
//                chartView
//                recentTransactionsSection
//                Spacer(minLength: 40)
//            }
//            .padding()
//        }
//        .background(Color.clear)
//    }
//}
//
//// MARK: - Sections
//private extension DashboardView {
//    var cardBalanceSection: some View {
//        CardBalanceView(balance: CurrencyFormatter.format(dashboardState.totalSpending))
//    }
//    
//    var syncStatusBanner: some View {
//        Group {
//            if dashboardState.unsyncedCount > 0 {
//                SyncStatusBanner(
//                    unsyncedCount: dashboardState.unsyncedCount,
//                    onSyncNow: { showSyncConfirmation = true }
//                )
//                .padding(.horizontal, -16)
//            }
//        }
//    }
//
//    
//    var reportSectionTitle: some View {
//        HStack {
//            Text("Report This Month")
//                .font(.headline)
//            Spacer()
//        }
//    }
//    
//    var chartView: some View {
//        ReportChartView(
//            selectedTab: $selectedTab,
//            weekTotal: CurrencyFormatter.format(dashboardState.report.thisWeekTotal),
//            monthTotal: CurrencyFormatter.format(dashboardState.report.thisMonthTotal),
//            weekData: dashboardState.report.dailyBars,
//            monthData: dashboardState.report.weeklyBars
//        )
//    }
//    
//    var recentTransactionsSection: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Text("Recent Transaction")
//                    .font(.headline)
//                Spacer()
//            }
//            if dashboardState.recentTransactions.isEmpty {
//                EmptyStateView(message: "Transactions")
//            } else {
//                RecentTransactionList(transactions: dashboardState.recentTransactions)
//            }
//        }
//        .padding(.top)
//    }
//}
//
//// MARK: - Overlays
//private extension DashboardView {
//    var overlays: some View {
//        ZStack {
//            if showSnackbar { snackbarOverlay }
//            if dashboardState.isLoading || dashboardState.isSending || dashboardState.isSyncing {
//                loadingOverlay
//            }
//        }
//    }
//    
//    var snackbarOverlay: some View {
//        VStack {
//            Spacer()
//            SnackbarView(message: snackbarMessage, isError: true)
//        }
//        .transition(.move(edge: .bottom).combined(with: .opacity))
//        .animation(.easeInOut, value: showSnackbar)
//    }
//    
//    var loadingOverlay: some View {
//        ZStack {
//            Color.black.opacity(0.3).ignoresSafeArea()
//            VStack(spacing: 12) {
//                ProgressView()
//                    .progressViewStyle(.circular)
//                    .scaleEffect(1.2)
//                loadingStatusText
//            }
//            .font(.subheadline)
//            .foregroundColor(.secondary)
//            .padding(20)
//            .background(.thinMaterial)
//            .cornerRadius(12)
//        }
//        .transition(.opacity)
//        .animation(.easeInOut, value: dashboardState.isLoading || dashboardState.isSending || dashboardState.isSyncing)
//    }
//    
//    var loadingStatusText: some View {
//        if dashboardState.isSending {
//            Text("Sending transaction...")
//        } else if dashboardState.isSyncing {
//            Text("Syncing \(dashboardState.unsyncedCount) transactions...")
//        } else {
//            Text("Loading...")
//        }
//    }
//}
//
//// MARK: - Toolbar
//private extension DashboardView {
//    var navigationToolbar: some ToolbarContent {
//        ToolbarItemGroup(placement: .navigationBarTrailing) {
//            Button { showSourceDialog = true } label: {
//                Image(systemName: "camera")
//            }
//            Button {
//                withAnimation { showAddTransaction = true }
//            } label: {
//                Image(systemName: "plus")
//            }
//        }
//    }
//}
//
//// MARK: - Confirmation Dialogs
//private extension DashboardView {
//    var confirmationDialogs: some View {
//        Group {
//            EmptyView() // placeholder, we attach dialogs here
//        }
//        .confirmationDialog("Choose Image Source", isPresented: $showSourceDialog) {
//            Button("Camera") {
//                imageSource = .camera
//                showImagePicker = true
//            }
//            Button("Photo Library") {
//                imageSource = .photoLibrary
//                showImagePicker = true
//            }
//            Button("Cancel", role: .cancel) {}
//        }
//        .confirmationDialog("Add Transaction", isPresented: $showAddTransaction) {
//            Button("Manual Entry") { showAddManual = true }
//            Button("Chat AI") { showAddChat = true }
//            Button("Cancel", role: .cancel) {}
//        }
//        .confirmationDialog("Sync Transactions", isPresented: $showSyncConfirmation) {
//            Button("Sync Now") {
//                Task { await dashboardState.manualSync() }
//            }
//            Button("Cancel", role: .cancel) {}
//        } message: {
//            Text("You have \(dashboardState.unsyncedCount) unsynced transaction(s). Sync them to the cloud now?")
//        }
//    }
//}
//
//// MARK: - Full Screen Covers
//private extension DashboardView {
//    var fullScreenCovers: some View {
//        Group {
//            EmptyView() // anchor for fullScreenCover modifiers
//        }
//        .fullScreenCover(isPresented: $showImagePicker) {
//            ImagePicker(sourceType: imageSource) { image in
//                Task {
//                    if let url = image.saveToTemporaryDirectory() {
//                        dashboardState.selectedImageURL = url
//                        await dashboardState.sendTransactionFromImage()
//                    }
//                }
//            }
//        }
//        .fullScreenCover(isPresented: $showAddChat) {
//            ZStack {
//                VisualEffectBlur(blurStyle: .systemThinMaterialDark).ignoresSafeArea()
//                VStack {
//                    Spacer()
//                    MessageFormCard {
//                        showAddManual = false
//                        showAddChat = false
//                    }
//                    Spacer()
//                }
//            }
//        }
//    }
//}
//
//
//// MARK: - Sheets
//private extension DashboardView {
//    var addTransactionView: some View {
//        AddTransactionView { newTransaction in
//            Task { await dashboardState.addTransactionManually(newTransaction) }
//        }
//    }
//}
//
//// MARK: - Event Handlers
//private extension DashboardView {
//    func handleScenePhaseChange(_ newPhase: ScenePhase) {
//        guard newPhase == .active else { return }
//        Task { await dashboardState.syncTransactionList() }
//    }
//    
//    func handleErrorMessage(_ newValue: String?) {
//        guard let error = newValue else { return }
//        showSnackbarMessage(error)
//        dashboardState.errorMessage = nil
//    }
//    
//    func showSnackbarMessage(_ message: String) {
//        snackbarMessage = message
//        withAnimation { showSnackbar = true }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            withAnimation { showSnackbar = false }
//        }
//    }
//}



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
    
    // MARK: - Body
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        cardBalanceSection
                        syncStatusBanner
                        reportSection
                        recentTransactionsSection
                        Spacer(minLength: 40)
                    }
                    .padding()
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.large)
                .toolbar { navigationToolbar }
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
            Button { showSourceDialog = true } label: {
                Image(systemName: "camera")
            }
            Button { withAnimation { showAddTransaction = true } } label: {
                Image(systemName: "plus")
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
