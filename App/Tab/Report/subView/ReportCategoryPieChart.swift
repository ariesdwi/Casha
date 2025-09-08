//
//  ReportCategoryPieChart.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//


import SwiftUI
import Charts
import Domain

@available(iOS 17.0, *)
struct ReportCategoryPieChart: View {
    let data: [ChartCategorySpending]
    
    // Generate distinct colors for each category
    private let categoryColors: [Color] = [
        .blue, .green, .orange, .red, .purple,
        .pink, .teal, .indigo, .brown, .cyan,
        .mint, .yellow
    ]
    
    var body: some View {
        Chart(data) { item in
            SectorMark(
                angle: .value("Spending", item.total),
                innerRadius: .ratio(0.5),
                angularInset: 1.5
            )
            .foregroundStyle(by: .value("Category", item.category))
            .cornerRadius(4)
            .annotation(position: .overlay) {
                if item.percentage >= 0.05 { // 5% threshold for decimal percentages
                    Text("\(Int(round(item.percentage * 100)))%")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                }
            }
        }
        .chartForegroundStyleScale { category in
            // Assign colors based on category index
            if let index = data.firstIndex(where: { $0.category == category }) {
                return categoryColors[index % categoryColors.count]
            }
            return .gray
        }
        .chartLegend(position: .bottom, alignment: .center, spacing: 8)
        .chartLegend(.visible)
        .frame(height: 300)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}

// Optional: Preview Provider for testing
//@available(iOS 17.0, *)
//#Preview {
//    let sampleData = [
//        ChartCategorySpending(category: "Food", total: 1500000, percentage: 35.0),
//        ChartCategorySpending(category: "Shopping", total: 800000, percentage: 20.0),
//        ChartCategorySpending(category: "Transportation", total: 500000, percentage: 12.5),
//        ChartCategorySpending(category: "Entertainment", total: 400000, percentage: 10.0),
//        ChartCategorySpending(category: "Utilities", total: 300000, percentage: 7.5),
//        ChartCategorySpending(category: "Other", total: 500000, percentage: 15.0)
//    ]
//
//    return ReportCategoryPieChart(data: sampleData)
//        .padding()
//        .previewLayout(.sizeThatFits)
//}
