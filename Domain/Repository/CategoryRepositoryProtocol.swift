//
//  CategoryRepositoryProtocol.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//

import Foundation

public protocol CategoryRepositoryProtocol {
    func fetchCategorySpending(startDate: Date, endDate: Date) -> [ChartCategorySpending]
}
