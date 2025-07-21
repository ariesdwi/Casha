//
//  SpendingReport.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import Foundation

public struct SpendingReport: Equatable {
    public let thisPeriod: Double
    public let lastPeriod: Double

    public init(thisPeriod: Double, lastPeriod: Double) {
        self.thisPeriod = thisPeriod
        self.lastPeriod = lastPeriod
    }
}
