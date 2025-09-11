//
//  BudgetState.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 03/09/25.
//

import Foundation
import Domain
import Core

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
    
    
    public func refreshBudgetData(monthYear: String? = nil ) async {
        isLoading = true
        errorMessage = nil
        do {
            async let budgetTask = getAllBudgetUseCase.execute(monthYear: monthYear)
            async let summaryTask = getTotalSummaryBudget.execute(monthYear: monthYear)
            
            let (budgetsResult, summaryResult) = await (try budgetTask, try summaryTask)
                    // Update state
                   self.budgets = budgetsResult
                   self.budgetSummary = summaryResult
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
        } catch let error as NetworkError {
            // Handle your custom NetworkError
            switch error {
            case .serverError(let message):
                errorMessage = message
            default:
                errorMessage = error.localizedDescription
            }
        } catch {
            // Handle any other error
            errorMessage = error.localizedDescription
            
        }
        
        isLoading = false
    }
}




