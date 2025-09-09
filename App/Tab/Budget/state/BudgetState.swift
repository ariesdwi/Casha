////
////  BudgetState.swift
////  Casha
////
////  Created by PT Siaga Abdi Utama on 03/09/25.
////
//

//import Foundation
//import Domain
//
//@MainActor
//public final class BudgetState: ObservableObject {
//    @Published public var budgets: [BudgetCasha] = []
//    @Published var budgetSummary: BudgetSummary?
//
//    @Published public var isLoading: Bool = false
//    @Published public var errorMessage: String?
//    
//    private let getAllBudgetUseCase: GetBudgetsUseCase
//    private let addBudgetUseCase: AddBudgetUseCase
//    private let getTotalSummaryBudget: GetBudgetSummaryUseCase
//    
//    
//    public init (
//        fetchUseCase: GetBudgetsUseCase,
//        addBudgetUseCase: AddBudgetUseCase,
//        getTotalSummaryBudget: GetBudgetSummaryUseCase
//        
//    ) {
//        self.getAllBudgetUseCase = fetchUseCase
//        self.addBudgetUseCase = addBudgetUseCase
//        self.getTotalSummaryBudget = getTotalSummaryBudget
//    }
//    
//    public func fetchBudgets() async {
//        isLoading = true
//        errorMessage = nil
//        do {
//            let result = try await getAllBudgetUseCase.execute()
//            budgets = result
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//        isLoading = false
//    }
//    
//    public func addBudget(request: NewBudgetRequest) async {
//         isLoading = true
//         errorMessage = nil
//         do {
//             let newBudget = try await addBudgetUseCase.execute(request: request)
//             budgets.append(newBudget)
//         } catch {
//             errorMessage = error.localizedDescription
//         }
//         isLoading = false
//     }
//    
//    public func fetchSummaryBudgets() async {
//        isLoading = true
//        errorMessage = nil
//        do {
//            let result = try await getTotalSummaryBudget.execute()
//            budgetSummary = result
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//        isLoading = false
//    }
//}


//
//  BudgetState.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 03/09/25.
//

import Foundation
import Domain

@MainActor
public final class BudgetState: ObservableObject {
    @Published public var budgets: [BudgetCasha] = []
    @Published public var budgetSummary: BudgetSummary?

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private let getAllBudgetUseCase: GetBudgetsUseCase
    private let addBudgetUseCase: AddBudgetUseCase
    private let getTotalSummaryBudget: GetBudgetSummaryUseCase
    
    public init(
        fetchUseCase: GetBudgetsUseCase,
        addBudgetUseCase: AddBudgetUseCase,
        getTotalSummaryBudget: GetBudgetSummaryUseCase
    ) {
        self.getAllBudgetUseCase = fetchUseCase
        self.addBudgetUseCase = addBudgetUseCase
        self.getTotalSummaryBudget = getTotalSummaryBudget
    }
    
    // MARK: - Fetch Budgets (with optional monthYear filter)
    public func fetchBudgets(monthYear: String? = nil) async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await getAllBudgetUseCase.execute(monthYear: monthYear)
            budgets = result
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // MARK: - Add Budget
    public func addBudget(request: NewBudgetRequest) async {
        isLoading = true
        errorMessage = nil
        do {
            let newBudget = try await addBudgetUseCase.execute(request: request)
            budgets.append(newBudget)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // MARK: - Fetch Summary (with optional monthYear filter)
    public func fetchSummaryBudgets(monthYear: String? = nil) async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await getTotalSummaryBudget.execute(monthYear: monthYear)
            budgetSummary = result
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}




