//
//  CardBalanceView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//

import SwiftUI

struct CardBalanceView: View {
    var balance: String = "Rp -2,961,300.00"

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Card Balance")
                .font(.headline)
            HStack {
                Text(balance)
                    .font(.largeTitle.bold())
                Spacer()
                Image(systemName: "eye.fill")
            }
        }
        .padding()
        .background(Color.cashaCard)
        .cornerRadius(12)
    }
}
