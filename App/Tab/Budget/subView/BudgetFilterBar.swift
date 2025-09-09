//
//  BudgetFilterBAr.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 09/09/25.
//
//
//import SwiftUI
//import Core
//
//struct BudgetFilterBar: View {
//    @Binding var selected: String
//    @State private var options: [String] = []
//    
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 12) {
//                ForEach(options, id: \.self) { option in
//                    Button {
//                        selected = option
//                    } label: {
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
//            .padding(.top, 8)
//        }
//        .onAppear {
//            options = DateHelper.generateMonthYearOptions()
//            if selected.isEmpty {
//                selected = DateHelper.generateMonthYearOptions().first ?? ""
//            }
//        }
//    }
//}


import SwiftUI
import Core

struct BudgetFilterBar: View {
    @Binding var selected: String
    @State private var monthOptions: [String] = []
    @State private var showDropdown = false
    
    var body: some View {
        HStack {
            Menu {
                ForEach(monthOptions, id: \.self) { option in
                    Button {
                        selected = option
                    } label: {
                        HStack {
                            Text(option)
                            if option == selected {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selected.isEmpty ? "Select Month" : selected)
                        .font(.headline)
                    Image(systemName: "chevron.down")
                        .font(.subheadline)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .onAppear {
            monthOptions = DateHelper.generateMonthYearOptions()
            if selected.isEmpty {
                selected = monthOptions.first ?? ""
            }
        }
    }
}
