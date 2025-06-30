//Transaction.swift
//Transaction model and CoreData entities
//struct Transaction: Identifiable, Codable
//enum TransactionType: String, Codable
//class CoreDataStack

import SwiftUI
import CoreData

// MARK: - Transaction Type
enum TransactionType: String, Codable {
    case income
    case expense
}

// MARK: - Transaction
struct Transaction: Identifiable, Codable {
    let id: UUID
    let accountId: UUID  // New property
    let type: TransactionType
    let category: String
    let amount: Double
    let note: String
    let date: Date
    
    init(id: UUID = UUID(),
         accountId: UUID,  // New required parameter
         type: TransactionType,
         category: String,
         amount: Double,
         note: String,
         date: Date = Date()) {
        self.id = id
        self.accountId = accountId
        self.type = type
        self.category = category
        self.amount = amount
        self.note = note
        self.date = date
    }
}

extension Transaction {
    // Convert Core Data managed object to Transaction model
    static func fromManagedObject(_ object: TransactionEntity) -> Transaction {
        return Transaction(
            id: object.id ?? UUID(),
            accountId: object.accountId ?? UUID(),
            type: TransactionType(rawValue: object.type ?? "") ?? .expense,
            category: object.category ?? "",
            amount: object.amount,
            note: object.note ?? "",
            date: object.date ?? Date()
        )
    }
}

// MARK: - Core Data Stack
class CoreDataStack {
    static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "MoneyTracker")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved Core Data error: \(error), \(error.userInfo)")
            }
        }
    }
}

