//CurrencyFormatter.swift
//Currency formatting utilities
//struct CurrencyFormatter

import SwiftUI
import CoreData

// MARK: - Currency Formatter
struct CurrencyFormatter {
    /// Formats a given numeric amount into a currency string using the specified currency code.
    /// - Parameters:
    ///   - amount: The numeric amount.
    ///   - currencyCode: The ISO currency code (e.g., "USD").
    /// - Returns: A localized currency string.
    static func format(_ amount: Double, currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        // Use the currency symbol from our extension.
        formatter.currencySymbol = currencyCode.currencySymbol
        
        // For larger amounts, we show no decimal places.
        if abs(amount) >= 10000 {
            formatter.maximumFractionDigits = 0
        } else {
            formatter.maximumFractionDigits = 2
        }
        
        return formatter.string(from: NSNumber(value: amount)) ?? "0"
    }
}

// MARK: - Currency Helpers
extension String {
    var currencySymbol: String {
        switch self {
        case "USD": return "$"
        case "EUR": return "€"
        case "GBP": return "£"
        case "JPY": return "¥"
        case "CNY": return "¥"
        case "CAD": return "$"
        case "AUD": return "$"
        case "CHF": return "₣"
        case "HKD": return "$"
        case "SGD": return "$"
        default:    return self
        }
    }
}

extension EnvironmentValues {
    var accountCurrency: String {
        get { self[AccountCurrencyKey.self] }
        set { self[AccountCurrencyKey.self] = newValue }
    }
}
