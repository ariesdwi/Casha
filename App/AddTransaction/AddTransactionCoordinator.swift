//
//  AddTransactionCoordinator.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/09/25.
//
//
//import SwiftUI
//
//struct AddTransactionCoordinator: View {
//    @Binding var isPresented: Bool
//    @EnvironmentObject private var dashboardState: DashboardState
//    
//    @State private var showManual = false
//    @State private var showChat = false
//    @State private var showCamera = false
//    @State private var showLibrary = false
//    
//    var body: some View {
//        EmptyView()
//            .confirmationDialog("Add Transaction", isPresented: $isPresented) {
//                Button("Manual Entry") { showManual = true }
//                Button("Chat AI") { showChat = true }
//                Button("Take Photo") { showCamera = true }
//                Button("Choose from Library") { showLibrary = true }
//                Button("Cancel", role: .cancel) {}
//            } message: {
//                Text("How would you like to add a transaction?")
//            }
//            .sheet(isPresented: $showManual) {
//                AddTransactionView { newTransaction in
//                    Task { await dashboardState.addTransactionManually(newTransaction) }
//                }
//            }
//            .fullScreenCover(isPresented: $showChat) {
//                MessageFormCard(onClose: { showChat = false })
//            }
//            .fullScreenCover(isPresented: $showCamera) {
//                ImagePicker(sourceType: .camera) { image in
//                    Task {
//                        if let url = image.saveToTemporaryDirectory() {
//                            dashboardState.selectedImageURL = url
//                            await dashboardState.sendTransaction()
//                        }
//                        showCamera = false
//                    }
//                }
//            }
//            .fullScreenCover(isPresented: $showLibrary) {
//                ImagePicker(sourceType: .photoLibrary) { image in
//                    Task {
//                        if let url = image.saveToTemporaryDirectory() {
//                            dashboardState.selectedImageURL = url
//                            await dashboardState.sendTransaction()
//                        }
//                        showLibrary = false
//                    }
//                }
//            }
//    }
//}


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
                MessageFormCard(onClose: {
                    showChat = false
                    isPresented = false
                })
                .environmentObject(dashboardState)
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

// Alternative: Modern iOS 16+ Menu Style
struct AddTransactionMenu: View {
    @Binding var isPresented: Bool
    @EnvironmentObject private var dashboardState: DashboardState
    
    @State private var showManual = false
    @State private var showChat = false
    @State private var showCamera = false
    @State private var showLibrary = false
    
    var body: some View {
        Menu {
            Button(action: { showChat = true }) {
                Label("Chat with AI", systemImage: "text.bubble")
            }
            
            Button(action: { showManual = true }) {
                Label("Manual Entry", systemImage: "pencil")
            }
            
            Menu {
                Button(action: { showCamera = true }) {
                    Label("Take Photo", systemImage: "camera")
                }
                
                Button(action: { showLibrary = true }) {
                    Label("Choose from Library", systemImage: "photo.on.rectangle")
                }
            } label: {
                Label("From Image", systemImage: "photo")
            }
            
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
                .foregroundColor(.cashaPrimary)
        }
        .sheet(isPresented: $showManual) {
            NavigationView {
                AddTransactionView { newTransaction in
                    Task { await dashboardState.addTransactionManually(newTransaction) }
                }
                .navigationTitle("Manual Entry")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { showManual = false }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showChat) {
            MessageFormCard(onClose: { showChat = false })
                .environmentObject(dashboardState)
        }
        .fullScreenCover(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera) { image in
                Task {
                    if let url = image.saveToTemporaryDirectory() {
                        dashboardState.selectedImageURL = url
                        await dashboardState.sendTransaction()
                    }
                    showCamera = false
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
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
