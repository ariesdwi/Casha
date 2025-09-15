//
//  ReportState.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//

import Foundation
import Domain

public final class ReportState: ObservableObject {
    private let getCategorySpendingUseCase: GetCategorySpendingUseCase
    private let getTransactionbyCategoryUseCase: GetTransactionbyCategoryUseCase

    @Published public private(set) var categorySpendings: [ChartCategorySpending] = []
    @Published public private(set) var transactionsByCategory: [TransactionCasha] = []
    @Published public var selectedPeriod: ReportFilterPeriod = .month

    public init(
        getCategorySpendingUseCase: GetCategorySpendingUseCase,
        getTransactionbyCategoryUseCase: GetTransactionbyCategoryUseCase
    ) {
        self.getCategorySpendingUseCase = getCategorySpendingUseCase
        self.getTransactionbyCategoryUseCase = getTransactionbyCategoryUseCase
    }

    // MARK: - Load Category Spending
    public func loadCategorySpending() async {
        let (startDate, endDate) = makeDateRange()

        let spendings = await getCategorySpendingUseCase.execute(startDate: startDate, endDate: endDate)
        self.categorySpendings = spendings
    }

    // MARK: - Load Transactions for a Category
    public func loadTransactionsByCategory(category: String) async {
        let (startDate, endDate) = makeDateRange()

        let transactions = await getTransactionbyCategoryUseCase.execute(
            category: category,
            startDate: startDate,
            endDate: endDate
        )
        self.transactionsByCategory = transactions
    }

    // MARK: - Update Filter
    public func setFilter(_ period: ReportFilterPeriod) async {
        selectedPeriod = period
        await loadCategorySpending()
    }

    // MARK: - Helper
    private func makeDateRange() -> (Date, Date) {
        let now = Date()
        let calendar = Calendar.current
        let startDate: Date

        switch selectedPeriod {
        case .week:
            startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) ?? now
        case .month:
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
        case .year:
            startDate = calendar.date(from: calendar.dateComponents([.year], from: now)) ?? now
        }

        return (startDate, now)
    }
}

