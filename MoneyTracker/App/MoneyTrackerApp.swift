//MoneyApp.swift
//Main app entry point
//@main struct MoneyApp: App

import SwiftUI
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "MoneyTracker")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}

@main
struct MoneyTrackerApp: App {
    @StateObject private var accountStore: AccountStore
    @StateObject private var transactionStore: TransactionStore
    let persistenceController = PersistenceController.shared
    
    init() {
        // Initialize accountStore first
        let accountStore = AccountStore()
        _accountStore = StateObject(wrappedValue: accountStore)
        
        // Initialize transactionStore with accountStore
        let transactionStore = TransactionStore(accountStore: accountStore)
        _transactionStore = StateObject(wrappedValue: transactionStore)
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(accountStore)
                .environmentObject(transactionStore)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

#Preview {
    let accountStore = AccountStore()
    let transactionStore = TransactionStore(accountStore: accountStore)
    
    return SplashScreen()
        .environmentObject(accountStore)
        .environmentObject(transactionStore)
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
