//TransactionRow.swift
//Individual transaction row
//struct TransactionRow: View

import SwiftUI
import CoreData

// MARK: - Transaction Row
struct TransactionRow: View {
    let transaction: Transaction
    @EnvironmentObject var accountStore: AccountStore
    @ObservedObject var store: TransactionStore
    @Environment(\.accountCurrency) private var selectedCurrency
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @State private var showEditSheet = false
    
    private var isCurrentAccountTransaction: Bool {
        transaction.accountId == accountStore.currentAccount.id
    }
    
    /// Determines the icon to display based on the transaction category.
    private var categoryIcon: String {
        switch transaction.category {
        case "Allowance":   return "gift.fill"
        case "Bonus":       return "star.circle.fill"
        case "Business":    return "briefcase.fill"
        case "Investment":  return "chart.line.uptrend.xyaxis"
        case "Salary":      return "dollarsign.circle.fill"
        case "Car":         return "car.fill"
        case "Clothing":    return "tshirt.fill"
        case "Food":        return "fork.knife"
        case "Health":      return "heart.fill"
        case "Household":   return "house.fill"
        case "Social":      return "person.2.fill"
        case "Supermarket": return "bag.fill"
        case "Taxes":       return "percent"
        case "Transportation": return "bus.fill"
        case "Travel":      return "airplane"
        case "Shopping":    return "cart.fill"
        case "Other":       return "questionmark.circle.fill"
        default:            return "circle.fill"
        }
    }
    
    var body: some View {
        if isCurrentAccountTransaction {
            Button {
                showEditSheet = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: categoryIcon)
                        .font(.title3)
                        .foregroundColor(transaction.type == .income ? .green : .red)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(.ultraThinMaterial))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(localizedCategory(transaction.category, language: selectedLanguage))
                            .font(.system(size: 14, weight: .medium))
                        if !transaction.note.isEmpty {
                            Text(transaction.note)
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                    
                    Text(CurrencyFormatter.format(transaction.amount, currencyCode: selectedCurrency))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(transaction.type == .income ? .green : .red)
                }
                .padding(.vertical, 2)
            }
            .sheet(isPresented: $showEditSheet) {
                EditTransactionView(store: store, transaction: transaction)
            }
            .listRowBackground(Color.clear)
        }
    }
}
