//
//  SearchView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 22/07/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .padding(.leading, 12)
            
            TextField("Search transactions...", text: $text)
                .focused($isFocused)
                .padding(.vertical, 10)
                .foregroundColor(.primary)
                .submitLabel(.search)
            
            if !text.isEmpty {
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        text = ""
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .padding(.trailing, 8)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isFocused ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
    }
}
