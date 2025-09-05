////
////  BudgetState.swift
////  Casha
////
////  Created by PT Siaga Abdi Utama on 03/09/25.
////
//
import Foundation
import Domain

@MainActor
public final class BudgetState: ObservableObject {
    @Published public var budgets: [BudgetCasha] = []
    @Published var budgetSummary: BudgetSummary?

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private let getAllBudgetUseCase: GetAllBudgetUseCase
    private let addBudgetUseCase: AddBudgetUseCase
    private let getTotalSummaryBudget: GetTotalSummaryBudget
    
    
    public init (
        fetchUseCase: GetAllBudgetUseCase,
        addBudgetUseCase: AddBudgetUseCase,
        getTotalSummaryBudget: GetTotalSummaryBudget
        
    ) {
        self.getAllBudgetUseCase = fetchUseCase
        self.addBudgetUseCase = addBudgetUseCase
        self.getTotalSummaryBudget = getTotalSummaryBudget
    }
    
    public func fetchBudgets() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await getAllBudgetUseCase.execute()
            budgets = result
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
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
    
    public func fetchSummaryBudgets() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await getTotalSummaryBudget.execute()
            budgetSummary = result
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}





