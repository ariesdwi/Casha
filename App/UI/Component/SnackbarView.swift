//
//  SnackbarView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 04/09/25.
//

import SwiftUI

struct SnackbarView: View {
    let message: String
    let isError: Bool
    
    var body: some View {
        HStack {
            Text(message)
                .foregroundColor(.white)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity)
        .background(isError ? Color.red : Color.green)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .shadow(radius: 4)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.spring(), value: message)
    }
}
