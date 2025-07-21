//
//  MassageFormInput.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 17/07/25.
//
import SwiftUI

struct MessageFormCard: View {
    @State private var message: String = ""
    @ObservedObject private var keyboard = KeyboardResponder()
    var onClose: () -> Void

    var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading, spacing: 16) {
                // MARK: Title & Close
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Message *")
                            .font(.headline)
                            .fontWeight(.semibold)

                        Text("Keep it short and simple")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Button(action: {
                        onClose()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }

                // MARK: Message Input
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .frame(height: 140)
                    AutoFocusTextEditor(text: $message, onBecomeFirstResponder: true)
                        .frame(height: 140)
                        .padding(12)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }

                // MARK: Send Button
                Button(action: {
                    print("📤 Message sent: \(message)")
                    onClose()
                }) {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("Send")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.cashaPrimary)
                    .cornerRadius(12)
                }
                .padding(.top)
            }
            .padding()
            .background(Color.cashaCard)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
            .padding(.horizontal)

        }
        .padding(.bottom, keyboard.currentHeight + 20)
        .animation(.easeOut(duration: 0.3), value: keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
    }
}


#Preview {
    MessageFormCard(onClose: {
        
    })
}
