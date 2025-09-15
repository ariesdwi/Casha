import Foundation
import Domain
import Core

@MainActor
public final class BudgetState: ObservableObject {
    @Published public var budgets: [BudgetCasha] = []
    @Published public var budgetSummary: BudgetSummary?
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public private(set) var currentMonthYear: String?

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
    
    // MARK: - Refresh Data
    public func refreshBudgetData() async {
        isLoading = true
        errorMessage = nil
        
        // 👇 Use last selected month, or default to current
        if currentMonthYear == nil {
            let current = DateHelper.generateMonthYearOptions().first ?? ""
            currentMonthYear = current
        }
        
        guard let monthYear = currentMonthYear else { return }
        
        do {
            async let budgetTask = getAllBudgetUseCase.execute(monthYear: monthYear)
            async let summaryTask = getTotalSummaryBudget.execute(monthYear: monthYear)
            
            let (budgetsResult, summaryResult) = try await (budgetTask, summaryTask)
            self.budgets = budgetsResult
            self.budgetSummary = summaryResult
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Change Month
    public func setMonth(_ monthYear: String) async {
        self.currentMonthYear = monthYear
        await refreshBudgetData()
    }
    
    // MARK: - Add Budget
    public func addBudget(request: NewBudgetRequest) async {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await addBudgetUseCase.execute(request: request)
            // 👇 After saving, refresh the list and summary
            await refreshBudgetData()
        } catch let error as NetworkError {
            switch error {
            case .serverError(let message):
                errorMessage = message
            default:
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
