//
//  Calculatorview.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 14/07/25.
//
import SwiftUI

struct CalculatorView: View {
    @Binding var amount: String

    let buttons: [[String]] = [
        ["C", "÷", "×", "⌫"],
        ["7", "8", "9", "−"],
        ["4", "5", "6", "+"],
        ["1", "2", "3", "Done"],
        ["0", "000", ".", ""]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { item in
                        Button(action: {
                            self.handleInput(item)
                        }) {
                            Text(item)
                                .frame(width: 70, height: 50)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
    }

    private func handleInput(_ input: String) {
        switch input {
        case "C":
            amount = "0"
        case "⌫":
            amount = String(amount.dropLast())
            if amount.isEmpty { amount = "0" }
        case "Done":
            // Add action to save or close keyboard
            break
        default:
            if amount == "0" { amount = "" }
            amount += input
        }
    }
}
