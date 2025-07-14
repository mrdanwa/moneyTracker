//TransactionList.swift
//Transaction list component
//struct TransactionList: View

import SwiftUI
import CoreData

// MARK: - Transaction List and Rows
/// Displays a list of transactions grouped by date.
struct TransactionListView: View {
    let transactions: [Transaction]
    @ObservedObject var store: TransactionStore
    @Environment(\.accountCurrency) private var selectedCurrency
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @EnvironmentObject var accountStore: AccountStore
    
    /// Groups transactions by the start of the day.
    private var groupedTransactions: [(Date, [Transaction])] {
        // Filter transactions for current account first
        let accountTransactions = transactions.filter { $0.accountId == accountStore.currentAccount.id }
        let grouped = Dictionary(grouping: accountTransactions) {
            Calendar.current.startOfDay(for: $0.date)
        }
        return grouped.map { ($0.key, $0.value.sorted { $0.date > $1.date }) }
            .sorted { $0.0 > $1.0 }
    }
    
    /// Calculates daily income and expense totals.
    private func dailyTotals(for transactions: [Transaction]) -> (income: Double, expenses: Double) {
        let income = transactions.filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
        let expenses = transactions.filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
        return (income, expenses)
    }
    
    var body: some View {
        List {
            ForEach(groupedTransactions, id: \.0) { date, trans in
                Section(
                    header: HStack {
                        // Determine the locale based on the selected language.
                        let localeIdentifier: String = {
                            switch selectedLanguage {
                            case "Spanish":
                                return "es"
                            case "Chinese":
                                return "zh-Hans"
                            default:
                                return "en"
                            }
                        }()
                        
                        // Format the weekday and day.
                        let weekday = date.formatted(.dateTime.weekday(.wide)
                            .locale(Locale(identifier: localeIdentifier)))
                        let day = Calendar.current.component(.day, from: date)
                        
                        Text("\(weekday), \(day)")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Daily totals for income and expenses.
                        let totals = dailyTotals(for: trans)
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                if totals.income > 0 {
                                    Image(systemName: "arrow.up")
                                        .foregroundColor(.green)
                                        .font(.system(size: 12, weight: .medium))
                                    Text(CurrencyFormatter.format(totals.income,
                                                                  currencyCode: selectedCurrency))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.green)
                                }
                            }
                            if totals.expenses > 0 {
                                HStack(spacing: 4) {
                                    Image(systemName: "arrow.down")
                                        .foregroundColor(.red)
                                        .font(.system(size: 12, weight: .medium))
                                    Text(CurrencyFormatter.format(totals.expenses,
                                                                  currencyCode: selectedCurrency))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.red)
                                }
                            }
                        }
                    }
                ) {
                    ForEach(trans) { transaction in
                        TransactionRow(transaction: transaction, store: store)
                    }
                }
            }
            
            // Extra spacer section.
            Section {
                Color.clear
                    .frame(height: 50)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(PlainListStyle())
        .background(.clear)
    }
}


// MARK: - Transaction List
struct TransactionList: View {
    let transactions: [Transaction]
    let store: TransactionStore
    
    var body: some View {
        List {
            ForEach(transactions) { transaction in
                TransactionRow(transaction: transaction, store: store)
            }
        }
        .listStyle(PlainListStyle())
        .background(.clear)
    }
}
