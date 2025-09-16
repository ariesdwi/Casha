//////
////
import SwiftUI
import Domain
import Data
import Core

@main
struct CashaApp: App {
    private let container = DependencyContainer.shared
    @StateObject private var loginState: LoginState
    @StateObject private var registerState: RegisterState
    @StateObject private var dashboardState: DashboardState
    @StateObject private var transactionListState: TransactionListState
    @StateObject private var reportState: ReportState
    @StateObject private var budgetState: BudgetState
    @StateObject private var profilState: ProfileState

    init() {
        let state = container.makeLoginState()
        let stateRegister = container.makeRegisterState()
        let dashboardState = container.makeDashboardState()
        let transactionListState = container.makeTransactionListState()
        let reportState = container.makeReportState()
        let budgetState = container.makeBudgetState()
        let profilState = container.makeProfileState()

        _loginState = StateObject(wrappedValue: state)
        _registerState = StateObject(wrappedValue: stateRegister)
        _dashboardState = StateObject(wrappedValue: dashboardState)
        _transactionListState = StateObject(wrappedValue: transactionListState)
        _reportState = StateObject(wrappedValue: reportState)
        _budgetState = StateObject(wrappedValue: budgetState)
        _profilState = StateObject(wrappedValue: profilState)


        setupApp()
    }

    var body: some Scene {
        WindowGroup {
            if loginState.isLoggedIn {
                MainTabView()
                    .environmentObject(loginState)
                    .environmentObject(dashboardState)
                    .environmentObject(transactionListState)
                    .environmentObject(reportState)
                    .environmentObject(budgetState)
                    .environmentObject(profilState)
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



