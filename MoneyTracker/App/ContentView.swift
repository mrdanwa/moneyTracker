//ContentView.swift

import SwiftUI
import CoreData

// MARK: - ContentView
struct ContentView: View {
    @EnvironmentObject private var accountStore: AccountStore
    @EnvironmentObject private var store: TransactionStore
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    private var localeIdentifier: String {
        switch selectedLanguage {
        case "Spanish":  return "es"
        case "Chinese":  return "zh-Hans"
        default:         return "en"
        }
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Overview".l(selectedLanguage), systemImage: "creditcard.fill")
                }
            
            StatsView()
                .tabItem {
                    Label("Stats".l(selectedLanguage), systemImage: "chart.bar.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings".l(selectedLanguage), systemImage: "gear")
                }
        }
        .onChange(of: accountStore.currentAccount) { oldValue, newValue in
            // Update TransactionStore when account changes
            store.switchToAccount(newValue)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .environment(\.locale, .init(identifier: localeIdentifier))
        .accentColor(Color(red: 0, green: 0.5, blue: 0))
        .environment(\.accountCurrency, accountStore.currentAccount.currency)
    }
}
