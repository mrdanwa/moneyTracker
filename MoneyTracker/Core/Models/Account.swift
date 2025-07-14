//Account.swift
//Account model and related types
//struct Account: Identifiable, Codable, Equatable
//struct AccountCurrencyKey: EnvironmentKey

import SwiftUI
import CoreData

// MARK: - Account
struct Account: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    let isDefault: Bool
    var currency: String
    let createdDate: Date
    var lastModified: Date
    
    init(id: UUID = UUID(),
         name: String,
         isDefault: Bool = false,
         currency: String = "USD",
         createdDate: Date = Date(),
         lastModified: Date = Date()) {
        self.id = id
        self.name = name
        self.isDefault = isDefault
        self.currency = currency
        self.createdDate = createdDate
        self.lastModified = lastModified
    }
    
    // Add explicit Equatable conformance
    static func == (lhs: Account, rhs: Account) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.isDefault == rhs.isDefault &&
        lhs.currency == rhs.currency &&
        lhs.createdDate == rhs.createdDate &&
        lhs.lastModified == rhs.lastModified
    }
}

// MARK: - Account Currency Key
struct AccountCurrencyKey: EnvironmentKey {
    static let defaultValue: String = "USD"
}


