//
//  ReportPeriod.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 21/07/25.
//

import Foundation

public enum ReportFilterPeriod: String, CaseIterable, Identifiable {
    case week, month, year
    
    public var id: String { rawValue }
    public var title: String {
        switch self {
        case .week: return "This Week"
        case .month: return "This Month"
        case .year: return "This Year"
        }
    }
}
