//
//  SyncFloatingButton.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 05/09/25.
//

import SwiftUI

struct SyncFloatingButton: View {
    let count: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 56, height: 56)
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            
            ZStack {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 12, weight: .bold))
                        .padding(4)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .offset(x: 12, y: -12)
                }
            }
        }
    }
}


