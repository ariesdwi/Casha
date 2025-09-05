//
//  SyncBanner.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 05/09/25.
//

// MARK: - Sync UI Components
import SwiftUI

struct SyncStatusBanner: View {
    let unsyncedCount: Int
    let onSyncNow: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            
            Text("\(unsyncedCount) transaction(s) waiting to sync")
                .font(.subheadline)
            
            Spacer()
            
            Button("Sync Now", action: onSyncNow)
                .font(.subheadline.bold())
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
}
