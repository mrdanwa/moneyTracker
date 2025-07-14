//SearchTransactionViews.swift

import SwiftUI
import CoreData

// MARK: - Search Views
/// View for searching transactions.
struct SearchTransactionView: View {
    @Binding var isPresented: Bool
    @ObservedObject var store: TransactionStore
    @State private var searchText = ""
    @State private var fromDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var toDate = Date()
    @State private var showFromDatePicker = false
    @State private var showToDatePicker = false
    @State private var selectedFilter: TransactionType? = nil  // New state for filter
    @EnvironmentObject var accountStore: AccountStore

    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    // Transactions filtered by everything except type (for summary calculations)
    private var baseFilteredTransactions: [Transaction] {
        store.transactions.filter { transaction in
            let matchesAccount = transaction.accountId == accountStore.currentAccount.id
            let localizedCat = localizedCategory(transaction.category, language: selectedLanguage)
            let matchesSearch = searchText.isEmpty ||
                localizedCat.localizedCaseInsensitiveContains(searchText) ||
                transaction.note.localizedCaseInsensitiveContains(searchText)
            let matchesDateRange = (fromDate...toDate).contains(transaction.date)
            
            return matchesAccount && matchesSearch && matchesDateRange
        }
    }
    
    // Transactions filtered by everything including type (for display)
    private var filteredTransactions: [Transaction] {
        baseFilteredTransactions.filter { transaction in
            selectedFilter == nil || transaction.type == selectedFilter
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                CustomBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    SearchField(searchText: $searchText)
                    
                    DateRangeSelector(
                        fromDate: $fromDate,
                        toDate: $toDate,
                        showFromDatePicker: $showFromDatePicker,
                        showToDatePicker: $showToDatePicker
                    )
                    
                    SearchSummaryView(
                        transactions: baseFilteredTransactions,
                        selectedFilter: $selectedFilter
                    )
                    
                    if filteredTransactions.isEmpty {
                        EmptySearchView()
                    } else {
                        TransactionList(
                            transactions: filteredTransactions,
                            store: store
                        )
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Search Transactions".l(selectedLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color(red: 0, green: 0.5, blue: 0))
                            .font(.title2)
                    }
                }
            }
            .overlay {
                if showFromDatePicker {
                    DatePickerOverlay(
                        selectedDate: $fromDate,
                        showPicker: $showFromDatePicker,
                        maxDate: toDate
                    )
                }
                if showToDatePicker {
                    DatePickerOverlay(
                        selectedDate: $toDate,
                        showPicker: $showToDatePicker,
                        minDate: fromDate
                    )
                }
            }
        }
    }
}

struct SearchSummaryView: View {
    let transactions: [Transaction]
    @Binding var selectedFilter: TransactionType?
    @Environment(\.accountCurrency) private var selectedCurrency
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @EnvironmentObject var accountStore: AccountStore
    
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
    
    var body: some View {
        HStack(spacing: 12) {
            // Income Button
            Button(action: {
                withAnimation {
                    selectedFilter = selectedFilter == .income ? nil : .income
                }
            }) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Income".l(selectedLanguage))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(CurrencyFormatter.format(totalIncome, currencyCode: selectedCurrency))
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedFilter == .income ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                        .background(.ultraThinMaterial)
                )
            }
            
            // Expenses Button
            Button(action: {
                withAnimation {
                    selectedFilter = selectedFilter == .expense ? nil : .expense
                }
            }) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Expenses".l(selectedLanguage))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(CurrencyFormatter.format(totalExpenses, currencyCode: selectedCurrency))
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedFilter == .expense ? Color.red.opacity(0.2) : Color.gray.opacity(0.1))
                        .background(.ultraThinMaterial)
                )
            }
        }
    }
}

/// Search field view.
struct SearchField: View {
    @Binding var searchText: String
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search by category or note".l(selectedLanguage), text: $searchText)
                .textFieldStyle(.plain)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(red: 0, green: 0.5, blue: 0))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

/// Allows the user to select a date range.
struct DateRangeSelector: View {
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @Binding var showFromDatePicker: Bool
    @Binding var showToDatePicker: Bool
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    var body: some View {
        HStack {
            DateSelectorButton(
                title: "From".l(selectedLanguage),
                date: fromDate,
                showPicker: $showFromDatePicker
            )
            
            DateSelectorButton(
                title: "To".l(selectedLanguage),
                date: toDate,
                showPicker: $showToDatePicker
            )
        }
    }
}

/// A button that shows a date selector.
struct DateSelectorButton: View {
    let title: String
    let date: Date
    @Binding var showPicker: Bool
    
    var body: some View {
        Button {
            showPicker = true
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
        }
    }
}

/// Overlay view for selecting a date.
struct DatePickerOverlay: View {
    @Binding var selectedDate: Date
    @Binding var showPicker: Bool
    var minDate: Date?
    var maxDate: Date?
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    @State private var tempDate: Date
    
    init(selectedDate: Binding<Date>, showPicker: Binding<Bool>, minDate: Date? = nil, maxDate: Date? = nil) {
        _selectedDate = selectedDate
        _showPicker = showPicker
        self.minDate = minDate
        self.maxDate = maxDate
        _tempDate = State(initialValue: selectedDate.wrappedValue)
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                DatePicker(
                    "",
                    selection: $tempDate,
                    in: (minDate ?? .distantPast)...(maxDate ?? .distantFuture),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                HStack(spacing: 20) {
                    Button(action: {
                        showPicker = false
                    }) {
                        Text("Cancel".l(selectedLanguage))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2))
                            )
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: {
                        selectedDate = tempDate
                        showPicker = false
                    }) {
                        Text("Accept".l(selectedLanguage))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red: 0, green: 0.5, blue: 0))
                            )
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
            .padding()
        }
    }
}

/// View shown when no search results are found.
struct EmptySearchView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text("No matching transactions found".l(selectedLanguage))
                .font(.headline)
            Text("Try adjusting your search or date range".l(selectedLanguage))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// Updated SearchTransactionView initializer
extension SearchTransactionView {
    init(
        isPresented: Binding<Bool>,
        store: TransactionStore,
        initialSearchText: String = "",
        initialFromDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(),
        initialToDate: Date = Date(),
        initialFilter: TransactionType? = nil
    ) {
        _isPresented = isPresented
        self.store = store
        _searchText = State(initialValue: initialSearchText)
        _fromDate = State(initialValue: initialFromDate)
        _toDate = State(initialValue: initialToDate)
        _selectedFilter = State(initialValue: initialFilter)
    }
}
