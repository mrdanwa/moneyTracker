//AccountRow.swift
//struct AccountRow: View

import SwiftUI
import CoreData

// MARK: - Account Row View
struct AccountRow: View {
    let account: Account
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(account.name)
                    .font(.headline)
                Text(account.currency)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(red: 0, green: 0.5, blue: 0))
            }
        }
        .padding(.vertical, 4)
    }
}
