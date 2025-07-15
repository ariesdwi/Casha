//
//  TransactionSection.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//
import Foundation


public struct TransactionDateSection: Identifiable {
    public let id = UUID()
    public let date: String
    public let day: String
    public let totalAmount: Double
    public let items: [TransactionCasha]

    public init(date: String, day: String, totalAmount: Double, items: [TransactionCasha]) {
        self.date = date
        self.day = day
        self.totalAmount = totalAmount
        self.items = items
    }

    public static let sampleData: [TransactionDateSection] = [
        TransactionDateSection(date: "10", day: "Today", totalAmount: 30000, items: [
            .init(id: UUID(), name: "Bakso", category: "Food & Beverage", amount: 15000, date: Date()),
            .init(id: UUID(), name: "Mie Ayam", category: "Food & Beverage", amount: 15000, date: Date()),
        ]),
        
        TransactionDateSection(date: "11", day: "Today", totalAmount: 30000, items: [
            .init(id: UUID(), name: "Bakso", category: "Food & Beverage", amount: 15000, date: Date()),
            .init(id: UUID(), name: "Mie Ayam", category: "Food & Beverage", amount: 15000, date: Date()),
        ]),
        
        TransactionDateSection(date: "12", day: "Today", totalAmount: 30000, items: [
            .init(id: UUID(), name: "Bakso", category: "Food & Beverage", amount: 15000, date: Date()),
            .init(id: UUID(), name: "Mie Ayam", category: "Food & Beverage", amount: 15000, date: Date()),
        ])
    ]
}

