//
//  ReportChartView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 17/07/25.
//
import SwiftUI
import Domain

struct ReportChartView: View {
    @Binding var selectedTab: DashboardView.Tab
    let weekTotal: String
    let monthTotal: String

    let weekData: [SpendingBar]
    let monthData: [SpendingBar]

    private var chartMode: ChartMode {
        selectedTab == .week ? .daily : .weekly
    }

    private var chartData: [SpendingBar] {
        selectedTab == .week ? weekData : monthData
    }

    private var maxAmount: Double {
        chartData.map { $0.amount }.max() ?? 1
    }

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            // Toggle buttons
            HStack(spacing: 8) {
                chartToggleButton(title: "This Week", tab: .week)
                chartToggleButton(title: "This Month", tab: .month)
            }

            // Dynamic balance text
            Text(selectedTab == .week ? weekTotal : monthTotal)
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            // Bar chart
            HStack(alignment: .bottom, spacing: 16) {
                ForEach(chartData) { bar in
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(color(for: bar))
                            .frame(
                                width: 20,
                                height: CGFloat(bar.amount / max(maxAmount, 0.01)) * 120 // scale to max
                            )
                        Text(bar.label)
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding(.top, 12)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
    }

    @ViewBuilder
    private func chartToggleButton(title: String, tab: DashboardView.Tab) -> some View {
        Button(action: { selectedTab = tab }) {
            Text(title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selectedTab == tab ? Color.cashaPrimary : Color.clear)
                .foregroundColor(selectedTab == tab ? .white : .cashaPrimary)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.cashaPrimary, lineWidth: 1)
                )
                .cornerRadius(8)
        }
    }
    
    private func color(for bar: SpendingBar) -> Color {
        // For example: alternate colors
        let index = chartData.firstIndex(of: bar) ?? 0
        return index % 2 == 0 ? .cashaPrimary : .cashaAccent
    }
}

enum ChartMode {
    case daily  // for week (Mon–Sun)
    case weekly // for month (Week 1–4)
}

