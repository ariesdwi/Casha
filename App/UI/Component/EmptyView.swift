//
//  EmptyView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 22/07/25.
//

import SwiftUI

struct EmptyStateView: View {
    let message : String
    var body: some View {
        VStack {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray)
                .padding()
            Text("No \(message) found")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

