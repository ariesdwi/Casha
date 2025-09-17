import SwiftUI
import Domain

struct CardBalanceView: View {
    let balance: String
    let period: SpendingPeriod
    let onPeriodChange: (SpendingPeriod) -> Void
    @State private var isBalanceVisible = true
    @State private var showPeriodPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Header with period selector
            HStack {
                Text("Card Balance")
                    .font(.headline)
                
                Spacer()
                
                // Period selector button
                Button(action: { showPeriodPicker.toggle() }) {
                    HStack(spacing: 4) {
                        Text(periodTitle)
                            .font(.subheadline)
                            .foregroundColor(.cashaPrimary)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.cashaPrimary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Balance row
            HStack {
                Text(
                    isBalanceVisible ? formattedBalance : "••••••"
                )
                .font(.largeTitle.bold())
                
                Spacer()
                
                // Eye toggle button
                Button(action: toggleBalanceVisibility) {
                    Image(systemName: isBalanceVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.cashaPrimary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
        .sheet(isPresented: $showPeriodPicker) {
            PeriodPickerView(selectedPeriod: period, onPeriodSelected: { newPeriod in
                onPeriodChange(newPeriod)
                showPeriodPicker = false
            })
        }
    }
    
    private var periodTitle: String {
        switch period {
        case .thisMonth:
            return "This Month"
        case .lastThreeMonths:
            return "Last 3 Months"
        case .thisYear:
            return "This Year"
        case .allTime:
            return "All Time"
        case .custom(let interval):
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return "\(formatter.string(from: interval.start)) - \(formatter.string(from: interval.end))"
        }
    }
    
    private var formattedBalance: String {
        let numericBalance = balance.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
        
        if let amount = Double(numericBalance), amount == 0 {
            return balance
        } else {
            return "- " + balance
        }
    }
    
    private func toggleBalanceVisibility() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isBalanceVisible.toggle()
        }
    }
}

// Period Picker Sheet
struct PeriodPickerView: View {
    let selectedPeriod: SpendingPeriod
    let onPeriodSelected: (SpendingPeriod) -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section("Select Period") {
                    periodRow("This Month", period: .thisMonth)
                    periodRow("Last 3 Months", period: .lastThreeMonths)
                    periodRow("This Year", period: .thisYear)
                    periodRow("All Time", period: .allTime)
                }
            }
            .navigationTitle("Filter Period")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Dismiss automatically handled by sheet
                    }
                }
            }
        }
    }
    
    private func periodRow(_ title: String, period: SpendingPeriod) -> some View {
        Button(action: {
            onPeriodSelected(period)
        }) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                if selectedPeriod == period {
                    Image(systemName: "checkmark")
                        .foregroundColor(.cashaPrimary)
                }
            }
        }
    }
}
