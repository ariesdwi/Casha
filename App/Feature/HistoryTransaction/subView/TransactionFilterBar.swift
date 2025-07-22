//
//  tr.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//

import SwiftUI

struct TransactionFilterBar: View {
    @Binding var selected: String
    @State private var monthOptions: [String] = []
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(monthOptions, id: \.self) { option in
                    Button(action: {
                        selected = option
                    }) {
                        Text(option)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 14)
                            .background(selected == option ? Color.cashaPrimary : Color(.systemGray5))
                            .foregroundColor(selected == option ? .white : .black)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
        }
        .onAppear {
            monthOptions = generateMonthOptions(currentDate: Date())
            selected = "This month" // Default selection
        }
    }
    
    private func generateMonthOptions(currentDate: Date) -> [String] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy" // e.g. "Jul 2025"
        
        var options: [String] = []
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        
        // 1. Add special options
        options.append(contentsOf: ["Future", "This month", "Last month"])
        
        // 2. Add months from current year
        for month in (1...currentMonth).reversed() {
            if let date = calendar.date(from: DateComponents(year: currentYear, month: month)) {
                options.append(dateFormatter.string(from: date))
            }
        }
        
        // 3. Add months from last year
        for month in (1...12).reversed() {
            if let date = calendar.date(from: DateComponents(year: currentYear - 1, month: month)) {
                options.append(dateFormatter.string(from: date))
            }
        }
        
        return options
    }
}
