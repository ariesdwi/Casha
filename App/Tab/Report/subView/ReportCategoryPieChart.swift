//
//  ReportCategoryPieChart.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//

import SwiftUI
import Charts
import Domain // make sure to import your domain module

@available(iOS 17.0, *)
struct ReportCategoryPieChart: View {
    let data: [ChartCategorySpending]

    var body: some View {
        Chart(data) { item in
            SectorMark(
                angle: .value("Spending", item.total),
                innerRadius: .ratio(0.5),
                angularInset: 2
            )
            .foregroundStyle(by: .value("Category", item.category))
            .annotation(position: .overlay, alignment: .center) {
                Text(String(format: "%.1f%%", item.percentage))
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 250)
    }
}


