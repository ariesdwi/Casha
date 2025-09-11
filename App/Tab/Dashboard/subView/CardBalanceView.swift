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
                Text(isBalanceVisible ? "- " + balance : "••••••")
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

