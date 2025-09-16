

import SwiftUI

struct AddMessageView: View {
    @EnvironmentObject var dashboardState: DashboardState
    var onClose: () -> Void
    
    @State private var isSending: Bool = false
    @State private var showConfirmation: Bool = false
    @State private var transactionSuccess: Bool = false
    @State private var isAppearing: Bool = false
    @FocusState private var isInputFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    @State private var bottomPadding: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Background dim
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    if !isSending {
                        isInputFocused = false
                        onClose()
                    }
                }
                .opacity(isAppearing ? 1 : 0)
            
            VStack(spacing: 0) {
                headerView
                
                chatArea
                    .frame(maxHeight: .infinity) // flexible space above input
                
                inputArea
            }
            
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            )
            .padding(.bottom, keyboardHeight > 0 ? keyboardHeight - bottomPadding : 0)
            .offset(y: isAppearing ? 0 : 100)
            .opacity(isAppearing ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: keyboardHeight)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isAppearing)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAppearing = true
            }
            setupKeyboardObservers()
            // Get safe area bottom inset
            bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        }
        .onDisappear {
            removeKeyboardObservers()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - Keyboard Handling
private extension AddMessageView {
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            let keyboardHeight = keyboardFrame.height
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                self.keyboardHeight = keyboardHeight
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                self.keyboardHeight = 0
            }
        }
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Header
private extension AddMessageView {
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
            
            Button(action: {
                isInputFocused = false
                withAnimation { onClose() }
            }) {
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
private extension AddMessageView {
    var chatArea: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 20) {
                   
                    if isSending {
                        processingMessageView
                            .id("processingMessage")
                    } else if showConfirmation {
                        confirmationMessageView
                            .id("confirmationMessage")
                    } else {
                        welcomeMessageView
                            .id("welcomeMessage")
                    }
                    
                    if !dashboardState.messageInput.isEmpty {
                        userMessageView
                            .id("userMessage")
                    }
                    
                    // Spacer to push content to top when keyboard is visible
                    if keyboardHeight > 0 {
                        Color.clear
                            .frame(height: 50)
                            .id("keyboardSpacer")
                    }
                }
                .padding(20)
            }
            .frame(maxHeight: 350)
            .onChange(of: dashboardState.messageInput) { _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: isSending) { _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: showConfirmation) { _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: isInputFocused) { focused in
                if focused {
                    // Scroll to bottom when keyboard appears with a slight delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        scrollToBottom(proxy: proxy)
                    }
                }
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.3)) {
            if !dashboardState.messageInput.isEmpty {
                proxy.scrollTo("userMessage", anchor: .bottom)
            } else if isSending {
                proxy.scrollTo("processingMessage", anchor: .bottom)
            } else if showConfirmation {
                proxy.scrollTo("confirmationMessage", anchor: .bottom)
            } else {
                proxy.scrollTo("welcomeMessage", anchor: .bottom)
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
            Image(systemName: dashboardState.lastCreatedTransaction != nil ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .foregroundColor(dashboardState.lastCreatedTransaction != nil ? .green : .orange)
                .frame(width: 32, height: 32)
                .background((dashboardState.lastCreatedTransaction != nil ? Color.green : Color.orange).opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                if let tx = dashboardState.lastCreatedTransaction {
                    Text("Success!")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Transaction **\(tx.name)** (\(tx.amount, specifier: "%.2f")) in category **\(tx.category)** created successfully. Funds will be processed shortly.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                } else {
                    Text("Oops!")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("We couldn't process your request. Please check your details and try again.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                }
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
private extension AddMessageView {
    var inputArea: some View {
        VStack(spacing: 12) {
            Divider()
            
            HStack(alignment: .bottom, spacing: 12) {
                if #available(iOS 16.0, *) {
                    TextField("Describe your transaction...", text: $dashboardState.messageInput, axis: .vertical)
                        .lineLimit(1...5)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .disabled(isSending || showConfirmation)
                        .focused($isInputFocused)
                        .submitLabel(.send)
                        .onSubmit {
                            if !dashboardState.messageInput.isEmpty {
                                sendMessage()
                            }
                        }
                } else {
                    TextField("Describe your transaction...", text: $dashboardState.messageInput)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .disabled(isSending || showConfirmation)
                }
                
                sendButton
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            if showConfirmation {
                Button {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showConfirmation = false
                        dashboardState.messageInput = ""
                        isInputFocused = false
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
                .padding(.bottom, 10)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(.ultraThinMaterial)
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
private extension AddMessageView {
    func sendMessage() {
        guard !dashboardState.messageInput.isEmpty else { return }
        
        isInputFocused = false
        isSending = true
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            let success = await dashboardState.sendTransaction()
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                transactionSuccess = (success != nil)
                showConfirmation = true
                isSending = false
            }
            
            let successGenerator = UINotificationFeedbackGenerator()
            successGenerator.notificationOccurred((success != nil) ? .success : .error)
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

