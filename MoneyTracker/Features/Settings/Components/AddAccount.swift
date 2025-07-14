//EditAccount.swift
//struct EditAccountView: View

import SwiftUI
import CoreData

// MARK: - Add Account View
struct AddAccountView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var accountStore: AccountStore
    
    @State private var accountName = ""
    @State private var selectedCurrency = "USD"
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    let currencies = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD", "CHF", "CNY", "HKD", "SGD"]
    
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
                        
                        // Create Button
                        Button {
                            let newAccount = Account(
                                name: accountName,
                                currency: selectedCurrency
                            )
                            accountStore.addAccount(newAccount)
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                                Text("Create Account".l(selectedLanguage))
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
                        .padding(.top, 8)
                    }
                    .padding()
                }
            }
            .navigationTitle("New Account".l(selectedLanguage))
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
        }
    }
}
