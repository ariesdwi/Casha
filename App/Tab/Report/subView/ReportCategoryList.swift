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
                        Spacer()
                        Text(CurrencyFormatter.format(item.total))
                            .font(.headline)
                            .foregroundColor(.red)
                    }

                    // Sub-info like percentage
                    Text(String(format: "%.1f%% of total spending", item.percentage))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
}

