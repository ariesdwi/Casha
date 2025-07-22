//
//  DateHelper.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//

import Foundation

public struct DateHelper {
    
    // MARK: - Basic Formatting (your current functionality)
    public static func format(_ date: Date, format: String = "dd MMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    public static func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        Calendar.current.isDate(d1, inSameDayAs: d2)
    }
    
    // MARK: - New Common Formats (thread-safe cached formatters)
    private static let cachedFormatters = NSMapTable<NSString, DateFormatter>(keyOptions: .strongMemory,
                                                                              valueOptions: .weakMemory)
    
    public enum CommonFormat: String {
        case sectionDate = "dd MMM yyyy"  // 22 Jul 2025
        case dayName = "EEEE"             // Monday
        case timeOnly = "HH:mm"           // 14:30
        case monthYear = "MMMM yyyy"      // July 2025
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
}
