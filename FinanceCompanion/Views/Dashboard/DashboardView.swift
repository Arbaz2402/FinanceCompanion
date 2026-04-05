import SwiftUI
import SwiftData
import Charts

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var transactions: [Transaction]
    @Query private var goals: [SavingsGoal]
    
    @State private var viewModel = DashboardViewModel()
    @State private var scrolledGoalID: UUID?
    @State private var selectedCategory: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundDecorationView(colors: [.blue, .orange])
                
                ScrollView {
                    VStack(spacing: 24) {
                        DashboardHeader(message: viewModel.welcomeMessage)
                        
                        DashboardSummarySection(
                            balance: viewModel.balance,
                            income: viewModel.totalIncome,
                            expenses: viewModel.totalExpenses
                        )
                        
                        if !goals.isEmpty {
                            DashboardGoalsSection(
                                goals: goals,
                                scrolledGoalID: $scrolledGoalID
                            )
                        }
                        
                        DashboardInsightsSection(
                            categorySpending: viewModel.categorySpending,
                            selectedCategory: $selectedCategory
                        )
                        
                        HStack(spacing: 16) {
                            DashboardStreakSection(streak: viewModel.noSpendStreak)
                            DashboardDailyTipSection(tip: viewModel.dailyTip)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarHidden(true)
            .background(Color(uiColor: .systemGroupedBackground))
            .onAppear {
                withAnimation(.spring()) {
                    viewModel.update(transactions: transactions, goals: goals)
                }
            }
            .onChange(of: transactions) { _, newTransactions in
                withAnimation(.spring()) {
                    viewModel.update(transactions: newTransactions, goals: goals)
                }
            }
        }
    }
}

// MARK: - Subviews

private struct DashboardHeader: View {
    let message: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(message)
                .font(.title3.bold())
            Text("Let's manage your finances today.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 10)
    }
}

private struct DashboardSummarySection: View {
    let balance: Double
    let income: Double
    let expenses: Double
    
    var body: some View {
        VStack(spacing: 16) {
            FinanceCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Balance")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fontWeight(.medium)
                    
                    Text(balance, format: .currency(code: "INR"))
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack(spacing: 16) {
                SummaryCard(title: "Income", amount: income, icon: "arrow.up.circle.fill", color: .green)
                SummaryCard(title: "Expenses", amount: expenses, icon: "arrow.down.circle.fill", color: .red)
            }
        }
    }
}

private struct DashboardGoalsSection: View {
    let goals: [SavingsGoal]
    @Binding var scrolledGoalID: UUID?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Savings Goals", subtitle: goals.count > 1 ? "\(goals.count) Goals" : nil)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(goals) { goal in
                        ZStack(alignment: .bottom) {
                            GoalCarouselCard(goal: goal)
                            
                            if goals.count > 1 {
                                HStack(spacing: 6) {
                                    ForEach(goals) { g in
                                        Circle()
                                            .fill(scrolledGoalID == g.id ? Color.blue : Color.gray.opacity(0.3))
                                            .frame(width: 5, height: 5)
                                    }
                                }
                                .padding(.bottom, 12)
                            }
                        }
                        .containerRelativeFrame(.horizontal)
                        .id(goal.id)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrolledGoalID)
            .onAppear {
                if scrolledGoalID == nil {
                    scrolledGoalID = goals.first?.id
                }
            }
        }
    }
}

private struct GoalCarouselCard: View {
    let goal: SavingsGoal
    
    var body: some View {
        FinanceCard(padding: 20) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Savings Goal")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(goal.progress, format: .percent.precision(.fractionLength(0)))
                        .font(.subheadline.bold())
                        .foregroundStyle(.blue)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(goal.title)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    ProgressView(value: goal.progress)
                        .tint(.blue)
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                        .clipShape(Capsule())
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Saved")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(goal.currentAmount, format: .currency(code: "INR"))
                            .font(.footnote.bold())
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Target")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(goal.targetAmount, format: .currency(code: "INR"))
                            .font(.footnote.bold())
                    }
                }
            }
        }
    }
}

private struct DashboardInsightsSection: View {
    let categorySpending: [(category: TransactionCategory, amount: Double)]
    @Binding var selectedCategory: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Top Spending")
            
            FinanceCard(padding: 20) {
                if categorySpending.isEmpty {
                    ContentUnavailableView("No Data", systemImage: "chart.pie", description: Text("Add transactions to see spending analysis"))
                        .frame(height: 150)
                } else {
                    Chart {
                        ForEach(categorySpending.prefix(5), id: \.category) { item in
                            BarMark(
                                x: .value("Amount", item.amount),
                                y: .value("Category", item.category.rawValue)
                            )
                            .foregroundStyle(item.category.color.gradient)
                            .cornerRadius(8)
                            .annotation(position: .trailing, spacing: 5) {
                                if selectedCategory == item.category.rawValue {
                                    Text(item.amount, format: .currency(code: "INR").notation(.compactName))
                                        .font(.caption2.bold())
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .frame(height: 180)
                    .chartYSelection(value: $selectedCategory)
                }
            }
        }
    }
}

private struct DashboardStreakSection: View {
    let streak: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                    .font(.caption)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(streak) Day Streak")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("No-Spend Challenge")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                ProgressView(value: Double(min(streak, 30)), total: 30)
                    .tint(.orange)
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    .clipShape(Capsule())
                    .padding(.top, 4)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.orange.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.orange.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

private struct DashboardDailyTipSection: View {
    let tip: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.yellow)
                    .font(.caption)
                Text("Tip of the Day")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }
            Text(tip)
                .font(.caption)
                .foregroundStyle(.primary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.yellow.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.yellow.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct SummaryCard: View {
    let title: String
    let amount: Double
    let icon: String
    let color: Color
    
    var body: some View {
        FinanceCard(padding: 20) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .foregroundStyle(color)
                        .font(.title3)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fontWeight(.medium)
                    Text(amount, format: .currency(code: "INR"))
                        .font(.subheadline.bold())
                        .minimumScaleFactor(0.5)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(previewContainer)
}
