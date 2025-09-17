//
//  ReportView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//

import SwiftUI
import Domain

struct ReportView: View {
    @EnvironmentObject var reportState: ReportState
    
    var body: some View {
        if #available(iOS 16.0, *) {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    
                    if reportState.categorySpendings.isEmpty {
                        EmptyStateView(message: "No data available")
                    } else {
                        chartSection
                        ReportCategoryList(data: reportState.categorySpendings)
                    }
                }
                .padding()
            }
            .navigationTitle("Report")
            .navigationBarTitleDisplayMode(.large)
            .toolbar { filterMenu }
            //            .toolbarBackground(.hidden, for: .navigationBar)
            .task {
                await reportState.loadCategorySpending()
            }
            .background(Color.clear)
            
        }
    }
}

// MARK: - Sections
private extension ReportView {
    var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Spending by Category")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(reportState.selectedPeriod.title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    var chartSection: some View {
        if #available(iOS 17.0, *) {
            ReportCategoryPieChart(data: reportState.categorySpendings)
        } else {
            Text("Chart only supported on iOS 17+")
                .foregroundColor(.secondary)
        }
    }
    
    var filterMenu: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                ForEach(ReportFilterPeriod.allCases) { period in
                    Button {
                        Task {
                            await reportState.setFilter(period)
                        }
                    } label: {
                        Label(period.title, systemImage: reportState.selectedPeriod == period ? "checkmark" : "")
                    }
                }
            } label: {
                Label("Filter", systemImage: "calendar")
            }
        }
    }
}







