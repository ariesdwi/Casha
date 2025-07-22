//
//  ReportChartView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 17/07/25.
//
import SwiftUI


struct ReportChartView: View {
    @Binding var selectedTab: DashboardView.Tab
    let weekTotal: String
    let monthTotal: String
    let weekBarHeight: CGFloat
    let monthBarHeight: CGFloat

    var body: some View {
        VStack(alignment: .center, spacing: 16) {

            // Toggle buttons
            HStack(spacing: 8) {
                Button(action: { selectedTab = .week }) {
                    Text("Week")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedTab == .week ? Color.cashaPrimary : Color.clear)
                        .foregroundColor(selectedTab == .week ? .white : .cashaPrimary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.cashaPrimary, lineWidth: 1)
                        )
                        .cornerRadius(8)
                }

                Button(action: { selectedTab = .month }) {
                    Text("Month")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedTab == .month ? Color.cashaPrimary : Color.clear)
                        .foregroundColor(selectedTab == .month ? .white : .cashaPrimary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.cashaPrimary, lineWidth: 1)
                        )
                        .cornerRadius(8)
                }
            }

            // Dynamic balance text
            Text(selectedTab == .week ? weekTotal : monthTotal)
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            // Bar chart
            HStack(alignment: .bottom, spacing: 24) {
                VStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.cashaPrimary)
                        .frame(width: 24, height: weekBarHeight)
                    Text("Last week")
                        .font(.caption)
                }

                VStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.cashaAccent)
                        .frame(width: 24, height: monthBarHeight)
                    Text("This week")
                        .font(.caption)
                }
            }
            .padding(.top, 12)
        }
        .padding()
        .background(Color.cashaCard)
        .cornerRadius(12)
    }
}

