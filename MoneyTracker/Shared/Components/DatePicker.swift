//DatePicker.swift
//Custom date picker component
//struct MonthYearPickerView: View
//struct DatePickerOverlay: View

import SwiftUI
import CoreData

// MARK: - Month/Year Picker
/// A custom view for selecting a month and year.
struct MonthYearPickerView: View {
    @Binding var selectedDate: Date
    @Binding var showPicker: Bool
    
    @State private var currentYear: Int
    @State private var selectedMonth: Int
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    /// Returns an array of month names based on the selected locale.
    private var months: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        return formatter.monthSymbols
    }
    
    /// Determines the locale identifier from the selected language.
    private var localeIdentifier: String {
        switch selectedLanguage {
        case "Spanish": return "es"
        case "Chinese": return "zh-Hans"
        default: return "en"
        }
    }
    
    /// Creates a grid layout (3 columns) for the month names.
    private var monthGrid: [[String]] {
        stride(from: 0, to: months.count, by: 3).map {
            Array(months[$0..<min($0 + 3, months.count)])
        }
    }
    
    /// Initializes the picker with the current selected date.
    init(selectedDate: Binding<Date>, showPicker: Binding<Bool>) {
        _selectedDate = selectedDate
        _showPicker = showPicker
        
        let calendar = Calendar.current
        _currentYear = State(initialValue: calendar.component(.year, from: selectedDate.wrappedValue))
        _selectedMonth = State(initialValue: calendar.component(.month, from: selectedDate.wrappedValue) - 1)
    }
    
    var body: some View {
        ZStack {
            // Tapping outside dismisses the picker.
            Color.black.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture {
                    showPicker = false
                }
            
            VStack(spacing: 0) {
                // Year selection with navigation buttons.
                HStack(spacing: 24) {
                    Button { currentYear -= 1 } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundStyle(.primary)
                    }
                    
                    Text(currentYear, format: .number.grouping(.never))
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(minWidth: 80)
                        .contentTransition(.numericText())
                    
                    Button { currentYear += 1 } label: {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.vertical, 16)
                
                // Grid of month buttons.
                VStack(spacing: 12) {
                    ForEach(monthGrid, id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach(row, id: \.self) { month in
                                let isSelected = months[selectedMonth] == month
                                Button {
                                    if let index = months.firstIndex(of: month) {
                                        selectedMonth = index
                                        updateSelectedDate()
                                    }
                                } label: {
                                    Text(month.prefix(3))
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(isSelected ? .bold : .regular)
                                        .frame(width: 70, height: 36)
                                        .foregroundStyle(isSelected ? .primary : .secondary)
                                        .background(isSelected ? Color(red: 0, green: 0.5, blue: 0).opacity(0.2) : Color.clear)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .frame(width: 300)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 2)
        }
    }
    
    /// Updates the selectedDate based on the current year and month selection.
    private func updateSelectedDate() {
        var components = DateComponents()
        components.year = currentYear
        components.month = selectedMonth + 1
        components.day = 1
        
        if let newDate = Calendar.current.date(from: components) {
            selectedDate = newDate
            showPicker = false
        }
    }
}
