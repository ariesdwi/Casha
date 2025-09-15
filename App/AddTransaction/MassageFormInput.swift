import SwiftUI

struct MessageFormCard: View {
    @EnvironmentObject var dashboardState: DashboardState
    var onClose: () -> Void
    
    @State private var isSending: Bool = false
    @State private var showConfirmation: Bool = false
    @State private var transactionSuccess: Bool = false
    @State private var isAppearing: Bool = false
    
    var body: some View {
        ZStack {
            // Background dim
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { if !isSending { onClose() } }
                .opacity(isAppearing ? 1 : 0)
            
            // Main card
            VStack(spacing: 0) {
                headerView
                chatArea
                inputArea
            }
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 0)
            .offset(y: isAppearing ? 0 : 100)
            .opacity(isAppearing ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAppearing = true
            }
        }
    }
}

// MARK: - Header
private extension MessageFormCard {
    var headerView: some View {
        HStack(spacing: 16) {
            Image(systemName: "text.bubble.fill")
                .font(.title3)
                .foregroundColor(.cashaPrimary)
                .frame(width: 40, height: 40)
                .background(Color.cashaPrimary.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("New Transaction")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Keep it short and simple")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { withAnimation { onClose() } }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .contentShape(Circle())
            }
            .disabled(isSending)
        }
        .padding(20)
        .background(Color(.systemGray6))
    }
}

// MARK: - Chat Area
private extension MessageFormCard {
    var chatArea: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 20) {
                    if !dashboardState.messageInput.isEmpty {
                        userMessageView
                            .id("userMessage")
                    }
                    
                    if isSending {
                        processingMessageView
                            .id("processingMessage")
                    } else if showConfirmation {
                        confirmationMessageView
                            .id("confirmationMessage")
                    } else {
                        welcomeMessageView
                    }
                }
                .padding(20)
            }
            .frame(maxHeight: 300)
            .onChange(of: dashboardState.messageInput) { _ in
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo("userMessage", anchor: .bottom)
                }
            }
            .onChange(of: isSending) { _ in
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo("processingMessage", anchor: .bottom)
                }
            }
            .onChange(of: showConfirmation) { _ in
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo("confirmationMessage", anchor: .bottom)
                }
            }
        }
    }
    
    var welcomeMessageView: some View {
        HStack(alignment: .top) {
            Image(systemName: "sparkles")
                .foregroundColor(.cashaPrimary)
                .frame(width: 32, height: 32)
                .background(Color.cashaPrimary.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Hi there! 👋")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Describe what you'd like to transact. For example: \"Send $50 to John for lunch\"")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Spacer()
        }
    }
    
    var userMessageView: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                Text(dashboardState.messageInput)
                    .padding(12)
                    .background(
                        LinearGradient(
                            colors: [Color.cashaPrimary, Color.cashaPrimary.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .cornerRadius(16, corners: [.topLeft, .topRight, .bottomLeft])
                
                Text("You • Just now")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var processingMessageView: some View {
        HStack(alignment: .top) {
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(.cashaPrimary)
                .frame(width: 32, height: 32)
                .background(Color.cashaPrimary.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Processing...")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(0.8)
                    
                    Text("Creating your transaction")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Spacer()
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    var confirmationMessageView: some View {
        HStack(alignment: .top) {
            Image(systemName: transactionSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .foregroundColor(transactionSuccess ? .green : .orange)
                .frame(width: 32, height: 32)
                .background((transactionSuccess ? Color.green : Color.orange).opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                Text(transactionSuccess ? "Success!" : "Oops!")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(transactionSuccess ?
                     "Transaction #\(Int.random(in: 1000...9999)) created successfully. Funds will be processed shortly." :
                     "We couldn't process your request. Please check your details and try again.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Spacer()
        }
        .transition(.scale.combined(with: .opacity))
    }
}

// MARK: - Input Area
private extension MessageFormCard {
    var inputArea: some View {
        VStack(spacing: 16) {
            Divider()
            
            HStack(alignment: .bottom, spacing: 12) {
                AutoFocusTextEditor(
                    text: $dashboardState.messageInput,
                    onBecomeFirstResponder: true,
                    placeholder: "Describe your transaction..."
                )
                .frame(minHeight: 20, maxHeight: 100)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .disabled(isSending || showConfirmation)
                
                sendButton
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            if showConfirmation {
                Button {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showConfirmation = false
                        dashboardState.messageInput = ""
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Transaction")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(
                            colors: [Color.cashaPrimary, Color.cashaPrimary.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
    var sendButton: some View {
        Button(action: sendMessage) {
            Group {
                if isSending {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: "paperplane.fill")
                }
            }
            .frame(width: 44, height: 44)
            .foregroundColor(.white)
            .background(
                Group {
                    if dashboardState.messageInput.isEmpty || showConfirmation {
                        Color.gray
                    } else {
                        LinearGradient(
                            colors: [Color.cashaPrimary, Color.cashaPrimary.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                }
            )
            .clipShape(Circle())
            .shadow(color: Color.cashaPrimary.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .disabled(isSending || dashboardState.messageInput.isEmpty || showConfirmation)
        .scaleEffect(dashboardState.messageInput.isEmpty ? 0.9 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: dashboardState.messageInput.isEmpty)
    }
}

// MARK: - Sending Logic
private extension MessageFormCard {
    func sendMessage() {
        guard !dashboardState.messageInput.isEmpty else { return }
        
        isSending = true
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000) // Simulate processing
            
            let success = await dashboardState.sendMTransaction()
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                transactionSuccess = success
                showConfirmation = true
                isSending = false
            }
            
            // Success haptic
            let successGenerator = UINotificationFeedbackGenerator()
            successGenerator.notificationOccurred(success ? .success : .error)
        }
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
