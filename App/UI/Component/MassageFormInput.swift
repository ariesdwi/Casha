import SwiftUI

struct MessageFormCard: View {
    @EnvironmentObject var dashboardState: DashboardState
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
                    
                    Button(action: { onClose() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .disabled(dashboardState.isSending) // disable close while sending
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
                    .disabled(dashboardState.isSending)
                    
                    // Overlay loader if sending
                    if dashboardState.isSending {
                        ZStack {
                            Color.black.opacity(0.05)
                                .cornerRadius(12)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        .frame(height: 140)
                    }
                }
                
                // MARK: Send Button
                Button(action: {
                    Task {
                        await dashboardState.sendTransaction()
                        onClose()
                    }
                }) {
                    HStack {
                        if dashboardState.isSending {
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
                .disabled(dashboardState.isSending) // prevent double tap
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
