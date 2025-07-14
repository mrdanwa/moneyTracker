//SpendingChart.swift
//Spending chart visualization
//struct SpendingChartView: View
//struct CategoryTotal: Identifiable

import SwiftUI
import Charts

// MARK: - Spending Chart
struct SpendingChartView: View {
    let transactions: [Transaction]
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    /// A helper struct representing category totals.
    struct CategoryTotal: Identifiable {
        let category: String
        let amount: Double
        var id: String { category }
    }
    
    /// Computes totals per category.
    private var categoryTotals: [CategoryTotal] {
        let transactionsByCategory = Dictionary(grouping: transactions) { $0.category }
        return transactionsByCategory.map { (category, trans) in
            CategoryTotal(category: category, amount: trans.reduce(0) { $0 + $1.amount })
        }
        .sorted { $0.amount > $1.amount }
    }
    
    /// Returns a color for a given category.
    private func categoryColor(for category: String) -> Color {
        switch category {
        case "Allowance":   return .mint
        case "Bonus":       return .yellow
        case "Business":    return .purple
        case "Investment":  return .orange
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
        default:            return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Chart(categoryTotals) { category in
                BarMark(
                    x: .value("Amount", category.amount),
                    y: .value("Category", localizedCategory(category.category, language: selectedLanguage))
                )
                .foregroundStyle(categoryColor(for: category.category))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
}
