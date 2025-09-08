//

import SwiftUI
import Domain
import Data
import Core

@main
struct CashaApp: App {
    private let container = DependencyContainer.shared
    @StateObject private var loginState: LoginState
    @StateObject private var registerState: RegisterState
    
    init() {
        let state = container.makeLoginState()
        let stateRegister = container.makeRegisterState()
        _loginState = StateObject(wrappedValue: state)
        _registerState = StateObject(wrappedValue: stateRegister)
        setupApp()
    }
    
    var body: some Scene {
        WindowGroup {
            if loginState.isLoggedIn {
                MainTabView()
                    .environmentObject(loginState)
                    .environmentObject(container.makeDashboardState())
                    .environmentObject(container.makeTransactionListState())
                    .environmentObject(container.makeReportState())
                    .environmentObject(container.makeBudgetState())
                    .environmentObject(container.makeProfileState())
            } else {
                SplashView()
                    .environmentObject(loginState)
                    .environmentObject(registerState)
            }
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


