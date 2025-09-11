//
//  tr.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//

//import SwiftUI
//import Core
//
//struct TransactionFilterBar: View {
//    @Binding var selected: String
//    @State private var monthOptions: [String] = []
//    
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 12) {
//                ForEach(monthOptions, id: \.self) { option in
//                    Button(action: {
//                        selected = option
//                    }) {
//                        Text(option)
//                            .padding(.vertical, 6)
//                            .padding(.horizontal, 14)
//                            .background(selected == option ? Color.cashaPrimary : Color(.systemGray5))
//                            .foregroundColor(selected == option ? .white : .black)
//                            .cornerRadius(8)
//                    }
//                }
//            }
//            .padding(.horizontal)
//            .padding(.top, 12)
//        }
//        .onAppear {
//            monthOptions = DateHelper.generateMonthOptions()
//            selected = "This month" // Default selection
//        }
//    }
//}


import SwiftUI
import Core

struct TransactionFilterBar: View {
    @Binding var selected: String
    @State private var monthOptions: [String] = []
    @State private var showDropdown = false
    
    // The three main options to display
    private let mainOptions = ["This month", "Other month", "This year"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // "This month" option
                FilterButton(
                    option: "This month",
                    isSelected: selected == "This month",
                    action: { selected = "This month" }
                )
                
                // "Other month" dropdown
                Menu {
                    // Show all month options except "This month" and "All months"
                    ForEach(monthOptions.filter { $0 != "This month" && $0 != "This year" }, id: \.self) { option in
                        Button(action: {
                            selected = option
                        }) {
                            HStack {
                                Text(option)
                                if selected == option {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                } label: {
                    FilterButton(
                        option: "Other month",
                        isSelected: selected != "This month" && selected != "This year",
                        showChevron: true,
                        action: {}
                    )
                }
                
                // "All month" option
                FilterButton(
                    option: "This year",
                    isSelected: selected == "This year",
                    action: { selected = "This year" }
                )
            }
            .padding(.horizontal)
            .padding(.top, 12)
        }
        .onAppear {
            monthOptions = DateHelper.generateMonthOptions()
            selected = "This month" // Default selection
        }
    }
}

// Reusable filter button component
struct FilterButton: View {
    let option: String
    let isSelected: Bool
    var showChevron: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(option)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
                
                if showChevron {
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                Capsule()
                    .fill(isSelected ? Color.cashaPrimary : Color(.systemGray5))
            )
            .foregroundColor(isSelected ? .white : .black)
        }
    }
}
