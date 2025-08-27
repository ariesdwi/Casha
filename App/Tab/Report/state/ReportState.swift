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

    @Published public private(set) var categorySpendings: [ChartCategorySpending] = []
    @Published public var selectedPeriod: ReportFilterPeriod = .month

    public init(getCategorySpendingUseCase: GetCategorySpendingUseCase) {
        self.getCategorySpendingUseCase = getCategorySpendingUseCase
    }

    public func loadCategorySpending() {
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

        let endDate = now
        categorySpendings = getCategorySpendingUseCase.execute(startDate: startDate, endDate: endDate)
    }

    public func setFilter(_ period: ReportFilterPeriod) {
        selectedPeriod = period
        loadCategorySpending()
    }
}
