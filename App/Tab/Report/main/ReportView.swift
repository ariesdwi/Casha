//
//  ReportView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 25/07/25.
//


import SwiftUI
import Domain

//struct ReportView: View {
//    @EnvironmentObject var reportState: ReportState
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 24) {
//                Text("Spending by Category")
//                    .font(.title2)
//                    .bold()
//
//                if #available(iOS 17.0, *) {
//                    ReportCategoryPieChart(data: reportState.categorySpendings)
//                } else {
//                    Text("Chart only supported on iOS 17+")
//                }
//
//                ReportCategoryList(data: reportState.categorySpendings)
//            }
//            .padding()
//        }
//        .onAppear {
//            reportState.loadCategorySpending()
//        }
//        .background(Color.cashaBackground.ignoresSafeArea())
//        .navigationTitle("Report")
//    }
//}

struct ReportView: View {
    @EnvironmentObject var reportState: ReportState

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Spending by Category")
                    .font(.title2)
                    .bold()

                if #available(iOS 17.0, *) {
                    ReportCategoryPieChart(data: reportState.categorySpendings)
                } else {
                    Text("Chart only supported on iOS 17+")
                }

                ReportCategoryList(data: reportState.categorySpendings)
            }
            .padding()
        }
        .toolbar {
            Menu {
                ForEach(ReportFilterPeriod.allCases) { period in
                    Button {
                        reportState.setFilter(period)
                    } label: {
                        Label(period.title, systemImage: reportState.selectedPeriod == period ? "checkmark" : "")
                    }
                }
            } label: {
                Label("Filter", systemImage: "calendar")
            }
        }
        .onAppear {
            reportState.loadCategorySpending()
        }
        .background(Color.cashaBackground.ignoresSafeArea())
        .navigationTitle("Report")
    }
}


