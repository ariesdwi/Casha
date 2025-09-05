
import SwiftUI
import Domain
import Data
import Core

@main
struct CashaApp: App {
    private let container = DependencyContainer.shared
    
    init() {
        setupApp()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                // Using environment objects (traditional approach)
                .environmentObject(container.makeDashboardState())
                .environmentObject(container.makeTransactionListState())
                .environmentObject(container.makeReportState())
                .environmentObject(container.makeBudgetState())
                .environmentObject(container.makeProfileState())
                
                // Alternative: Using environment values (more SwiftUI-like)
                .environment(\.dashboardState, container.makeDashboardState())
                .environment(\.transactionListState, container.makeTransactionListState())
                .environment(\.reportState, container.makeReportState())
                .environment(\.budgetState, container.makeBudgetState())
                .environment(\.profileState, container.makeProfileState())
        }
    }
    
    private func setupApp() {
        // App-wide configuration
        configureAppearance()
        
        #if DEBUG
        DebugTools.printEnvironmentInfo()
        
        // Uncomment to add dummy data for debugging
        // DebugTools.addDummyTransactions(count: 50)
        #endif
    }
    
    private func configureAppearance() {
        // Global UI configuration
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .clear
        
        // Navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
