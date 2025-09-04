//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 29/08/25.
//
// BudgetCardView.swift

import SwiftUI
import Domain
import Core

struct BudgetCardView: View {
    let budget: BudgetCasha
    
    private var progress: Double {
        guard budget.amount > 0 else { return 0 }
        return min(budget.spent / budget.amount, 1.0)
    }
    
    private var progressColor: Color {
        if progress < 0.7 {
            return .green
        } else if progress < 0.9 {
            return .orange
        } else {
            return .red
        }
    }
    
    private var progressPercentage: String {
        String(format: "%.0f%%", progress * 100)
    }
    
    // Helper to format currency
  
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(budget.category)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(  "\(DateHelper.format(budget.startDate, style: .sectionDate)) - \(DateHelper.format(budget.endDate, style: .sectionDate))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(CurrencyFormatter.format(budget.amount))
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Text(progressPercentage)
                        .font(.caption2)
                        .foregroundColor(progressColor)
                        .fontWeight(.semibold)
                }
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 6)
                        .foregroundColor(Color(.systemGray4))
                    
                    Rectangle()
                        .frame(width: CGFloat(progress) * geometry.size.width, height: 6)
                        .foregroundColor(progressColor)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
                .cornerRadius(3)
            }
            .frame(height: 6)
            
            HStack {
                Text("Spent: " + CurrencyFormatter.format(budget.spent))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Left: " + CurrencyFormatter.format(budget.remaining))
                    .font(.caption)
                    .foregroundColor(budget.remaining >= 0 ? .green : .red)
                    .fontWeight(budget.remaining < 0 ? .semibold : .regular)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}


