//
//  ReportHeaderView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 17/07/25.
//
import SwiftUI

struct ReportHeaderView: View {
    var onSeeReportTap: () -> Void

    var body: some View {
        HStack {
            Text("Report This Month")
                .font(.headline)
            Spacer()
            Button("See Report", action: onSeeReportTap)
                .font(.subheadline)
                .foregroundColor(.cashaAccent)
        }
    }
}
