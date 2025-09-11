//
//  ToastView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 10/09/25.
//

import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.red.opacity(0.9))
            .cornerRadius(12)
            .shadow(radius: 4)
            .transition(.move(edge: .top).combined(with: .opacity))
            .zIndex(1)
    }
}
