//EditTransaction.swift


import SwiftUI
import CoreData

// MARK: - Edit Transaction Views
struct EditTransactionView: View {
    @ObservedObject var store: TransactionStore
    @EnvironmentObject var accountStore: AccountStore
    @Environment(\.dismiss) var dismiss
    let transaction: Transaction
    
    @State private var selectedType: TransactionType
    @State private var selectedCategory: String
    @State private var note: String
    @State private var date: Date
    @State private var showDeleteAlert = false
    @State private var amount: String
    @State private var showDatePicker = false
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    // Categories grouped by transaction type.
    private let categories = [
        "Income": ["Allowance", "Bonus", "Business", "Investment", "Salary", "Other"],
        "Expense": ["Business", "Car", "Clothing", "Food", "Health", "Household", "Shopping", "Social", "Supermarket", "Taxes", "Transportation", "Travel", "Other"]
    ]
    
    
    /// Initializes the view with the transaction to edit.
    init(store: TransactionStore, transaction: Transaction) {
        self.store = store
        self.transaction = transaction
        _selectedType = State(initialValue: transaction.type)
        _selectedCategory = State(initialValue: transaction.category)
        _amount = State(initialValue: String(format: "%.2f", transaction.amount).replacingOccurrences(of: ".", with: ","))
        _note = State(initialValue: transaction.note)
        _date = State(initialValue: transaction.date)
    }
    
    /// Binding for the formatted amount input.
    private var formattedAmount: Binding<String> {
        Binding(
            get: { amount },
            set: { newValue in
                let standardized = newValue.replacingOccurrences(of: ",", with: ".")
                let filtered = standardized.filter { "0123456789.".contains($0) }
                let components = filtered.split(separator: ".", maxSplits: 1)
                
                if components.count > 1 {
                    let wholePart = components[0]
                    var decimalPart = String(components[1])
                    if decimalPart.count > 2 {
                        decimalPart = String(decimalPart.prefix(2))
                    } else if decimalPart.count < 2 {
                        decimalPart += String(repeating: "0", count: 2 - decimalPart.count)
                    }
                    amount = "\(wholePart),\(decimalPart)"
                } else if !filtered.isEmpty {
                    amount = "\(filtered),00"
                } else {
                    amount = ""
                }
            }
        )
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                CustomBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Transaction Type.
                        VStack(alignment: .leading, spacing: 12) {
                            Picker("Type", selection: $selectedType) {
                                Text("Expense".l(selectedLanguage)).tag(TransactionType.expense)
                                Text("Income".l(selectedLanguage)).tag(TransactionType.income)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(8)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                        
                        // Details.
                        VStack(alignment: .leading, spacing: 24) {
                            // Category selection.
                            HStack {
                                Label("Category".l(selectedLanguage), systemImage: "folder.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Picker("", selection: $selectedCategory) {
                                    ForEach(categories[selectedType == .income ? "Income" : "Expense"]!, id: \.self) {
                                        Text(localizedCategory($0, language: selectedLanguage)).tag($0)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(.primary)
                            }
                            .padding(.vertical, 4)
                            
                            // Amount input.
                            HStack {
                                Label("Amount".l(selectedLanguage), systemImage: "banknote.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                TextField("0,00", text: formattedAmount)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: 120)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.ultraThinMaterial)
                                    )
                                    .font(.system(.body, design: .rounded))
                            }
                            .padding(.vertical, 4)
                            
                            // Date selection.
                            HStack {
                                Label("Date".l(selectedLanguage), systemImage: "calendar")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Button {
                                    showDatePicker = true
                                } label: {
                                    Text(date, style: .date)
                                        .foregroundColor(.primary)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(.ultraThinMaterial)
                                        )
                                }
                            }
                            .padding(.vertical, 4)
                            
                            // Note input.
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Note".l(selectedLanguage), systemImage: "note.text")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                TextField("Add note", text: $note, axis: .vertical)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.ultraThinMaterial)
                                    )
                                    .lineLimit(3...6)
                            }
                            .padding(.vertical, 4)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                        
                        // Action Buttons.
                        HStack(spacing: 16) {
                            // Delete button.
                            Button {
                                showDeleteAlert = true
                            } label: {
                                HStack {
                                    Image(systemName: "trash.circle.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Delete".l(selectedLanguage))
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.red)
                                )
                                .shadow(color: Color.red.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            
                            // Update button.
                            Button {
                                updateTransaction()
                            } label: {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Update".l(selectedLanguage))
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedCategory.isEmpty || amount.isEmpty ? Color.gray : Color(red: 0, green: 0.5, blue: 0))
                                )
                                .shadow(color: (selectedCategory.isEmpty || amount.isEmpty ? Color.gray : Color(red: 0, green: 0.5, blue: 0)).opacity(0.3),
                                        radius: 8, x: 0, y: 4)
                            }
                            .disabled(selectedCategory.isEmpty || amount.isEmpty)
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                }
            }
            .navigationTitle("Edit Transaction".l(selectedLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color(red: 0, green: 0.5, blue: 0))
                            .font(.title2)
                    }
                }
            }
            .alert("Delete Transaction".l(selectedLanguage), isPresented: $showDeleteAlert) {
                Button("Cancel".l(selectedLanguage), role: .cancel) { }
                Button("Delete".l(selectedLanguage), role: .destructive) {
                    store.deleteTransaction(transaction)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this transaction? This action cannot be undone.".l(selectedLanguage))
            }
            .overlay {
                if showDatePicker {
                    DatePickerOverlay(selectedDate: $date, showPicker: $showDatePicker)
                }
            }
        }
    }
    
    /// Updates the transaction with the new values.
    private func updateTransaction() {
        let standardAmount = amount.replacingOccurrences(of: ",", with: ".")
        guard let amountDouble = Double(standardAmount) else { return }
        
        let updated = Transaction(
            id: transaction.id,
            accountId: transaction.accountId,  // Preserve original account ID
            type: selectedType,
            category: selectedCategory,
            amount: amountDouble,
            note: note,
            date: date
        )
        
        store.updateTransaction(updated)
        dismiss()
    }
}
