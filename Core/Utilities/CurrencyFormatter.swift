//
//  Utilities.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//


import Foundation

public struct CurrencyFormatter {
    public static let shared: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID") // Bahasa Indonesia
        formatter.currencySymbol = "Rp "
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    public static func format(_ amount: Double) -> String {
        return shared.string(from: NSNumber(value: amount)) ?? "Rp 0"
    }
    
    /// Format dari String input (misal dari TextField) → Rp 15.000
    public static func format(input: String) -> String {
        // Hilangkan karakter non-digit
        let digitsOnly = input.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Konversi ke Double
        let amount = Double(digitsOnly) ?? 0
        return format(amount)
    }
    
    /// Ambil angka murni dari String → Int atau Double
    public static func extractRawValue(from formatted: String) -> Double {
        let digitsOnly = formatted.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return Double(digitsOnly) ?? 0
    }
}


