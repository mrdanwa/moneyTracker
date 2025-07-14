# MoneyTracker

MoneyTracker is a comprehensive iOS application designed to help users manage their personal finances effectively. With an intuitive interface and powerful features, it allows users to track income, expenses, and analyze their spending patterns across multiple accounts.

## Features

### 💰 Transaction Management

- Track both income and expenses
- Multiple account support with different currencies
- Detailed transaction categorization
- Add notes and dates to transactions
- Quick search functionality for past transactions

### 📊 Advanced Analytics

- Interactive summary cards showing financial overview
- Category breakdown with donut charts
- Monthly and yearly spending analysis
- Bar charts for tracking spending trends
- Detailed category-wise expense distribution

### 🎯 Smart Features

- Multi-currency support
- Default account settings
- Customizable transaction categories
- Multi-language support (English, Spanish, Chinese)
- Data backup functionality

### 📱 Modern UI/UX

- Beautiful and intuitive interface
- Custom backgrounds and animations
- Interactive charts and visualizations
- Responsive design for all iOS devices
- Dark mode support

## Technical Stack

- **Framework**: SwiftUI
- **Data Persistence**: Core Data
- **Charts**: Swift Charts
- **Architecture**: MVVM
- **Minimum iOS Version**: iOS 15.0+

## Project Structure

```
MoneyTracker/
├── App/                   # App entry point and main views
├── Core/                  # Core functionality
│   ├── Models/            # Data models
│   └── Stores/            # State management
├── Features/              # Main app features
│   ├── Home/              # Home screen
│   ├── Settings/          # Settings screen
│   └── Stats/             # Statistics screen
└── Shared/                # Shared components and utilities
    ├── Components/        # Reusable UI components
    └── Utils/             # Helper functions
```
