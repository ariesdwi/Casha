//
//  DateHelper.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//

import Foundation

public struct DateHelper {
    public static func format(_ date: Date, format: String = "dd MMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    public static func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        Calendar.current.isDate(d1, inSameDayAs: d2)
    }
}
