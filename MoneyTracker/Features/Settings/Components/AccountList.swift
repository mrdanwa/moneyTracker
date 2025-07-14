//AccountList.swift
//struct AccountListView: View


import SwiftUI
import CoreData

// MARK: - Account List View
struct AccountListView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var accountStore: AccountStore
    @State private var showAddAccount = false
    @State private var accountToEdit: Account?
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    var body: some View {
        NavigationView {
            ZStack {
                CustomBackground()
                    .ignoresSafeArea()
                
                List {
                    ForEach(accountStore.accounts) { account in
                        AccountRow(account: account, isSelected: account.id == accountStore.currentAccount.id)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                accountStore.switchToAccount(account)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    accountToEdit = account
                                } label: {
                                    Label("Edit".l(selectedLanguage), systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                    }
                }
            }
            .navigationTitle("Accounts".l(selectedLanguage))
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
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddAccount = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color(red: 0, green: 0.5, blue: 0))
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showAddAccount) {
                AddAccountView()
            }
            .sheet(item: $accountToEdit) { account in
                EditAccountView(account: account)
            }
        }
    }
}
