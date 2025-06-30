//CategoryBreakdown.swift
//Category breakdown component
//struct CategoryBreakdownView: View
//struct MonthData: Identifiable

import SwiftUI
import Charts
import CoreData

// MARK: - Month Data
struct MonthData: Identifiable {
    let month: Int  // 1 for January, 2 for February, etc.
    let amount: Double
    var id: Int { month }
}

// MARK: - Category Breakdown
struct CategoryBreakdownView: View {
    let transactions: [Transaction]
    let summaryType: StatsSummaryType
    @EnvironmentObject var accountStore: AccountStore
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @Environment(\.accountCurrency) private var selectedCurrency
    
    /// Filters transactions based on the summary type.
    private var relevantTransactions: [Transaction] {
        let accountTransactions = transactions.filter { $0.accountId == accountStore.currentAccount.id }
        switch summaryType {
        case .income:
            return accountTransactions.filter { $0.type == .income }
        case .expenses:
            return accountTransactions.filter { $0.type == .expense }
        case .balance:
            return accountTransactions
        }
    }
    
    /// Computes total amounts per category along with an associated color.
    private var categoryTotals: [(String, Double, Color)] {
        switch summaryType {
        case .income, .expenses:
            let grouped = Dictionary(grouping: relevantTransactions) { $0.category }
            return grouped.map { (category, trans) in
                (category, trans.reduce(0) { $0 + $1.amount }, categoryColor(for: category))
            }
            .sorted { $0.1 > $1.1 }
        case .balance:
            let income = relevantTransactions.filter { $0.type == .income }
                .reduce(0) { $0 + $1.amount }
            let expenses = relevantTransactions.filter { $0.type == .expense }
                .reduce(0) { $0 + $1.amount }
            return [
                ("Income".l(selectedLanguage), income, .green),
                ("Expenses".l(selectedLanguage), expenses, .red)
            ]
        }
    }
    
    /// Returns a color for a given category.
    private func categoryColor(for category: String) -> Color {
        switch category {
        case "Allowance":   return .mint
        case "Bonus":       return .yellow
        case "Business":    return .purple
        case "Investment":  return .orange
        case "Other":       return .gray
        case "Salary":      return .red
        case "Food":        return .red
        case "Social":      return .orange
        case "Transportation": return .cyan
        case "Household":   return .indigo
        case "Clothing":    return .pink
        case "Supermarket": return .teal
        case "Travel":      return .yellow
        case "Car":         return .blue
        case "Health":      return .green
        case "Taxes":       return .mint
        case "Shopping":    return .gray
        default:            return .gray
        }
    }
    
    // Compute the monthly aggregates (for each month that has at least one transaction)
    private var monthlyData: [MonthData] {
           var data: [MonthData] = []
           for month in 1...12 {
               let monthlyTransactions = relevantTransactions.filter {
                   Calendar.current.component(.month, from: $0.date) == month
               }
               if !monthlyTransactions.isEmpty {
                   let total: Double
                   switch summaryType {
                   case .income:
                       total = monthlyTransactions.filter { $0.type == .income }
                           .reduce(0) { $0 + $1.amount }
                   case .expenses:
                       total = monthlyTransactions.filter { $0.type == .expense }
                           .reduce(0) { $0 + $1.amount }
                   case .balance:
                       let income = monthlyTransactions.filter { $0.type == .income }
                           .reduce(0) { $0 + $1.amount }
                       let expense = monthlyTransactions.filter { $0.type == .expense }
                           .reduce(0) { $0 + $1.amount }
                       total = income - expense
                   }
                   data.append(MonthData(month: month, amount: total))
               }
           }
           return data
       }
    
    // Determine if the current transactions span more than one month (i.e. a year view).
     private var isYearView: Bool {
         let monthsGrouped = Dictionary(grouping: transactions) {
             Calendar.current.component(.month, from: $0.date)
         }
         return monthsGrouped.keys.count > 1
     }
     
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Donut chart.
                DonutChartView(data: categoryTotals)
                    .frame(height: 200)
                
                // Category list with amounts and percentages.
                VStack(spacing: 12) {
                    ForEach(categoryTotals, id: \.0) { category, amount, color in
                        HStack {
                            Circle()
                                .fill(color)
                                .frame(width: 12, height: 12)
                            
                            Text(localizedCategory(category, language: selectedLanguage))
                                .font(.system(size: 14))
                            
                            Spacer()
                            
                            Text(CurrencyFormatter.format(amount, currencyCode: selectedCurrency))
                                .font(.system(size: 14, weight: .medium))
                            
                            let total = categoryTotals.reduce(0) { $0 + $1.1 }
                            Text("(\(String(format: "%.1f", (amount / total) * 100))%)")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )
                
                // Bar chart (hidden when viewing balance).
                if summaryType != .balance {
                    SpendingChartView(transactions: relevantTransactions)
                        .frame(height: 300)
                }
                
               // When in year view, add the new monthly bar chart at the bottom.
               if isYearView, !monthlyData.isEmpty {
                   BarChartView(data: monthlyData, summaryType: summaryType)
                       .frame(height: 300)
               }
            }
            .padding()
            
            // Extra spacer.
            Section {
                Color.clear
                    .frame(height: 50)
                    .listRowBackground(Color.clear)
            }
        }
    }
}
