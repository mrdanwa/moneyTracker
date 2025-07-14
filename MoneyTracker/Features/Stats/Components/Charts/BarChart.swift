//BarChart.swift
//Bar chart visualization
//struct BarChartView: View

import SwiftUI
import Charts

// MARK: - Bar Chart
struct BarChartView: View {
    let data: [MonthData]
    let summaryType: StatsSummaryType
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @Environment(\.accountCurrency) private var selectedCurrency
    
    // Returns the localized month name for a given month number.
    private func monthName(for month: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        return formatter.monthSymbols[month - 1]
    }
    
    private var localeIdentifier: String {
        switch selectedLanguage {
        case "Spanish": return "es"
        case "Chinese": return "zh-Hans"
        default: return "en"
        }
    }
    
    // Chooses a bar color based on the summary type.
    private func barColor(for amount: Double) -> Color {
        switch summaryType {
        case .income:
            return .green
        case .expenses:
            return .red
        case .balance:
            return amount >= 0 ? .blue : .red
        }
    }
    
    var body: some View {
        Chart {
            ForEach(data) { monthData in
                BarMark(
                    x: .value("Month", monthName(for: monthData.month)),
                    y: .value("Amount", monthData.amount)
                )
                .foregroundStyle(barColor(for: monthData.amount))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
}

