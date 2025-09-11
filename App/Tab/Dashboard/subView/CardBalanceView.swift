//
//  CardBalanceView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//

import SwiftUI

struct CardBalanceView: View {
    let balance: String
    @State private var isBalanceVisible = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Card Balance")
                .font(.headline)
            HStack {
                Text(
                    isBalanceVisible ? formattedBalance : "••••••"
                )
                    .font(.largeTitle.bold())
                Spacer()
                Button(action: toggleBalanceVisibility) {
                    Image(systemName: isBalanceVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.cashaPrimary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var formattedBalance: String {
        // Check if balance is zero or empty
        let numericBalance = balance.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
        
        if let amount = Double(numericBalance), amount == 0 {
            return balance // Return the original balance without "- "
        } else {
            return "- " + balance // Add "- " for non-zero balances
        }
    }
    
    private func toggleBalanceVisibility() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isBalanceVisible.toggle()
        }
    }
}

// Preview for testing
//struct CardBalanceView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardBalanceView(balance: "$1,234.56")
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
//}

