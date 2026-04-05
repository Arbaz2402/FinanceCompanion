# FinanceCompanion 💰

> **A premium, privacy-focused financial companion for the modern iOS experience.**

Built with **SwiftUI** and **SwiftData**, FinanceCompanion combines professional-grade financial tracking with a beautiful, intuitive interface.

---

## 🌟 App Highlights

- 🔒 **Privacy-First**: No accounts, no cloud, no trackers. Your data never leaves your device.
- 📈 **Smart Insights**: Native Swift Charts visualize your spending patterns instantly.
- 🎯 **Goal Oriented**: Gamified savings goals with streaks and visual progress tracking.
- ⚡ **Premium UX**: Fluid animations, haptic feedback, and a clean MVVM-based architecture.

---

## 📱 Visual Experience

| Dashboard | Smart Insights | Savings Goals |
| :---: | :---: | :---: |
| ![Dashboard](https://via.placeholder.com/260x550?text=Dashboard) | ![Insights](https://via.placeholder.com/260x550?text=Insights) | ![Goals](https://via.placeholder.com/260x550?text=Goals) |
| *Unified Snapshot* | *Trend Analysis* | *Dream Tracking* |

---

## ✨ Feature Deep Dive

### 🏦 Intelligent Dashboard
*The central hub for your financial health.*
- **Dynamic Welcome Header**: Context-aware greetings that change based on the time of day (Morning, Afternoon, Evening, Night).
- **Unified Balance Snapshot**: A prominent display of your total current balance, calculated in real-time.
- **Quick Stats**: At-a-glance summary cards for total Income and total Expenses.
- **No-Spend Streak**: A motivational flame counter that tracks consecutive days without non-essential spending.
- **Interactive Goal Carousel**: A snapping horizontal view to quickly check progress on multiple savings goals without leaving the dashboard.
- **Live Spending Chart**: A mini-visualization of your top spending categories directly on the main screen.
- **Daily Financial Tips**: Rotating advice and money-saving tips that refresh every 24 hours.

### 📊 Advanced Insights & Analytics
*Understand your habits with data-driven visualizations.*
- **Time-Range Granularity**: Toggle between **Day**, **Week**, and **Month** to see trends over different periods.
- **Smart Insight Cards**:
    - **Top Spend**: Automatically identifies your highest spending category for the selected period.
    - **Trend Comparison**: Displays the percentage change (Increase/Decrease) compared to the previous period with 1-decimal precision.
- **Interactive Trend Chart**: A dual-bar chart (Income vs. Expense) powered by Swift Charts with custom axis formatting and compact notations.
- **Category Decomposition**: A beautiful donut chart showing exactly how your money is divided among categories.
- **Frequency Analysis**: Identifies which categories you transact with most often to highlight habitual spending.

### 📝 Precision Transaction Management
*Logging your money should be effortless.*
- **Immersive Entry Form**: A dedicated full-screen experience for adding or editing transactions.
- **Smart Category Grid**: A 3x3 grid for rapid category selection, replacing slow lists.
- **Search & Discovery**: Full-text search that filters through transaction notes and categories simultaneously.
- **Advanced Filtering**: Combine type-based (Income/Expense) and date-based filters to find specific entries.
- **Month Picker**: A custom menu to quickly jump to any month in your financial history.
- **Swipe Actions**: Native iOS swipe-to-edit and swipe-to-delete gestures for fast list management.

### 🎯 Goal-Oriented Savings
*Turn your dreams into reality with structured tracking.*
- **Goal Creation**: Set target amounts, starting balances, and optional deadlines.
- **Progress Visualization**: Custom-designed progress bars that change from Blue to Green when a goal is achieved.
- **Automated Bookkeeping**: Contributing to a goal automatically logs a "Savings" transaction to keep your overall balance accurate.
- **Contribution History**: A dedicated sub-view for each goal to see every individual deposit made over time.
- **Swipe Deletion with Integrity**: Removing a goal automatically cleans up its associated savings transactions to maintain balance accuracy.

### 💎 The "Small" Touches (UX/UI)
- **Haptic Engine**: Tactile feedback for saving transactions, goal completions, and category selections.
- **Immersive Backgrounds**: Subtle, blurred gradient decorations that react to the app's theme.
- **Dynamic Type Support**: High-quality typography that scales gracefully for accessibility.
- **Empty State Design**: Beautiful custom illustrations and guidance for new users with no data yet.
- **Automatic Keyboard Handling**: Smart focus management and dismiss gestures for a smooth data-entry experience.

---

## 🛠 Tech Stack

| Component | Technology |
| :--- | :--- |
| **UI Framework** | SwiftUI (iOS 17.0+) |
| **Data Engine** | SwiftData |
| **Visualization** | Swift Charts |
| **Architecture** | MVVM + Observation |
| **Feedback** | UIKit Haptics |

---

## 🚀 Getting Started

### 1. Prerequisites
- Xcode 15.0+
- iOS 17.0+ (Simulator or Physical Device)

### 2. Installation
```bash
# Clone the repository
git clone https://github.com/Arbaz2402/FinanceCompanion.git

# Open the project
cd FinanceCompanion
open FinanceCompanion.xcodeproj
```
*Press `Cmd + R` in Xcode to build and run.*

---

## 📝 Design & Architecture

<details>
<summary><b>Deep Dive into Technical Decisions</b></summary>

### 🏗 Architecture
- **Clean MVVM**: Strict separation of concerns using the modern `@Observable` framework.
- **Modular Views**: Refactored view hierarchy with extracted subviews for performance.

### 🎨 Design & UX
- **Color Palette**: Professional mix of system colors and gradients for a premium feel.
- **Localized**: Native support for **Indian Rupee (₹)** formatting.
- **Automatic Savings**: Integrated goal-transaction syncing to reduce manual friction.
- **Persistence**: Schema-driven local storage for reliable data management.
</details>

---

## 🔮 Future Roadmap
- [ ] **Budgeting**: Category-specific monthly limits.
- [ ] **Recurring**: Automatic logs for rent/subscriptions.
- [ ] **Export**: PDF/CSV financial reports.
- [ ] **Widgets**: Home Screen balance and streak tracking.

---
*Created with ❤️ for a better financial future.*
