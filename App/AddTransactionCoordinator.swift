//
//  AddTransactionCoordinator.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/09/25.
//

import SwiftUI

struct AddTransactionCoordinator: View {
    @Binding var isPresented: Bool
    @EnvironmentObject private var dashboardState: DashboardState
    
    @State private var showManual = false
    @State private var showChat = false
    @State private var showCamera = false
    @State private var showLibrary = false
    
    var body: some View {
        EmptyView()
            .confirmationDialog("Add Transaction", isPresented: $isPresented) {
                Button("Manual Entry") { showManual = true }
                Button("Chat AI") { showChat = true }
                Button("Take Photo") { showCamera = true }
                Button("Choose from Library") { showLibrary = true }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("How would you like to add a transaction?")
            }
            .sheet(isPresented: $showManual) {
                AddTransactionView { newTransaction in
                    Task { await dashboardState.addTransactionManually(newTransaction) }
                }
            }
            .sheet(isPresented: $showChat) {
                MessageFormCard(onClose: { showChat = false })
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
            }
    }
}
