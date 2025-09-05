import SwiftUI
import Core
import Domain

struct DashboardView: View {
    @State private var selectedTab: Tab = .week
    @State private var showAddTransaction = false
    @State private var showAddManual = false
    @State private var showAddChat = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceDialog = false
    @State private var showSyncConfirmation = false
    
    // Snackbar states
    @State private var showSnackbar = false
    @State private var snackbarMessage = ""
    
    @EnvironmentObject var dashboardState: DashboardState
    @Environment(\.scenePhase) private var scenePhase

    enum Tab { case week, month }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // MARK: Card Balance
                    CardBalanceView(balance: CurrencyFormatter.format(dashboardState.totalSpending))
                    
                    // MARK: Sync Status Banner
                    if dashboardState.unsyncedCount > 0 {
                        SyncStatusBanner(
                            unsyncedCount: dashboardState.unsyncedCount,
                            onSyncNow: {
                                showSyncConfirmation = true
                            }
                        )
                        .padding(.horizontal, -16) // Full width
                    }
                    
                    // MARK: Report Section Title
                    HStack {
                        Text("Report This Month")
                            .font(.headline)
                        Spacer()
                    }
                    
                    // MARK: Modular Chart View
                    ReportChartView(
                        selectedTab: $selectedTab,
                        weekTotal: CurrencyFormatter.format(dashboardState.report.thisWeekTotal),
                        monthTotal: CurrencyFormatter.format(dashboardState.report.thisMonthTotal),
                        weekData: dashboardState.report.dailyBars,
                        monthData: dashboardState.report.weeklyBars
                    )
                    
                    // MARK: Recent Transactions
                    HStack {
                        Text("Recent Transaction")
                            .font(.headline)
                        
                        Spacer()
                        
                        // Sync button in header
//                        if dashboardState.unsyncedCount > 0 {
//                            Button {
//                                showSyncConfirmation = true
//                            } label: {
//                                SyncBadgeView(count: dashboardState.unsyncedCount)
//                            }
//                        }
                    }
                    .padding(.top)
                    
                    if dashboardState.recentTransactions.isEmpty {
                        EmptyStateView(message: "Transactions")
                    } else {
                        RecentTransactionList(transactions: dashboardState.recentTransactions)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color.cashaBackground)
            .navigationTitle("Home")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Sync button in toolbar
//                    if dashboardState.unsyncedCount > 0 {
//                        Button {
//                            showSyncConfirmation = true
//                        } label: {
//                            SyncBadgeView(count: dashboardState.unsyncedCount)
//                        }
//                    }
                    
                    Button {
                        showSourceDialog = true
                    } label: {
                        Image(systemName: "camera")
                    }
                    
                    Button {
                        withAnimation {
                            showAddTransaction = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                await dashboardState.loadData()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    Task {
                        await dashboardState.syncTransactionList()
                    }
                }
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
                Button("Manual Entry") {
                    showAddManual = true
                }
                
                Button("Chat AI") {
                    showAddChat = true
                }
                
                Button("Cancel", role: .cancel) {}
            }
            .confirmationDialog("Sync Transactions", isPresented: $showSyncConfirmation) {
                Button("Sync Now") {
                    Task {
                        await dashboardState.manualSync()
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("You have \(dashboardState.unsyncedCount) unsynced transaction(s). Sync them to the cloud now?")
            }
            .fullScreenCover(isPresented: $showImagePicker) {
                ImagePicker(sourceType: imageSource) { image in
                    Task {
                        if let url = image.saveToTemporaryDirectory() {
                            dashboardState.selectedImageURL = url
                            await dashboardState.sendTransactionFromImage()
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showAddChat) {
                ZStack {
                    VisualEffectBlur(blurStyle: .systemThinMaterialDark)
                        .ignoresSafeArea()
                    
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
            .sheet(isPresented: $showAddManual) {
                AddTransactionView { newTransaction in
                    Task {
                        await dashboardState.addTransactionManually(newTransaction)
                    }
                }
            }
            
            // MARK: Global Loading Overlay
            if dashboardState.isLoading || dashboardState.isSending || dashboardState.isSyncing {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.2)
                        
                        if dashboardState.isSending {
                            Text("Sending transaction...")
                        } else if dashboardState.isSyncing {
                            Text("Syncing \(dashboardState.unsyncedCount) transactions...")
                        } else {
                            Text("Loading...")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(20)
                    .background(.thinMaterial)
                    .cornerRadius(12)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: dashboardState.isLoading || dashboardState.isSending || dashboardState.isSyncing)
            }
            
            // MARK: Snackbar Overlay
            if showSnackbar {
                VStack {
                    Spacer()
                    SnackbarView(message: snackbarMessage, isError: true)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut, value: showSnackbar)
            }
            
            // Floating Sync Button
//            if dashboardState.unsyncedCount > 0 {
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        Button {
//                            showSyncConfirmation = true
//                        } label: {
//                            SyncFloatingButton(count: dashboardState.unsyncedCount)
//                        }
//                        .padding()
//                    }
//                }
//            }
        }
        .onChange(of: dashboardState.errorMessage) { newValue in
            if let error = newValue {
                showSnackbarMessage(error)
                dashboardState.errorMessage = nil
            }
        }
    }
    
    private func showSnackbarMessage(_ message: String) {
        snackbarMessage = message
        withAnimation {
            showSnackbar = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showSnackbar = false
            }
        }
    }
}

// MARK: - Sync UI Components

struct SyncStatusBanner: View {
    let unsyncedCount: Int
    let onSyncNow: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            
            Text("\(unsyncedCount) transaction(s) waiting to sync")
                .font(.subheadline)
            
            Spacer()
            
            Button("Sync Now", action: onSyncNow)
                .font(.subheadline.bold())
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
}

struct SyncBadgeView: View {
    let count: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.system(size: 20))
                .foregroundColor(.blue)
            
            if count > 0 {
                Text("\(count)")
                    .font(.system(size: 11, weight: .bold))
                    .padding(4)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .offset(x: 8, y: -8)
            }
        }
    }
}

struct SyncFloatingButton: View {
    let count: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 56, height: 56)
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            
            ZStack {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 12, weight: .bold))
                        .padding(4)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .offset(x: 12, y: -12)
                }
            }
        }
    }
}
