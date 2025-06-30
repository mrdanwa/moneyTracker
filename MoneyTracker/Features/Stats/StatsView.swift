//StatsView.swift
//Main stats tab view
//struct StatsView: View
//enum ViewMode

import SwiftUI
import Charts
import CoreData

// MARK: - ViewMode
private enum ViewMode {
    case month
    case year
}

// MARK: - Stats View
struct StatsView: View {
    @EnvironmentObject var store: TransactionStore
    @EnvironmentObject var accountStore: AccountStore
    @State private var showAddTransaction = false
    @State private var showMonthPicker = false
    @State private var showSearch = false
    @State private var selectedSummaryType: StatsSummaryType = .expenses
    @State private var viewMode: ViewMode = .month

    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    // Formatter for month-year.
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

    // Formatter for year.
    private var yearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
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
    
    /// Filters transactions based on the selected date (month or year).
    private var relevantTransactions: [Transaction] {
        let accountTransactions = store.transactions.filter { $0.accountId == accountStore.currentAccount.id }
        let calendar = Calendar.current
        return accountTransactions.filter { transaction in
            switch viewMode {
            case .month:
                return calendar.isDate(transaction.date, equalTo: store.selectedDate, toGranularity: .month) &&
                       calendar.isDate(transaction.date, equalTo: store.selectedDate, toGranularity: .year)
            case .year:
                return calendar.isDate(transaction.date, equalTo: store.selectedDate, toGranularity: .year)
            }
        }
    }
    
    /// Further filters transactions based on the selected summary type.
    private var filteredSummaryTransactions: [Transaction] {
          switch selectedSummaryType {
          case .income:
              return relevantTransactions.filter { $0.type == .income }
          case .expenses:
              return relevantTransactions.filter { $0.type == .expense }
          case .balance:
              return relevantTransactions
          }
      }
    
    /// Returns the appropriate empty state message.
    private var emptyStateMessage: String {
        switch selectedSummaryType {
        case .income:
            return viewMode == .month
                ? "No incomes for this month".l(selectedLanguage)
                : "No incomes for this year".l(selectedLanguage)
        case .expenses:
            return viewMode == .month
                ? "No expenses for this month".l(selectedLanguage)
                : "No expenses for this year".l(selectedLanguage)
        case .balance:
            return viewMode == .month
                ? "No transactions for this month".l(selectedLanguage)
                : "No transactions for this year".l(selectedLanguage)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                CustomBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // MARK: - Header: Month/Year Selector, Search, and Toggle
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
                            
                            Button {
                                withAnimation {
                                    viewMode = viewMode == .month ? .year : .month
                                    showMonthPicker = false
                                }
                            } label: {
                                Image(systemName: viewMode == .month ? "m.square.fill" : "y.square.fill")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .padding(10)
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        HStack {
                            Button {
                                switch viewMode {
                                case .month:
                                    store.moveMonth(by: -1)
                                case .year:
                                    if let newDate = Calendar.current.date(byAdding: .year, value: -1, to: store.selectedDate) {
                                        store.selectedDate = newDate
                                    }
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                            
                            Button {
                                if viewMode == .month {
                                    showMonthPicker = true
                                }
                            } label: {
                                Text(viewMode == .month
                                     ? dateFormatter.string(from: store.selectedDate)
                                     : yearFormatter.string(from: store.selectedDate))
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                            }
                            
                            Button {
                                switch viewMode {
                                case .month:
                                    store.moveMonth(by: 1)
                                case .year:
                                    if let newDate = Calendar.current.date(byAdding: .year, value: 1, to: store.selectedDate) {
                                        store.selectedDate = newDate
                                    }
                                }
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
                    
                    // MARK: - Interactive Summary Cards
                    InteractiveSummaryCardsView(
                        transactions: relevantTransactions,
                        selectedType: $selectedSummaryType
                    )
                    
                    // MARK: - Category Breakdown or Empty State
                    if filteredSummaryTransactions.isEmpty {
                        // When there are no transactions of the selected type, show an empty state.
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
                        // Show the breakdown view if there are transactions.
                        CategoryBreakdownView(
                            transactions: relevantTransactions,
                            summaryType: selectedSummaryType
                        )
                    }
                    
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
                
                // MARK: - Floating Add Transaction Button
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
            if showMonthPicker && viewMode == .month {
                MonthYearPickerView(selectedDate: $store.selectedDate, showPicker: $showMonthPicker)
                    .transition(.scale)
                    .animation(.spring(), value: showMonthPicker)
            }
        }
    }
}
