//SplashScreen.swift
//Splash screen view
//struct SplashScreen: View

import SwiftUI
import CoreData

struct SplashScreen: View {
    @State private var isActive = false
    @EnvironmentObject var transactionStore: TransactionStore
    @EnvironmentObject var accountStore: AccountStore
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.8), Color(red: 0, green: 0.5, blue: 0).opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                Image("Pig")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation { isActive = true }
                }
            }
        }
    }
}
