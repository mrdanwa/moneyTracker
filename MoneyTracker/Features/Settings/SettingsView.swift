//SettingsView.swift
//Main settings view
//struct SettingsView: View

import SwiftUI
import CoreData

// MARK: - Settings View
struct SettingsView: View {
    @EnvironmentObject private var accountStore: AccountStore
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var showAccountList = false
    
    @EnvironmentObject private var store: TransactionStore
    @State private var showingExporter = false
    @State private var showingImporter = false
    @State private var showingErrorAlert = false
    @State private var showingFormatAlert = false
    @State private var errorMessage = ""
    @State private var csvContent = ""
    
    let languages = ["English", "Spanish", "Chinese"]
    
    private var csvFormatMessage: String {
        "Requirements".l(selectedLanguage)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                CustomBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Current Account Section
                        VStack(alignment: .leading, spacing: 20) {
                            Button {
                                showAccountList = true
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Accounts".l(selectedLanguage))
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Text(accountStore.currentAccount.name)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                        
                        // Global Language Section
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("Language".l(selectedLanguage))
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Picker("", selection: $selectedLanguage) {
                                    ForEach(languages, id: \.self) { lang in
                                        Text(lang.l(lang)).tag(lang)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(.primary)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                        
                        // Appearance Section
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("Appearance".l(selectedLanguage))
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Toggle("Dark Mode".l(selectedLanguage), isOn: $isDarkMode)
                                    .labelsHidden()
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                        // Data Management Section
                        VStack(alignment: .leading, spacing: 20) {
                            Menu {
                                Button {
                                    csvContent = BackupManager.shared.exportToCSV(
                                        transactions: store.transactions,
                                        accounts: accountStore.accounts
                                    )
                                    showingExporter = true
                                } label: {
                                    Label("Export CSV".l(selectedLanguage), systemImage: "square.and.arrow.up")
                                }
                                
                                Button {
                                    showingFormatAlert = true
                                } label: {
                                    Label("Import CSV".l(selectedLanguage), systemImage: "square.and.arrow.down")
                                }
                            } label: {
                                HStack {
                                    Text("Backup".l(selectedLanguage))
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("Settings".l(selectedLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .sheet(isPresented: $showAccountList) {
                AccountListView()
            }
            .alert("CSV Format Requirements".l(selectedLanguage), isPresented: $showingFormatAlert) {
                Button("Cancel".l(selectedLanguage), role: .cancel) { }
                Button("Continue".l(selectedLanguage)) {
                    showingImporter = true
                }
            } message: {
                Text(csvFormatMessage)
            }
            .fileExporter(
                isPresented: $showingExporter,
                document: CSVDocument(text: csvContent),
                contentType: .commaSeparatedText,
                defaultFilename: "transactions.csv"
            ) { result in
                switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .fileImporter(
                isPresented: $showingImporter,
                allowedContentTypes: [.commaSeparatedText]
            ) { result in
                switch result {
                case .success(let url):
                    guard url.startAccessingSecurityScopedResource() else { return }
                    defer { url.stopAccessingSecurityScopedResource() }
                    
                    do {
                        let csvData = try String(contentsOf: url, encoding: .utf8)
                        try BackupManager.shared.importFromCSV(csvData, accountStore: accountStore, transactionStore: store)
                    } catch {
                        errorMessage = error.localizedDescription
                        showingErrorAlert = true
                    }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    showingErrorAlert = true
                }
            }
            .alert("Import Error".l(selectedLanguage), isPresented: $showingErrorAlert) {
                Button("OK".l(selectedLanguage), role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
}


