# FinanceCompanion 💰

**FinanceCompanion** is a high-quality, professional personal finance tracker built with **SwiftUI** and **SwiftData**. Designed with a premium mobile-first aesthetic, it empowers users to take control of their financial life through intuitive tracking, smart insights, and gamified savings goals.

---

## 📱 Project Overview

Managing personal finances shouldn't be a chore. **FinanceCompanion** was built with a single goal: to make financial tracking as seamless and rewarding as possible. By combining modern iOS frameworks with a focus on user psychology (streaks, tips, visual feedback), the app helps users build better money habits without the friction of traditional spreadsheets.

### 🌟 Core Principles
- **Privacy First**: All your financial data stays on your device. No cloud, no tracking, no accounts.
- **Intuitive Design**: Every action is reachable and logical, following native iOS design patterns.
- **Actionable Insights**: Don't just track—understand. See patterns and get daily advice to save more.

---

## 📱 App Preview

| Dashboard | Smart Insights | Savings Goals |
| :---: | :---: | :---: |
| ![Dashboard Placeholder](https://via.placeholder.com/300x650?text=Dashboard+Screenshot) | ![Insights Placeholder](https://via.placeholder.com/300x650?text=Insights+Screenshot) | ![Goals Placeholder](https://via.placeholder.com/300x650?text=Goals+Screenshot) |
| *Main Overview & Streaks* | *Trend Analysis & Patterns* | *Dream Tracking & Progress* |

---

## ✨ Core Features

### 🏦 1. Intelligent Dashboard
- **Unified Financial Snapshot**: Instantly view your current balance, total income, and expenses in **INR (₹)**.
- **Top Spending Analysis**: Interactive bar charts highlighting your top 5 spending categories.
- **No-Spend Streak**: A gamified challenge tracking your financial discipline with a visual streak counter.
- **Goal Carousel**: A smooth, snapping horizontal carousel to monitor your active savings goals with progress indicators.
- **Daily Financial Tips**: Personalized daily insights and tips to improve your money habits.
- **Welcome Context**: Dynamic greetings based on the time of day for a personal touch.

### 📊 2. Smart Insights & Patterns
- **Time-Range Toggles**: Switch between **Day**, **Week**, and **Month** views to see trends over time.
- **Pattern Analysis**:
    - **Top Spend**: Identifies your highest spending category at a glance.
    - **Trend Comparison**: Automatic calculation of % change compared to the previous period.
    - **Frequent Habits**: Identifies which category you transact with most often.
- **Category Breakdown**: Immersive charts for a complete visual decomposition of your expenses.

### 📝 3. Seamless Transaction Management
- **Immersive Entry Forms**: Redesigned add/edit screens with focus-driven layouts and localized currency inputs.
- **Advanced Filtering**: Drill down into your history by month, specific date, or transaction type (Income/Expense).
- **Global Search**: Quickly find any transaction using keywords from notes or categories.
- **Haptic Feedback**: Tactile responses for saving and selecting categories to enhance the mobile experience.
- **Efficient Category Selection**: A grid-based selection system for quick and intuitive categorization.

### 🎯 4. Goal-Oriented Savings
- **Dream Tracking**: Create specific savings goals with target amounts and optional deadlines.
- **Automated Bookkeeping**: Adding savings to a goal automatically records a "Savings" expense, keeping your balance accurate.
- **Savings History**: Track every individual contribution towards a specific goal with a dedicated history view.
- **Visual Progress**: Dynamic progress bars that change color as you approach your target.

---

## 🛠 Technical Excellence

### Architecture & Patterns
- **MVVM Architecture**: Strict separation of concerns using `@Observable` ViewModels.
- **Clean Code**: Refactored view hierarchy with modular subviews for maximum maintainability.
- **Reactive UI**: State-driven UI updates powered by SwiftUI's modern observation framework.
- **Persistence**: **SwiftData** for modern, schema-driven local storage with seamless integration.
- **Haptic Engine**: Integrated `UIFeedbackGenerator` for a premium, responsive feel.

### Tech Stack
- **Language**: Swift 5.10+
- **Framework**: SwiftUI (iOS 17.0+)
- **Persistence**: **SwiftData** (Modern, schema-driven local storage)
- **Data Viz**: **Swift Charts** (Native, high-performance rendering)
- **Localisation**: Fully localized for **Indian Rupee (₹)** currency and formatting.

---

## 🚀 Getting Started

### Prerequisites
- **Xcode 15.0** or later.
- **iOS 17.0** or later (required for SwiftData and latest SwiftUI features).

### Installation
1. Clone or download this repository.
2. Open `FinanceCompanion.xcodeproj` in Xcode.
3. Select your target device (iPhone) or Simulator.
4. Press `Cmd + R` to build and run.

---

## 📝 Design Decisions & Assumptions

- **Color Palette**: Uses a professional mix of system colors and custom gradients to provide a "Premium" feel without sacrificing accessibility.
- **UX Patterns**: Implemented a **Splash Screen** for brand identity and a **MainTabView** for standard iOS navigation.
- **Haptic Integration**: Subtle haptic feedback added to confirmation actions to provide physical confirmation of digital actions.
- **Automatic Savings**: Integrated goal updates with transaction history to reduce manual entry friction and ensure balance accuracy.
- **Privacy**: All data is stored locally using SwiftData; no external APIs are used for transaction data, ensuring user privacy.

---

## 🔮 Future Roadmap
- **Budgeting**: Set monthly budgets for specific categories.
- **Recurring Transactions**: Automatically log rent, subscriptions, and salaries.
- **Export**: Export financial reports in PDF or CSV format.
- **Widgets**: View your balance and streaks directly from the Home Screen.

---
*Created with ❤️ for a better financial future.*
