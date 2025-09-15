//
//  BudgetListView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/09/25.
//

import SwiftUI
import Domain

struct BudgetListView: View {
    let budgets: [BudgetCasha]
    
    var body: some View {
        if budgets.isEmpty {
            EmptyStateView(message: "Budgets")
        } else {
            LazyVStack(spacing: 12) {
                ForEach(budgets) { budget in
                    BudgetCardView(budget: budget)
                }
            }
            .padding(.horizontal)
        }
    }
}
