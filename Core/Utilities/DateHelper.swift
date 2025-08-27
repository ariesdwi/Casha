//
//  DateHelper.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//

import Foundation

public struct DateHelper {
    
    // MARK: - Basic Formatting
    public static func format(_ date: Date, format: String = "dd MMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    public static func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        Calendar.current.isDate(d1, inSameDayAs: d2)
    }
    
    // MARK: - Common Formats (cached)
    private static let cachedFormatters = NSMapTable<NSString, DateFormatter>(
        keyOptions: .strongMemory,
        valueOptions: .weakMemory
    )
    
    public enum CommonFormat: String {
        case sectionDate = "dd MMM yyyy"
        case dayName = "EEEE"
        case timeOnly = "HH:mm"
        case monthYear = "MMMM yyyy"
        case monthYearShort = "MMM yyyy" // ← added for filters
        case apiDateTime = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
    
    public static func format(_ date: Date, style: CommonFormat) -> String {
        let formatter: DateFormatter
        
        if let cached = cachedFormatters.object(forKey: style.rawValue as NSString) {
            formatter = cached
        } else {
            formatter = DateFormatter()
            formatter.dateFormat = style.rawValue
            cachedFormatters.setObject(formatter, forKey: style.rawValue as NSString)
        }
        
        return formatter.string(from: date)
    }
    
    public static func date(from string: String, style: CommonFormat) -> Date? {
        let formatter: DateFormatter
        
        if let cached = cachedFormatters.object(forKey: style.rawValue as NSString) {
            formatter = cached
        } else {
            formatter = DateFormatter()
            formatter.dateFormat = style.rawValue
            cachedFormatters.setObject(formatter, forKey: style.rawValue as NSString)
        }
        
        return formatter.date(from: string)
    }
    
    // MARK: - Date Comparisons
    public static func isSameMonth(_ d1: Date, _ d2: Date) -> Bool {
        Calendar.current.isDate(d1, equalTo: d2, toGranularity: .month)
    }
    
    public static func isSameYear(_ d1: Date, _ d2: Date) -> Bool {
        Calendar.current.isDate(d1, equalTo: d2, toGranularity: .year)
    }
    
    // MARK: - Date Manipulation
    public static func startOfDay(for date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    public static func addDays(_ days: Int, to date: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: date) ?? date
    }

    public static func generateMonthOptions(currentDate: Date = Date()) -> [String] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        var options: [String] = []
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        
        options.append(contentsOf: ["Future", "This month", "Last month"])
        
        for month in (1...currentMonth).reversed() {
            if let date = calendar.date(from: DateComponents(year: currentYear, month: month)) {
                options.append(dateFormatter.string(from: date))
            }
        }
        
        for month in (1...12).reversed() {
            if let date = calendar.date(from: DateComponents(year: currentYear - 1, month: month)) {
                options.append(dateFormatter.string(from: date))
            }
        }
        
        return options
    }

    // MARK: - Month Boundaries
    public static func startOfMonth(for date: Date) -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date)) ?? date
    }

    public static func endOfMonth(for date: Date) -> Date {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth(for: date)) ?? date
    }

    // MARK: - Period Resolution
    public static func resolveDateRange(for period: String, referenceDate: Date = Date()) -> (Date, Date?) {
        let calendar = Calendar.current
        let now = referenceDate

        switch period {
        case "This month":
            return (startOfMonth(for: now), endOfMonth(for: now))
        case "Last month":
            guard let lastMonth = calendar.date(byAdding: .month, value: -1, to: now) else {
                return (now, nil)
            }
            return (startOfMonth(for: lastMonth), endOfMonth(for: lastMonth))
        case "Future":
            guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: now) else {
                return (now, nil)
            }
            return (startOfMonth(for: nextMonth), nil)
        default:
            if let date = DateHelper.date(from: period, style: .monthYearShort) {
                return (startOfMonth(for: date), endOfMonth(for: date))
            } else {
                return (startOfMonth(for: now), endOfMonth(for: now))
            }
        }
    }
}
