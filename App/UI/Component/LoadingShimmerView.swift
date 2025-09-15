//
//  LoadingShimmerView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 12/09/25.
//

import SwiftUI

struct LoadingShimmerView: View {
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<3, id: \.self) { _ in
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 120, height: 16)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 80, height: 12)
                        }
                        
                        Spacer()
                        
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 24, height: 24)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .overlay(ShimmerEffect())
                }
            }
        }
        .padding()
    }
}
