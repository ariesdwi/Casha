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
                    Text("Recent Transaction")
                        .font(.headline)
                        .padding(.top)
                    if dashboardState.recentTransactions.isEmpty {
                        EmptyStateView(message: "Trasactions")
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
            .confirmationDialog("Choose Image Source", isPresented: $showAddTransaction) {
                Button("Manual Entry") {
                    showAddManual = true
                }
                
                Button("Chat AI") {
                    showAddChat = true
                }
                
                Button("Cancel", role: .cancel) {}
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
                    print(newTransaction)
                    Task {
                        await dashboardState.addTransactionToLocal(newTransaction)
                    }
                }
            }
            
            // MARK: Global Loading Overlay
            if dashboardState.isSending {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.2)
                        Text("Sending transaction...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(20)
                    .background(.thinMaterial)
                    .cornerRadius(12)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: dashboardState.isSending)
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
        }
        // Instead of .alert → use snackbar
        .onChange(of: dashboardState.errorMessage) { newValue in
            if let error = newValue {
                showSnackbarMessage(error)
                dashboardState.errorMessage = nil // reset
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
