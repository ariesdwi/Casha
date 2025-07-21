//
//  DashboardView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//

import SwiftUI
import Core
import Domain

struct DashboardView: View {
    @State private var selectedTab: Tab = .week
    @State private var showAddTransaction = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceDialog = false
    @StateObject private var dashboardState = DashboardState()

    
    enum Tab { case week, month }
    
    // MARK: - Computed Properties for Dynamic Data
    var reportTotal: String {
        selectedTab == .week ? "Rp 961,300.00" : "Rp 2,420,000.00"
    }
    
    var lastBarHeight: CGFloat {
        selectedTab == .week ? 100 : 80
    }
    
    var thisBarHeight: CGFloat {
        selectedTab == .week ? 60 : 130
    }
    
    var body: some View {
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
                    weekTotal: CurrencyFormatter.format(dashboardState.report.thisPeriod),
                    monthTotal: CurrencyFormatter.format(dashboardState.report.lastPeriod),
                    weekBarHeight: 100,
                    monthBarHeight: 60
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
            dashboardState.injectDummyTransactionsIfNeeded()
            dashboardState.loadData()
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
    }
}


//#Preview {
//    DashboardView()
//}
