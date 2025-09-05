//
//  SyncBadgeView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 05/09/25.
//

import SwiftUI

struct SyncBadgeView: View {
    let count: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.system(size: 20))
                .foregroundColor(.blue)
            
            if count > 0 {
                Text("\(count)")
                    .font(.system(size: 11, weight: .bold))
                    .padding(4)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .offset(x: 8, y: -8)
            }
        }
    }
}

