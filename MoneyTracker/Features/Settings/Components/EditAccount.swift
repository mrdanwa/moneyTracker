//EditAccountView.swift
//struct EditAccountView: View

import SwiftUI
import CoreData

// MARK: - Edit Account View
import SwiftUI
import CoreData

// MARK: - Edit Account View
struct EditAccountView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var accountStore: AccountStore
    @EnvironmentObject var transactionStore: TransactionStore
    
    let account: Account
    @State private var accountName: String
    @State private var selectedCurrency: String
    @State private var showDeleteAlert = false
    @State private var showRestoreAlert = false  // New state for restore confirmation
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    let currencies = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD", "CHF", "CNY", "HKD", "SGD"]
    
    init(account: Account) {
        self.account = account
        _accountName = State(initialValue: account.name)
        _selectedCurrency = State(initialValue: account.currency)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                CustomBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Account Details Section
                        VStack(alignment: .leading, spacing: 24) {
                            // Account Name
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Account Name".l(selectedLanguage), systemImage: "creditcard.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                TextField("Account Name".l(selectedLanguage), text: $accountName)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.ultraThinMaterial)
                                    )
                            }
                            .padding(.vertical, 4)
                            
                            // Currency Selection
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Currency".l(selectedLanguage), systemImage: "banknote.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Picker("Currency".l(selectedLanguage), selection: $selectedCurrency) {
                                    ForEach(currencies, id: \.self) { currency in
                                        Text(currency).tag(currency)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.ultraThinMaterial)
                                )
                            }
                            .padding(.vertical, 4)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                        
                        // Action Buttons
                        HStack(spacing: 16) {
                            if account.isDefault {
                                // Restore button for the main account.
                                Button {
                                    showRestoreAlert = true
                                } label: {
                                    HStack {
                                        Image(systemName: "arrow.clockwise.circle.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16, weight: .medium))
                                        Text("Restore".l(selectedLanguage))
                                            .foregroundColor(.white)
                                            .font(.system(size: 16, weight: .medium))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.blue)
                                    )
                                    .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                                }
                            } else {
                                // Delete button for non-default accounts.
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
                            }
                            
                            // Update button remains available for both account types.
                            Button {
                                let updatedAccount = Account(
                                    id: account.id,
                                    name: accountName,
                                    isDefault: account.isDefault,
                                    currency: selectedCurrency,
                                    createdDate: account.createdDate
                                )
                                accountStore.updateAccount(updatedAccount)
                                dismiss()
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
                                        .fill(accountName.isEmpty ? Color.gray : Color(red: 0, green: 0.5, blue: 0))
                                )
                                .shadow(color: (accountName.isEmpty ? Color.gray : Color(red: 0, green: 0.5, blue: 0)).opacity(0.3),
                                        radius: 8, x: 0, y: 4)
                            }
                            .disabled(accountName.isEmpty)
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                }
            }
            .navigationTitle("Edit Account".l(selectedLanguage))
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
            // Alert for non-default account deletion.
            .alert("Delete Account".l(selectedLanguage), isPresented: $showDeleteAlert) {
                Button("Cancel".l(selectedLanguage), role: .cancel) { }
                Button("Delete".l(selectedLanguage), role: .destructive) {
                    accountStore.deleteAccount(account)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this account? This action cannot be undone.".l(selectedLanguage))
            }
            // Alert for restoring the main account (clearing its transactions).
            .alert("Restore Main Account".l(selectedLanguage), isPresented: $showRestoreAlert) {
                Button("Cancel".l(selectedLanguage), role: .cancel) { }
                Button("Restore".l(selectedLanguage), role: .destructive) {
                    accountStore.restoreMainAccount(account)
                    transactionStore.loadTransactions()
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete all transactions for this account? This action cannot be undone.".l(selectedLanguage))
            }
        }
    }
}
