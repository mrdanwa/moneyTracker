//CustomBackground.swift
//Custom background component
//struct CustomBackground: View

import SwiftUI
import CoreData

// MARK: - Glassmorphic Background
/// A reusable glassmorphic background view.
struct CustomBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Rectangle()
                .fill(.ultraThinMaterial)
        }
    }
}

