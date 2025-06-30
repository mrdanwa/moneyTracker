//HomeView.swift
//Main home tab view
//struct HomeView: View

import SwiftUI
import CoreData

// MARK: - Home View
struct HomeView: View {
    @EnvironmentObject var store: TransactionStore  // Change to EnvironmentObject
    @EnvironmentObject var accountStore: AccountStore
    @State private var showAddTransaction = false
    @State private var showMonthPicker = false
    @State private var showSearch = false
    @State private var selectedSummaryType: StatsSummaryType = .expenses
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    /// Formatter for displaying the month and year.
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let localeIdentifier: String = {
            switch selectedLanguage {
            case "Spanish": return "es"
            case "Chinese": return "zh-Hans"
            default: return "en"
            }
        }()
        formatter.locale = Locale(identifier: localeIdentifier)
        return formatter
    }
    
    /// Filters transactions for the selected month based on the selected summary type.
    private var filteredTransactions: [Transaction] {
        let transactionsForMonth = store.transactionsForSelectedMonth().filter { $0.accountId == accountStore.currentAccount.id }
        switch selectedSummaryType {
        case .income:
            return transactionsForMonth.filter { $0.type == .income }
        case .expenses:
            return transactionsForMonth.filter { $0.type == .expense }
        case .balance:
            return transactionsForMonth
        }
    }
    
    /// Returns an appropriate empty state message.
    private var emptyStateMessage: String {
        switch selectedSummaryType {
        case .income:
            return "No incomes for this month".l(selectedLanguage)
        case .expenses:
            return "No expenses for this month".l(selectedLanguage)
        case .balance:
            return "No transactions for this month".l(selectedLanguage)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Glassmorphic background.
                CustomBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Month selector with an embedded search button.
                    ZStack {
                        HStack {
                            Button {
                                showSearch = true
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .padding(10)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        
                        HStack {
                            Button {
                                store.moveMonth(by: -1)
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                            
                            Button {
                                showMonthPicker = true
                            } label: {
                                Text(dateFormatter.string(from: store.selectedDate))
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                            }
                            
                            Button {
                                store.moveMonth(by: 1)
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                        .padding(.horizontal)
                    }
                    
                    // Use the interactive summary cards (just like in StatsView)
                    InteractiveSummaryCardsView(
                        transactions: store.transactionsForSelectedMonth(),
                        selectedType: $selectedSummaryType
                    )
                    
                    // Filter the transaction list based on the selected summary type.
                    if filteredTransactions.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "tray")
                                .font(.system(size: 50))
                                .foregroundColor(.secondary)
                            Text(emptyStateMessage)
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                        .padding(.horizontal)
                    } else {
                        TransactionListView(
                            transactions: filteredTransactions,
                            store: store
                        )
                    }
                    
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
                
                // Floating button to add a new transaction.
                VStack {
                    Spacer()
                    Button {
                        showAddTransaction = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .medium))
                            Text("Add Transaction".l(selectedLanguage))
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .medium))
                        }
                        .padding()
                        .background(Color(red: 0, green: 0.5, blue: 0))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionView(store: store)
        }
        .sheet(isPresented: $showSearch) {
            SearchTransactionView(isPresented: $showSearch, store: store)
        }
        .overlay {
            if showMonthPicker {
                MonthYearPickerView(selectedDate: $store.selectedDate, showPicker: $showMonthPicker)
                    .transition(.scale)
                    .animation(.spring(), value: showMonthPicker)
            }
        }
    }
}
