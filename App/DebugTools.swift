//
//  DebugTools.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//


import Foundation
import Data
import UIKit

#if DEBUG
struct DebugTools {
    static func addDummyTransactions(count: Int = 100) {
        let persistence = TransactionPersistence()
        persistence.addDummyTransactions(count: count)
        print("✅ Added \(count) dummy transactions for debugging")
    }
    
    static func clearAllData() {
        let persistence = TransactionPersistence()
        // Implement clear method if available, or handle persistence reset
        print("🧹 All data cleared (if implemented)")
    }
    
    static func printEnvironmentInfo() {
        print("""
        🌍 Environment: \(AppConfig.environment.name)
        📱 Device UUID: \(UIDevice.current.identifierForVendor?.uuidString ?? "unknown")
        🔗 Base URL: \(AppConfig.baseURL)
        """)
    }
}
#endif
