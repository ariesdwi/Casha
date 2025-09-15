
import SwiftUI

struct MessageFormCard: View {
    @EnvironmentObject var dashboardState: DashboardState
    var onClose: () -> Void
    
    @State private var isSending: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
        }
        // 👇 Always pinned to bottom, respecting safe areas & keyboard
        .safeAreaInset(edge: .bottom, spacing: 0) {
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
                    
                    Button(action: { onClose() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .disabled(isSending)
                }
                
                // MARK: Message Input with overlay
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .frame(height: 140)
                    
                    AutoFocusTextEditor(
                        text: $dashboardState.messageInput,
                        onBecomeFirstResponder: true
                    )
                    .frame(height: 140)
                    .padding(12)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .disabled(isSending)
                    
                    if isSending {
                        ZStack {
                            Color.black.opacity(0.05)
                                .cornerRadius(12)
                            ProgressView()
                        }
                        .frame(height: 140)
                    }
                }
                
                // MARK: Send Button
                Button(action: {
                    Task {
                        isSending = true
                        await dashboardState.sendTransaction()
                        isSending = false
                        onClose()
                    }
                }) {
                    HStack {
                        if isSending {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "paperplane.fill")
                            Text("Send")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.cashaPrimary)
                    .cornerRadius(12)
                }
                .padding(.top)
                .disabled(isSending || dashboardState.messageInput.isEmpty)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
            .padding(.horizontal)
            .padding(.bottom, 80) // small gap from keyboard
        }
    }
}
