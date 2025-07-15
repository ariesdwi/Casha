//
//  AddTransactionView.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//

import SwiftUI
import Core

struct AddTransactionView: View {
    @State private var amount: String = "0"
    @State private var selectedDate: Date = Date()
    @State private var note: String = ""
    @State private var selectedCategory: String = ""
    
    var body: some View {
        VStack {
            // Top Bar
            HStack {
                Button("Cancel") {}
                Spacer()
                Text("Add Transaction")
                    .font(.headline)
                Spacer()
                Spacer() // Placeholder for symmetry
            }
            .padding()
            
            // Transaction Card
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "wallet.pass") // example icon
                    Text("Cash")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                HStack {
                    Text("IDR")
                        .padding(.horizontal)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                    Text(CurrencyFormatter.format(input: amount))
                        .font(.largeTitle)
                    Spacer()
                }
                
                // Category
                HStack {
                    Circle()
                        .frame(width: 24, height: 24)
                    Text("Select category")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                
                // Note
                HStack {
                    Image(systemName: "note.text")
                    Text("Note")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                
                // Date Picker
                HStack {
                    Image(systemName: "calendar")
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden()
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal)

            // Save Button
            Button("Save") {}
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

            // Calculator
            CalculatorView(amount: $amount)
                .padding(.bottom)
        }
    }
}
