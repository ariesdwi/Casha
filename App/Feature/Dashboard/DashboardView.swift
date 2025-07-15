//
//  DashboardView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//

import SwiftUI
import Core

struct DashboardView: View {
    @State private var selectedTab: Tab = .week
    @State private var showAddTransaction = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceDialog = false
    private let permissionAccess = PermissionAccess()

    enum Tab { case week, month }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: Card Balance
                VStack(alignment: .leading, spacing: 4) {
                    Text("Card Balance")
                        .font(.headline)
                    HStack {
                        Text("Rp -2,961,300.00")
                            .font(.largeTitle.bold())
                        Spacer()
                        Image(systemName: "eye.fill")
                    }
                }
                .padding()
                .background(Color.cashaCard)
                .cornerRadius(12)

                // MARK: Report Section
                HStack {
                    Text("Report This Month")
                        .font(.headline)
                    Spacer()
                    Button("See Report") {
                        // Navigation to detailed report
                    }
                    .font(.subheadline)
                    .foregroundColor(.cashaAccent)
                }

                // MARK: Bar Chart + Filter
                VStack(alignment: .center, spacing: 16) {
                    HStack(spacing: 8) {
                        Button(action: { selectedTab = .week }) {
                            Text("Week")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedTab == .week ? Color.cashaPrimary : Color.clear)
                                .foregroundColor(selectedTab == .week ? .white : .cashaPrimary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.cashaPrimary, lineWidth: 1)
                                )
                                .cornerRadius(8)
                        }

                        Button(action: { selectedTab = .month }) {
                            Text("Month")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedTab == .month ? Color.cashaPrimary : Color.clear)
                                .foregroundColor(selectedTab == .month ? .white : .cashaPrimary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.cashaPrimary, lineWidth: 1)
                                )
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity) 
                    
                    Text("Rp 961,300.00")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(alignment: .bottom, spacing: 24) {
                        VStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.cashaPrimary)
                                .frame(width: 24, height: 100)
                            Text("Last week")
                                .font(.caption)
                        }

                        VStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.cashaAccent)
                                .frame(width: 24, height: 60)
                            Text("This week")
                                .font(.caption)
                        }
                    }
                    .padding(.top, 12)
                }
                .padding()
                .background(Color.cashaCard)
                .cornerRadius(12)


                // MARK: Recent Transactions
                Text("Recent Transaction")
                    .font(.headline)
                    .padding(.top)

                VStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Food & Beverage")
                                    .font(.subheadline)
                                Text("Mie Ayam")
                                    .font(.caption)
                            }
                            Spacer()
                            Text("Rp 10,000")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.cashaCard)
                        .cornerRadius(10)
                    }
                }

                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(Color.cashaBackground)
        .navigationTitle("Home")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    showSourceDialog = true
                }) {
                    Image(systemName: "camera")
                }

                Button(action: {
                    showAddTransaction = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionView()
        }
        .confirmationDialog("Choose Image Source", isPresented: $showSourceDialog) {
            Button("Camera") {
                imageSource = .camera
                showImagePicker = true
            }
            
            Button("Photo Library") {
                imageSource = .photoLibrary
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(sourceType: imageSource) { image in
                selectedImage = image
                print("✅ Selected image: \(image)")
            }
        }
    }
}

#Preview {
    DashboardView()
}
