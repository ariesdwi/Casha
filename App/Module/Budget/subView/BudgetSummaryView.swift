//
//  BudgetSummaryView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 05/09/25.
//

import SwiftUI
import Domain
import Core

// MARK: - Enhanced SummaryView with Visual Focus
struct SummaryView: View {
    let summary: BudgetSummary?
    let month: String
    
    // Calculate progress percentage (0.0 to 1.0)
    private var progress: Double {
        guard let summary = summary, summary.totalBudget > 0 else { return 0 }
        return min(Double(summary.totalSpent) / Double(summary.totalBudget), 1.0)
    }
    
    // Determine color based on progress
    private var progressColor: Color {
        if progress <= 0.7 {
            return .green
        } else if progress <= 0.9 {
            return .orange
        } else {
            return .red
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with month
            Text("\(month) Budget Overview")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Progress Ring with key metrics
            ZStack {
                // Background ring
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 12)
                
                // Progress ring
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(progressColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: progress)
                
                // Center metrics
                VStack(spacing: 4) {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(progressColor)
                    
                    Text("spent")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 120, height: 120)
            .padding(.vertical, 8)
            
            // Key metrics grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                MetricCard(
                    title: "Budget",
                    value: CurrencyFormatter.format(summary?.totalBudget ?? 0),
                    icon: "arrow.down.circle",
                    color: .blue
                )
                
                MetricCard(
                    title: "Spent",
                    value: CurrencyFormatter.format(summary?.totalSpent ?? 0),
                    icon: "arrow.up.circle",
                    color: progressColor
                )
                
                MetricCard(
                    title: "Remaining",
                    value: CurrencyFormatter.format(summary?.totalRemaining ?? 0),
                    icon: summary?.totalRemaining ?? 0 >= 0 ? "checkmark.circle" : "exclamationmark.circle",
                    color: (summary?.totalRemaining ?? 0) >= 0 ? .green : .red
                )
            }
            
            // Detailed breakdown
            if let summary = summary {
                VStack(spacing: 12) {
                    ProgressBar(
                        value: progress,
                        color: progressColor,
                        height: 8
                    )
                    
                    HStack {
                        Text("Spent: \(CurrencyFormatter.format(summary.totalSpent))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Remaining: \(CurrencyFormatter.format(max(summary.totalRemaining, 0)))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}

// MARK: - Supporting Views
struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(height: 24)
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ProgressBar: View {
    let value: Double
    let color: Color
    let height: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: height)
                    .cornerRadius(height / 2)
                
                // Progress
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * value, height: height)
                    .cornerRadius(height / 2)
                    .animation(.easeInOut(duration: 1.0), value: value)
            }
        }
        .frame(height: height)
    }
}

struct BudgetSummaryView: View {
    let summary: BudgetSummary

    private var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(currentMonth) Budget")
                .font(.headline)
                .foregroundColor(.primary)

            Text("\(CurrencyFormatter.format(summary.totalSpent)) of \(CurrencyFormatter.format(summary.totalBudget)) spent")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if summary.totalRemaining >= 0 {
                Text("Great job! You have \(CurrencyFormatter.format(summary.totalRemaining)) left.")
                    .font(.subheadline)
                    .foregroundColor(.green)
            } else {
                Text("You've exceeded your budget by \(CurrencyFormatter.format(summary.totalRemaining)).")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
