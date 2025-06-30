import Foundation
import SwiftUI
import UniformTypeIdentifiers

// MARK: - CSV Data Structure
struct CSVTransaction {
    let account: String
    let type: String
    let category: String
    let amount: Double
    let currency: String
    let date: Date
    let note: String
    
    static let expectedHeaders = ["Account", "Type", "Category", "Amount", "Currency", "Date", "Note"]
}

// MARK: - Backup Manager
class BackupManager: ObservableObject {
    static let shared = BackupManager()
    private let dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    // MARK: - Export
    func exportToCSV(transactions: [Transaction], accounts: [Account]) -> String {
        var csvString = "\(CSVTransaction.expectedHeaders.joined(separator: ","))\n"
        
        for transaction in transactions {
            let account = accounts.first { $0.id == transaction.accountId }
            let row = [
                account?.name ?? "",
                transaction.type.rawValue,
                transaction.category,
                String(transaction.amount),
                account?.currency ?? "USD",
                dateFormatter.string(from: transaction.date),
                transaction.note.replacingOccurrences(of: ",", with: ";")
            ]
            csvString += row.joined(separator: ",") + "\n"
        }
        
        return csvString
    }
    
    // MARK: - Import
    func importFromCSV(_ csvString: String, accountStore: AccountStore, transactionStore: TransactionStore) throws {
        let rows = csvString.components(separatedBy: .newlines)
        guard !rows.isEmpty else { throw BackupError.emptyFile }
        
        // Validate headers
        let headers = rows[0].components(separatedBy: ",")
        guard headers == CSVTransaction.expectedHeaders else {
            throw BackupError.invalidHeaders(expected: CSVTransaction.expectedHeaders, found: headers)
        }
        
        // Process transactions
        for row in rows.dropFirst() where !row.isEmpty {
            let columns = row.components(separatedBy: ",")
            guard columns.count == CSVTransaction.expectedHeaders.count else { continue }
            
            let accountName = columns[0]
            let typeString = columns[1]
            let category = columns[2]
            let amountString = columns[3]
            let currency = columns[4]
            let dateString = columns[5]
            let note = columns[6].replacingOccurrences(of: ";", with: ",")
            
            // Validate and convert data
            guard let type = TransactionType(rawValue: typeString),
                  let amount = Double(amountString),
                  let date = dateFormatter.date(from: dateString) else {
                continue
            }
            
            // Find or create account
            var account = accountStore.accounts.first { $0.name == accountName }
            if account == nil {
                let validCurrencies = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD", "CHF", "CNY", "HKD", "SGD"]
                let normalizedCurrency = currency.uppercased()
                let finalCurrency = validCurrencies.contains(normalizedCurrency) ? normalizedCurrency : "USD"
                
                account = Account(
                    name: accountName,
                    currency: finalCurrency
                )
                accountStore.addAccount(account!)
            }
            
            // Validate category
            let validCategories = type == .income ?
            ["Allowance", "Bonus", "Business", "Investment", "Other", "Salary"] :
            ["Business", "Car", "Clothing", "Food", "Health", "Household", "Other", "Social", "Supermarket", "Taxes", "Transportation", "Travel"]
            
            let finalCategory = validCategories.contains(category) ? category : "Other"
            
            // Create transaction
            let transaction = Transaction(
                accountId: account!.id,
                type: type,
                category: finalCategory,
                amount: amount,
                note: note,
                date: date
            )
            
            transactionStore.addTransaction(transaction)
        }
    }
    
}

// MARK: - Backup Errors
enum BackupError: LocalizedError {
    case emptyFile
    case invalidHeaders(expected: [String], found: [String])
    
    var errorDescription: String? {
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "English"
        
        switch self {
        case .emptyFile:
            return "EmptyFileError".l(currentLanguage)
        case .invalidHeaders(let expected, let found):
            return String(
                format: "InvalidHeadersError".l(currentLanguage),
                expected.joined(separator: ", "),
                found.joined(separator: ", ")
            )
        }
    }
}

// MARK: - Document Picker Helper
struct CSVDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }
    static var writableContentTypes: [UTType] { [.commaSeparatedText] }
    
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}


