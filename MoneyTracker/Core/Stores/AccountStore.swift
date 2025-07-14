//AccountStore.swift
//Account management and persistence
//class AccountStore: ObservableObject

import SwiftUI
import CoreData

// MARK: - Account Store
class AccountStore: ObservableObject {
    @Published var accounts: [Account] = [] {
        didSet { saveAccounts() }
    }
    
    @Published var currentAccount: Account {
        didSet {
            UserDefaults.standard.set(currentAccount.id.uuidString, forKey: "currentAccountId")
        }
    }
    
    private let accountsKey = "savedAccounts"
    
    init() {
        // Load or create default account
        if let data = UserDefaults.standard.data(forKey: accountsKey),
           let decoded = try? JSONDecoder().decode([Account].self, from: data),
           !decoded.isEmpty {
            self.accounts = decoded
            
            // Set current account
            if let currentAccountId = UserDefaults.standard.string(forKey: "currentAccountId"),
               let uuid = UUID(uuidString: currentAccountId),
               let account = decoded.first(where: { $0.id == uuid }) {
                self.currentAccount = account
            } else {
                self.currentAccount = decoded.first(where: { $0.isDefault }) ?? decoded[0]
            }
        } else {
            // Create default account if no accounts exist
            let defaultAccount = Account(
                name: "Main Account",
                isDefault: true,
                currency: "USD"
            )
            self.accounts = [defaultAccount]
            self.currentAccount = defaultAccount
            saveAccounts()
        }
    }
    
    private func saveAccounts() {
        if let encoded = try? JSONEncoder().encode(accounts) {
            UserDefaults.standard.set(encoded, forKey: accountsKey)
        }
    }
    
    func addAccount(_ account: Account) {
        accounts.append(account)
    }
    
    func updateAccount(_ account: Account) {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            var updatedAccount = account
            updatedAccount.lastModified = Date()
            accounts[index] = updatedAccount
            
            // Update currentAccount if it's the one being modified
            if currentAccount.id == account.id {
                currentAccount = updatedAccount
            }
        }
    }
    
    // Updated deleteAccount method with transaction cleanup
    func deleteAccount(_ account: Account) {
        guard !account.isDefault else { return }
        
        // 1. Remove account from the array
        accounts.removeAll(where: { $0.id == account.id })
        
        // 2. Remove the account's transactions from Core Data
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "accountId == %@", account.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            for transaction in results {
                context.delete(transaction)
            }
            try context.save()
        } catch {
            print("Error removing transactions for account: \(error)")
        }
        
        // 3. If the deleted account was current, switch to a default or the first remaining account
        if currentAccount.id == account.id {
            if let defaultAccount = accounts.first(where: { $0.isDefault }) {
                currentAccount = defaultAccount
            } else if let firstAccount = accounts.first {
                currentAccount = firstAccount
            }
        }
    }
    
    func restoreMainAccount(_ account: Account) {
        // Ensure this is only used for the main (default) account.
        guard account.isDefault else { return }
        
        // Remove only the account's transactions from Core Data.
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "accountId == %@", account.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            for transaction in results {
                context.delete(transaction)
            }
            try context.save()
        } catch {
            print("Error removing transactions for main account: \(error)")
        }
    }
    
    
    func switchToAccount(_ account: Account) {
        guard let account = accounts.first(where: { $0.id == account.id }) else { return }
        currentAccount = account
    }
}
