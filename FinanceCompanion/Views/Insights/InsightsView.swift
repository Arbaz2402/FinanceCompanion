import SwiftUI
import SwiftData
import Charts

struct InsightsView: View {
    @Query private var transactions: [Transaction]
    @State private var selectedDate: Date?
    @State private var timeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
    }
    
    private var startDate: Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        switch timeRange {
        case .day:
            return calendar.date(byAdding: .day, value: -6, to: today)!
        case .week:
            return calendar.date(byAdding: .weekOfYear, value: -5, to: today)!
        case .month:
            return calendar.date(byAdding: .month, value: -5, to: today)!
        }
    }
    
    private var filteredTransactions: [Transaction] {
        transactions.filter { $0.type == .expense && $0.date >= startDate }
    }
    
    private var trendData: [(date: Date, income: Double, expense: Double)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        
        let range: [Date]
        
        switch timeRange {
        case .day:
            range = calendar.generateDates(inside: DateInterval(start: startDate, end: today.addingTimeInterval(86400)), matching: DateComponents(hour: 0))
        case .week:
            range = calendar.generateDates(inside: DateInterval(start: startDate, end: today.addingTimeInterval(86400)), matching: calendar.dateComponents([.weekday, .hour], from: startDate))
        case .month:
            range = calendar.generateDates(inside: DateInterval(start: startDate, end: today.addingTimeInterval(86400)), matching: DateComponents(day: 1, hour: 0))
        }
        
        let grouped = Dictionary(grouping: transactions) { transaction in
            calendar.date(from: calendar.dateComponents(timeRange == .day ? [.year, .month, .day] : (timeRange == .week ? [.yearForWeekOfYear, .weekOfYear] : [.year, .month]), from: transaction.date))!
        }
        
        return range.map { date in
            let components = calendar.dateComponents(timeRange == .day ? [.year, .month, .day] : (timeRange == .week ? [.yearForWeekOfYear, .weekOfYear] : [.year, .month]), from: date)
            let dateKey = calendar.date(from: components)!
            let txs = grouped[dateKey] ?? []
            return (
                date: date,
                income: txs.filter { $0.type == .income }.reduce(0) { $0 + $1.amount },
                expense: txs.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
            )
        }
    }
    
    private var highestSpendingCategory: (category: TransactionCategory, amount: Double)? {
        let grouped = Dictionary(grouping: filteredTransactions) { $0.category }
        return grouped.map { (category: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .max { $0.amount < $1.amount }
    }
    
    private var timeRangeComparison: (current: Double, previous: Double, percentChange: Double, title: String)? {
        let calendar = Calendar.current
        let now = Date()
        let startOfCurrent: Date
        let startOfPrevious: Date
        let title: String
        
        switch timeRange {
        case .day:
            startOfCurrent = calendar.startOfDay(for: now)
            startOfPrevious = calendar.date(byAdding: .day, value: -1, to: startOfCurrent)!
            title = "Daily Change"
        case .week:
            startOfCurrent = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            startOfPrevious = calendar.date(byAdding: .weekOfYear, value: -1, to: startOfCurrent)!
            title = "Weekly Change"
        case .month:
            startOfCurrent = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            startOfPrevious = calendar.date(byAdding: .month, value: -1, to: startOfCurrent)!
            title = "Monthly Change"
        }
        
        let currentExpenses = filteredTransactions.filter { $0.date >= startOfCurrent }.reduce(0) { $0 + $1.amount }
        let previousExpenses = filteredTransactions.filter { $0.date >= startOfPrevious && $0.date < startOfCurrent }.reduce(0) { $0 + $1.amount }
        
        let change = previousExpenses == 0 ? (currentExpenses > 0 ? 100.0 : 0.0) : ((currentExpenses - previousExpenses) / previousExpenses) * 100
        return (currentExpenses, previousExpenses, change, title)
    }
    
    private var frequentTransactionType: (category: TransactionCategory, count: Int)? {
        let grouped = Dictionary(grouping: filteredTransactions) { $0.category }
        return grouped.map { (category: $0.key, count: $0.value.count) }
            .max { $0.count < $1.count }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundDecorationView(colors: [.purple, .blue])
                
                ScrollView {
                    VStack(spacing: 24) {
                        InsightsTimeRangePicker(timeRange: $timeRange)
                        
                        InsightsSmartSection(
                            highest: highestSpendingCategory,
                            comparison: timeRangeComparison,
                            frequent: frequentTransactionType
                        )
                        
                        InsightsTrendSection(
                            timeRange: timeRange,
                            trendData: trendData
                        )
                        
                        InsightsBreakdownSection(
                            filteredTransactions: filteredTransactions
                        )
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Insights")
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}

// MARK: - Subviews

private struct InsightsTimeRangePicker: View {
    @Binding var timeRange: InsightsView.TimeRange
    
    var body: some View {
        Picker("Time Range", selection: $timeRange) {
            ForEach(InsightsView.TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}

private struct InsightsSmartSection: View {
    let highest: (category: TransactionCategory, amount: Double)?
    let comparison: (current: Double, previous: Double, percentChange: Double, title: String)?
    let frequent: (category: TransactionCategory, count: Int)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Smart Insights")
            
            HStack(spacing: 12) {
                if let highest = highest {
                    InsightCard(title: "Top Spend", 
                                value: highest.category.rawValue, 
                                subtitle: highest.amount.formatted(.currency(code: "INR")),
                                icon: highest.category.icon,
                                color: highest.category.color)
                }
                
                if let comparison = comparison {
                    InsightCard(title: comparison.title,
                                value: String(format: "%.1f%%", abs(comparison.percentChange)),
                                subtitle: comparison.percentChange >= 0 ? "Increase" : "Decrease",
                                icon: comparison.percentChange >= 0 ? "arrow.up.right" : "arrow.down.right",
                                color: comparison.percentChange >= 0 ? .red : .green)
                }
            }
            
            if let frequent = frequent {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundStyle(.blue)
                    Text("You shop most frequently at")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(frequent.category.rawValue)
                        .font(.subheadline.bold())
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.05))
                .cornerRadius(16)
            }
        }
        .padding(.horizontal)
    }
}

private struct InsightsTrendSection: View {
    let timeRange: InsightsView.TimeRange
    let trendData: [(date: Date, income: Double, expense: Double)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "\(timeRange.rawValue)ly Trend")
            
            FinanceCard {
                Group {
                    if trendData.isEmpty {
                        ContentUnavailableView("No Data", systemImage: "chart.bar", description: Text("Add transactions to see trends"))
                            .frame(height: 200)
                    } else {
                        TrendChart(timeRange: timeRange, trendData: trendData)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

private struct TrendChart: View {
    let timeRange: InsightsView.TimeRange
    let trendData: [(date: Date, income: Double, expense: Double)]
    
    var body: some View {
        Chart {
            ForEach(trendData, id: \.date) { data in
                BarMark(
                    x: .value("Date", data.date, unit: timeRange == .day ? .day : (timeRange == .week ? .weekOfYear : .month)),
                    y: .value("Amount", data.income)
                )
                .foregroundStyle(.green.gradient)
                .position(by: .value("Type", "Income"), axis: .horizontal)
                .cornerRadius(4)
                
                BarMark(
                    x: .value("Date", data.date, unit: timeRange == .day ? .day : (timeRange == .week ? .weekOfYear : .month)),
                    y: .value("Amount", data.expense)
                )
                .foregroundStyle(.red.gradient)
                .position(by: .value("Type", "Expense"), axis: .horizontal)
                .cornerRadius(4)
            }
        }
        .frame(height: 250)
        .chartXAxis {
            switch timeRange {
            case .day:
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                        .font(.system(size: 10, weight: .bold))
                }
            case .week:
                AxisMarks(values: .stride(by: .weekOfYear)) { _ in
                    AxisValueLabel(format: .dateTime.day().month())
                        .font(.system(size: 10, weight: .bold))
                }
            case .month:
                AxisMarks(values: .stride(by: .month)) { _ in
                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                        .font(.system(size: 10, weight: .bold))
                }
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine(stroke: StrokeStyle(dash: [2, 4]))
                    .foregroundStyle(.secondary.opacity(0.3))
                AxisValueLabel {
                    if let amount = value.as(Double.self) {
                        Text(amount, format: .currency(code: "INR").notation(.compactName))
                            .font(.system(size: 10))
                    }
                }
            }
        }
        .chartLegend(position: .top, alignment: .trailing) {
            HStack(spacing: 12) {
                Label("Income", systemImage: "circle.fill")
                    .foregroundStyle(.green)
                Label("Expense", systemImage: "circle.fill")
                    .foregroundStyle(.red)
            }
            .font(.caption2.bold())
            .padding(.bottom, 8)
        }
    }
}

private struct InsightsBreakdownSection: View {
    let filteredTransactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Category Breakdown")
            
            let categorySpending = Dictionary(grouping: filteredTransactions) { $0.category }
                .map { (category: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
                .sorted { $0.amount > $1.amount }
            
            FinanceCard {
                if categorySpending.isEmpty {
                    ContentUnavailableView("No Data", systemImage: "chart.pie", description: Text("Add expenses to see analysis"))
                        .frame(height: 200)
                } else {
                    BreakdownChart(categorySpending: categorySpending)
                }
            }
        }
        .padding(.horizontal)
    }
}

private struct BreakdownChart: View {
    let categorySpending: [(category: TransactionCategory, amount: Double)]
    
    var body: some View {
        VStack(spacing: 24) {
            Chart {
                ForEach(categorySpending, id: \.category) { item in
                    SectorMark(
                        angle: .value("Amount", item.amount),
                        innerRadius: .ratio(0.6),
                        angularInset: 2
                    )
                    .cornerRadius(8)
                    .foregroundStyle(item.category.color.gradient)
                }
            }
            .frame(height: 250)
            
            VStack(spacing: 12) {
                ForEach(categorySpending.prefix(5), id: \.category) { item in
                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(item.category.color)
                            .frame(width: 12, height: 12)
                        Text(item.category.rawValue)
                            .font(.subheadline)
                        Spacer()
                        Text(item.amount, format: .currency(code: "INR"))
                            .font(.subheadline.bold())
                    }
                }
            }
        }
    }
}

struct InsightCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        FinanceCard(padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .foregroundStyle(color)
                        .font(.headline)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fontWeight(.medium)
                    Text(value)
                        .font(.headline.bold())
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(color)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

extension Calendar {
    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(startingAfter: interval.start, matching: components, matchingPolicy: .nextTime) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        return dates
    }
}
