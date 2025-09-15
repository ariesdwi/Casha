//
//  EnvironmentKeys.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import SwiftUI
import Domain
import Data
import Core

// MARK: - Environment Keys
struct DashboardStateKey: EnvironmentKey {
    static let defaultValue: DashboardState = DependencyContainer.shared.makeDashboardState()
}

struct TransactionListStateKey: EnvironmentKey {
    static let defaultValue: TransactionListState = DependencyContainer.shared.makeTransactionListState()
}

struct ReportStateKey: EnvironmentKey {
    static let defaultValue: ReportState = DependencyContainer.shared.makeReportState()
}

struct BudgetStateKey: EnvironmentKey {
    static let defaultValue: BudgetState = DependencyContainer.shared.makeBudgetState()
}

struct ProfileStateKey: EnvironmentKey {
    static let defaultValue: ProfileState = DependencyContainer.shared.makeProfileState()
}

struct LoginStateKey: EnvironmentKey {
    static let defaultValue: LoginState = DependencyContainer.shared.makeLoginState()
}

struct RegisterStateKey: EnvironmentKey {
    static let defaultValue: RegisterState = DependencyContainer.shared.makeRegisterState()
}


// MARK: - Environment Values Extension
extension EnvironmentValues {
    var dashboardState: DashboardState {
        get { self[DashboardStateKey.self] }
        set { self[DashboardStateKey.self] = newValue }
    }
    
    var transactionListState: TransactionListState {
        get { self[TransactionListStateKey.self] }
        set { self[TransactionListStateKey.self] = newValue }
    }
    
    var reportState: ReportState {
        get { self[ReportStateKey.self] }
        set { self[ReportStateKey.self] = newValue }
    }
    
    var budgetState: BudgetState {
        get { self[BudgetStateKey.self] }
        set { self[BudgetStateKey.self] = newValue }
    }
    
    var profileState: ProfileState {
        get { self[ProfileStateKey.self] }
        set { self[ProfileStateKey.self] = newValue }
    }
    var loginState: LoginState {
           get { self[LoginStateKey.self] }
           set { self[LoginStateKey.self] = newValue }
       }
    
    var registerState: RegisterState {
           get { self[RegisterStateKey.self] }
           set { self[RegisterStateKey.self] = newValue }
       }
}
