//SummaryCards.swift
//Reusable summary card components
//struct SummaryCardsView: View
//struct SummaryCard: View

import SwiftUI
import CoreData

// MARK: - Interactive Summary Cards
/// Displays interactive summary cards for income, expenses, and balance.
struct InteractiveSummaryCardsView: View {
    let transactions: [Transaction]
    @Binding var selectedType: StatsSummaryType
    @EnvironmentObject var accountStore: AccountStore
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    private var totalIncome: Double {
        transactions
            .filter { $0.accountId == accountStore.currentAccount.id && $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var totalExpenses: Double {
        transactions
            .filter { $0.accountId == accountStore.currentAccount.id && $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var balance: Double {
        totalIncome - totalExpenses
    }
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ], spacing: 8) {
            // Income card.
            Button {
                selectedType = .income
            } label: {
                SummaryCard(
                    title: "Income".l(selectedLanguage),
                    amount: totalIncome,
                    icon: "arrow.down.circle.fill",
                    color: .green,
                    isSelected: selectedType == .income
                )
            }
            
            // Expenses card.
            Button {
                selectedType = .expenses
            } label: {
                SummaryCard(
                    title: "Expenses".l(selectedLanguage),
                    amount: totalExpenses,
                    icon: "arrow.up.circle.fill",
                    color: .red,
                    isSelected: selectedType == .expenses
                )
            }
            
            // Balance card.
            Button {
                selectedType = .balance
            } label: {
                SummaryCard(
                    title: "Balance".l(selectedLanguage),
                    amount: balance,
                    icon: "dollarsign.circle.fill",
                    color: balance >= 0 ? .blue : .red,
                    isSelected: selectedType == .balance
                )
            }
        }
        .padding(.horizontal, 8)
    }
}

// MARK: - Summary Cards
/// Displays summary cards (Income, Expenses, Balance) in a grid.
struct SummaryCardsView: View {
    let transactions: [Transaction]
    @EnvironmentObject var accountStore: AccountStore
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    private var totalIncome: Double {
        transactions
            .filter { $0.accountId == accountStore.currentAccount.id && $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var totalExpenses: Double {
        transactions
            .filter { $0.accountId == accountStore.currentAccount.id && $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var balance: Double {
        totalIncome - totalExpenses
    }
    
    var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 8),
                      GridItem(.flexible(), spacing: 8),
                      GridItem(.flexible(), spacing: 8)],
            spacing: 8
        ) {
            SummaryCard(
                title: "Income".l(selectedLanguage),
                amount: totalIncome,
                icon: "arrow.down.circle.fill",
                color: .green
            )
            SummaryCard(
                title: "Expenses".l(selectedLanguage),
                amount: totalExpenses,
                icon: "arrow.up.circle.fill",
                color: .red
            )
            SummaryCard(
                title: "Balance".l(selectedLanguage),
                amount: balance,
                icon: "dollarsign.circle.fill",
                color: balance >= 0 ? .blue : .red
            )
        }
        .padding(.horizontal, 8)
    }
}

/// A single summary card view.
struct SummaryCard: View {
    @Environment(\.accountCurrency) private var selectedCurrency
    
    let title: String
    let amount: Double
    let icon: String
    let color: Color
    let isSelected: Bool
    
    /// Initializes a summary card.
    init(title: String, amount: Double, icon: String, color: Color, isSelected: Bool = false) {
        self.title = title
        self.amount = amount
        self.icon = icon
        self.color = color
        self.isSelected = isSelected
    }
    
    /// Returns the formatted amount string using the CurrencyFormatter.
    private var formattedAmount: String {
        CurrencyFormatter.format(amount, currencyCode: selectedCurrency)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 2)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Text(formattedAmount)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(8)
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(isSelected ? color : .clear, lineWidth: 2)
                )
        )
    }
}
