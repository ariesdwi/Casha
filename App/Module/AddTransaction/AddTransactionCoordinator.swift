

import SwiftUI

struct AddTransactionCoordinator: View {
    @Binding var isPresented: Bool
    @EnvironmentObject private var dashboardState: DashboardState
    
    @State private var showManual = false
    @State private var showChat = false
    @State private var showCamera = false
    @State private var showLibrary = false
    @State private var showActionSheet = false
    
    var body: some View {
        EmptyView()
            .onChange(of: isPresented) { newValue in
                if newValue {
                    showActionSheet = true
                }
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Add Transaction"),
                    message: Text("Choose how you'd like to add a transaction"),
                    buttons: [
                        .default(Text("Chat with AI"), action: { showChat = true }),
                        .default(Text("Manual Entry"), action: { showManual = true }),
                        .default(Text("Take Photo"), action: { showCamera = true }),
                        .default(Text("Photo Library"), action: { showLibrary = true }),
                        .cancel(Text("Cancel"), action: { isPresented = false })
                    ]
                )
            }
            .sheet(isPresented: $showManual) {
                AddTransactionView { newTransaction in
                    Task { await dashboardState.addTransactionManually(newTransaction) }
                }
            }
            .fullScreenCover(isPresented: $showChat) {
                NavigationView {
                      AddMessageView(onClose: { showChat = false })
                          .environmentObject(dashboardState)
                          .ignoresSafeArea(.keyboard, edges: .bottom) // allow keyboard to overlap only content, not input
                          .navigationBarHidden(true)
                  }
            }
            .fullScreenCover(isPresented: $showCamera) {
                ImagePicker(sourceType: .camera) { image in
                    Task {
                        if let url = image.saveToTemporaryDirectory() {
                            dashboardState.selectedImageURL = url
                            await dashboardState.sendTransaction()
                        }
                        showCamera = false
                        isPresented = false
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
            .fullScreenCover(isPresented: $showLibrary) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    Task {
                        if let url = image.saveToTemporaryDirectory() {
                            dashboardState.selectedImageURL = url
                            await dashboardState.sendTransaction()
                        }
                        showLibrary = false
                        isPresented = false
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
            .onChange(of: showManual) { if !$0 { isPresented = false } }
            .onChange(of: showChat) { if !$0 { isPresented = false } }
            .onChange(of: showCamera) { if !$0 { isPresented = false } }
            .onChange(of: showLibrary) { if !$0 { isPresented = false } }
    }
}
