//TransactionStore.swift
//Transaction management and business logic
//class TransactionStore: ObservableObject
//enum StatsSummaryType

import SwiftUI
import CoreData

enum StatsSummaryType {
    case income
    case expenses
    case balance
}

// MARK: - Transaction Store
class TransactionStore: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var selectedDate: Date = Date()
    
    private let accountStore: AccountStore
    private let context: NSManagedObjectContext
    
    init(accountStore: AccountStore) {
        self.accountStore = accountStore
        self.context = CoreDataStack.shared.persistentContainer.viewContext
        loadTransactions()
    }
    
    func loadTransactions() {
        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "accountId == %@", accountStore.currentAccount.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            transactions = results.map { Transaction.fromManagedObject($0) }
        } catch {
            print("Error fetching transactions: \(error)")
        }
    }
    
    func addTransaction(_ transaction: Transaction) {
        let newTransaction = TransactionEntity(context: context)
        newTransaction.id = transaction.id
        newTransaction.accountId = transaction.accountId
        newTransaction.type = transaction.type.rawValue
        newTransaction.category = transaction.category
        newTransaction.amount = transaction.amount
        newTransaction.note = transaction.note
        newTransaction.date = transaction.date
        
        do {
            try context.save()
            loadTransactions()
        } catch {
            print("Error saving transaction: \(error)")
        }
    }
    
    func updateTransaction(_ transaction: Transaction) {
        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", transaction.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existingTransaction = results.first {
                existingTransaction.type = transaction.type.rawValue
                existingTransaction.category = transaction.category
                existingTransaction.amount = transaction.amount
                existingTransaction.note = transaction.note
                existingTransaction.date = transaction.date
                
                try context.save()
                loadTransactions()
            }
        } catch {
            print("Error updating transaction: \(error)")
        }
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", transaction.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let transactionToDelete = results.first {
                context.delete(transactionToDelete)
                try context.save()
                loadTransactions()
            }
        } catch {
            print("Error deleting transaction: \(error)")
        }
    }
    
    func switchToAccount(_ account: Account) {
        loadTransactions()
    }
    
    func transactionsForSelectedMonth() -> [Transaction] {
        let calendar = Calendar.current
        return transactions.filter {
            calendar.isDate($0.date, equalTo: selectedDate, toGranularity: .month) &&
            calendar.isDate($0.date, equalTo: selectedDate, toGranularity: .year)
        }
    }
    
    func moveMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }
}
