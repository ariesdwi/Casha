//
//  DashboardView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//

import SwiftUI
import Core
import Domain

//struct DashboardView: View {
//    @State private var selectedTab: Tab = .week
//    @State private var showAddTransaction = false
//    @State private var showImagePicker = false
//    @State private var selectedImage: UIImage? = nil
//    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
//    @State private var showSourceDialog = false
//    @EnvironmentObject var dashboardState: DashboardState
//    
//    
//    enum Tab { case week, month }
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                
//                // MARK: Card Balance
//                CardBalanceView(balance: CurrencyFormatter.format(dashboardState.totalSpending))
//                
//                // MARK: Report Section Title
//                HStack {
//                    Text("Report This Month")
//                        .font(.headline)
//                    Spacer()
//                    Button("See Report") {
//                        // Navigate to report
//                    }
//                    .font(.subheadline)
//                    .foregroundColor(.cashaAccent)
//                }
//                
//                // MARK: Modular Chart View
//                ReportChartView(
//                    selectedTab: $selectedTab,
//                    weekTotal: CurrencyFormatter.format(dashboardState.report.thisWeekTotal),
//                    monthTotal: CurrencyFormatter.format(dashboardState.report.thisMonthTotal),
//                    weekData: dashboardState.report.dailyBars,
//                    monthData: dashboardState.report.weeklyBars
//                )
//                
//                
//                // MARK: Recent Transactions
//                Text("Recent Transaction")
//                    .font(.headline)
//                    .padding(.top)
//                
//                RecentTransactionList(transactions: dashboardState.recentTransactions)
//                Spacer(minLength: 40)
//            }
//            .padding()
//        }
//        .background(Color.cashaBackground)
//        .navigationTitle("Home")
//        .toolbar {
//            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                Button {
//                    showSourceDialog = true
//                } label: {
//                    Image(systemName: "camera")
//                }
//                
//                Button {
//                    withAnimation {
//                        showAddTransaction = true
//                    }
//                } label: {
//                    Image(systemName: "plus")
//                }
//            }
//        }
//        .onAppear {
//            Task {
//                await dashboardState.loadData()
//            }
//        }
//        .confirmationDialog("Choose Image Source", isPresented: $showSourceDialog) {
//            Button("Camera") {
//                imageSource = .camera
//                showImagePicker = true
//            }
//            
//            Button("Photo Library") {
//                imageSource = .photoLibrary
//                showImagePicker = true
//            }
//            
//            Button("Cancel", role: .cancel) {}
//        }
//        .fullScreenCover(isPresented: $showImagePicker) {
//            ImagePicker(sourceType: imageSource) { image in
//                if let url = image.saveToTemporaryDirectory() {
//                    Task {
//                        dashboardState.selectedImageURL = url
//                        await dashboardState.sendTransactionFromImage()
//                    }
//                }
//            }
//        }
//        .fullScreenCover(isPresented: $showAddTransaction) {
//            ZStack {
//                VisualEffectBlur(blurStyle: .systemThinMaterialDark)
//                    .ignoresSafeArea()
//                
//                VStack {
//                    Spacer()
//                    MessageFormCard {
//                        showAddTransaction = false
//                    }
//                    Spacer()
//                }
//            }
//        }
//    }
//}

//import SwiftUI
//import Core
//import Domain

struct DashboardView: View {
    @State private var selectedTab: Tab = .week
    @State private var showAddTransaction = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceDialog = false
    @EnvironmentObject var dashboardState: DashboardState

    enum Tab { case week, month }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // MARK: Card Balance
                    CardBalanceView(balance: CurrencyFormatter.format(dashboardState.totalSpending))
                    
                    // MARK: Report Section Title
                    HStack {
                        Text("Report This Month")
                            .font(.headline)
                        Spacer()
                        Button("See Report") {
                            // Navigate to report
                        }
                        .font(.subheadline)
                        .foregroundColor(.cashaAccent)
                    }
                    
                    // MARK: Modular Chart View
                    ReportChartView(
                        selectedTab: $selectedTab,
                        weekTotal: CurrencyFormatter.format(dashboardState.report.thisWeekTotal),
                        monthTotal: CurrencyFormatter.format(dashboardState.report.thisMonthTotal),
                        weekData: dashboardState.report.dailyBars,
                        monthData: dashboardState.report.weeklyBars
                    )
                    
                    // MARK: Recent Transactions
                    Text("Recent Transaction")
                        .font(.headline)
                        .padding(.top)
                    
                    RecentTransactionList(transactions: dashboardState.recentTransactions)
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color.cashaBackground)
            .navigationTitle("Home")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showSourceDialog = true
                    } label: {
                        Image(systemName: "camera")
                    }
                    
                    Button {
                        withAnimation {
                            showAddTransaction = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                Task {
                    await dashboardState.loadData()
                }
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
                    Task {
                        if let url = image.saveToTemporaryDirectory() {
                            dashboardState.selectedImageURL = url
                            await dashboardState.sendTransactionFromImage()
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showAddTransaction) {
                ZStack {
                    VisualEffectBlur(blurStyle: .systemThinMaterialDark)
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        MessageFormCard {
                            showAddTransaction = false
                        }
                        Spacer()
                    }
                }
            }

            // MARK: Loading Overlay
            if dashboardState.isSending {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView("Sending...")
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(12)
            }
        }
    }
}


//#Preview {
//    DashboardView()
//}
