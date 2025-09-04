//
//  SpendingReport.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import Foundation
import SwiftUI

public struct SpendingBar: Identifiable, Equatable {
    public let id = UUID()
    public let label: String
    public let amount: Double

    public init(label: String, amount: Double) {
        self.label = label
        self.amount = amount
    }
}

public struct SpendingReport: Equatable {
    public let thisWeekTotal: Double
    public let thisMonthTotal: Double
    public let dailyBars: [SpendingBar]
    public let weeklyBars: [SpendingBar]

    public init(
        thisWeekTotal: Double,
        thisMonthTotal: Double,
        dailyBars: [SpendingBar],
        weeklyBars: [SpendingBar]
    ) {
        self.thisWeekTotal = thisWeekTotal
        self.thisMonthTotal = thisMonthTotal
        self.dailyBars = dailyBars
        self.weeklyBars = weeklyBars
    }
}


