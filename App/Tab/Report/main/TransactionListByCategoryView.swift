//
//  TransactionListByCategoryView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 11/09/25.
//

import SwiftUI
import Domain
import Core

struct TransactionListByCategoryView: View {
    let category: String
    @EnvironmentObject var reportState: ReportState
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isRefreshing = false
    @State private var shimmerPositions: [Int: CGFloat] = [:]
    
    private var totalAmount: Double {
        reportState.transactionsByCategory.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        ZStack {
            // Background color matching WhatsApp
            Color("WhatsAppBackground")
                .ignoresSafeArea()
            
            if isLoading && reportState.transactionsByCategory.isEmpty {
                // WhatsApp-style shimmer loading
                loadingShimmerView
            } else if reportState.transactionsByCategory.isEmpty {
                EmptyStateView(message: category)
            } else {
                contentView
            }
        }
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .task {
            await loadTransactions()
        }
        .refreshable {
            await refreshTransactions()
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // Summary card
                SummaryCardView(totalAmount: totalAmount, transactionCount: reportState.transactionsByCategory.count)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                
                // Transactions list
                LazyVStack(spacing: 0) {
                    ForEach(Array(reportState.transactionsByCategory.enumerated()), id: \.element.id) { index, transaction in
                        TransactionRow(transaction: transaction, index: index)
                            .padding(.horizontal)
                            .background(Color(.systemBackground))
                            .onAppear {
                                // Animate row appearance with delay based on index
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.05)) {
                                    shimmerPositions[index] = 1.0
                                }
                            }
                        
                        Divider()
                            .padding(.leading, 72)
                    }
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .padding(.bottom, 16)
        }
        .background(Color("WhatsAppBackground"))
    }
    
    private var loadingShimmerView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // Shimmer summary card
                ShimmerSummaryCardView()
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                
                // Shimmer transactions
                LazyVStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { index in
                        ShimmerTransactionRow()
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                        
                        Divider()
                            .padding(.leading, 72)
                    }
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.top, 8)
            }
        }
        .background(Color("WhatsAppBackground"))
    }
    
    private func loadTransactions() async {
        isLoading = true
        do {
            // Simulate a brief loading delay for smooth UX
//            try await Task.sleep(nanoseconds: 800_000_000)
            await reportState.loadTransactionsByCategory(category: category)
        }
        isLoading = false
    }
    
    private func refreshTransactions() async {
        isRefreshing = true
        await reportState.loadTransactionsByCategory(category: category)
        // Add a small delay to show the refresh animation
//        try? await Task.sleep(nanoseconds: 500_000_000)
        isRefreshing = false
    }
}



// MARK: - Enhanced Summary Card
struct SummaryCardView: View {
    let totalAmount: Double
    let transactionCount: Int
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Total Amount")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(totalAmount, format: .currency(code: "IDR"))
                        .font(.title2.weight(.bold))
                        .foregroundColor(totalAmount < 0 ? .red : Color.green.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Transactions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(transactionCount)")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.primary)
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Shimmer Loading Views
struct ShimmerSummaryCardView: View {
    @State private var shimmer = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 12)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 120, height: 20)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 12)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 20)
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .overlay(
            ShimmerEffect()
                .clipShape(RoundedRectangle(cornerRadius: 16))
        )
    }
}

struct ShimmerTransactionRow: View {
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 14)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 10)
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 70, height: 16)
        }
        .padding(.vertical, 12)
        .overlay(
            ShimmerEffect()
        )
    }
}

struct ShimmerEffect: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                .clear,
                .white.opacity(0.3),
                .clear
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .blendMode(.overlay)
        .modifier(AnimatableGradientPhase(phase: phase))
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }
}

struct AnimatableGradientPhase: AnimatableModifier {
    var phase: CGFloat
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .mask(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: phase - 0.3),
                        .init(color: .white, location: phase),
                        .init(color: .clear, location: phase + 0.3)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}


// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Add to your Assets.xcassets: WhatsAppBackground color (hex: F0F2F5)
