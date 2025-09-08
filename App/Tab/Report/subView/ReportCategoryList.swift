//
//  ReportCategoryList.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//
import SwiftUI
import Core
import Domain

struct ReportCategoryList: View {
    let data: [ChartCategorySpending]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(data) { item in
                VStack(alignment: .leading, spacing: 8) {
                    // Header for each category
                    HStack {
                        Text(item.category)
                            .font(.title3.bold())
                        Text(" (\(Int(round(item.percentage * 100)))%)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(CurrencyFormatter.format(item.total))
                            .font(.headline)
                            .foregroundColor(.red)
                        
                        
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
}


