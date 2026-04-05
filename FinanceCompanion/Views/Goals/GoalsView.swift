import SwiftUI
import SwiftData

struct GoalsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavingsGoal.targetAmount, order: .reverse) private var goals: [SavingsGoal]
    @Query private var allTransactions: [Transaction]
    @State private var showingAddGoal = false
    @State private var viewModel = GoalViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundDecorationView(colors: [.blue, .teal])
                
                if goals.isEmpty {
                    AppEmptyStateView(
                        icon: "target",
                        title: "No Savings Goals Yet",
                        description: "Start your journey towards your dreams by setting a goal today.",
                        actionLabel: "Add Your First Goal",
                        action: { showingAddGoal.toggle() }
                    )
                    .padding()
                } else {
                    List {
                        Section {
                            GoalsTotalSavingsCard(totalSaved: goals.reduce(0) { $0 + $1.currentAmount })
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .padding(.horizontal)
                                .padding(.top, 10)
                        }
                        
                        Section {
                            ForEach(goals) { goal in
                                GoalRow(goal: goal)
                                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            deleteGoal(goal)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .headerProminence(.increased)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Savings Goals")
            .background(Color(uiColor: .systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddGoal.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView()
            }
            .onAppear {
                withAnimation {
                    viewModel.update(goals: goals)
                }
            }
            .onChange(of: goals) { _, newGoals in
                withAnimation {
                    viewModel.update(goals: newGoals)
                }
            }
        }
    }
    
    private func deleteGoal(_ goal: SavingsGoal) {
        withAnimation {
            // 1. Find and delete all associated transactions
            // This ensures balance and history reflect the removal
            let associatedTransactions = allTransactions.filter { $0.goalID == goal.id }
            for tx in associatedTransactions {
                modelContext.delete(tx)
            }
            
            // 2. Delete the goal itself
            modelContext.delete(goal)
            
            // 3. Save changes
            try? modelContext.save()
            
            // 4. Provide feedback
            HapticManager.notification(type: .success)
        }
    }
}

// MARK: - Subviews

private struct GoalsTotalSavingsCard: View {
    let totalSaved: Double
    
    var body: some View {
        FinanceCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Saved")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(totalSaved, format: .currency(code: "INR"))
                        .font(.title.bold())
                        .foregroundStyle(.primary)
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 50, height: 50)
                    Image(systemName: "banknote.fill")
                        .foregroundStyle(.blue)
                        .font(.title2)
                }
            }
        }
    }
}

struct GoalRow: View {
    let goal: SavingsGoal
    @State private var showingUpdate = false
    @State private var showingHistory = false
    @State private var updatedAmount: Double = 0
    @Environment(\.modelContext) private var modelContext
    @Query private var allTransactions: [Transaction]
    
    private var goalTransactions: [Transaction] {
        allTransactions.filter { $0.goalID == goal.id }
            .sorted(by: { $0.date > $1.date })
    }
    
    var body: some View {
        FinanceCard(padding: 24) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(goal.title)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        if let deadline = goal.deadline {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                Text(deadline, format: .dateTime.month().day().year())
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Text(goal.progress, format: .percent.precision(.fractionLength(0)))
                        .font(.title3.bold())
                        .foregroundStyle(goal.progress >= 1.0 ? .green : .blue)
                }
                
                // Custom Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(goal.progress >= 1.0 ? Color.green.gradient : Color.blue.gradient)
                            .frame(width: geometry.size.width * CGFloat(goal.progress), height: 12)
                    }
                }
                .frame(height: 12)
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Current")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                        Text(goal.currentAmount, format: .currency(code: "INR"))
                            .font(.subheadline.bold())
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Target")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                        Text(goal.targetAmount, format: .currency(code: "INR"))
                            .font(.subheadline.bold())
                    }
                }
                
                Divider()
                
                HStack {
                    Button {
                        updatedAmount = goal.currentAmount
                        showingUpdate.toggle()
                    } label: {
                        Label("Add Savings", systemImage: "plus.circle.fill")
                            .font(.subheadline.bold())
                            .foregroundStyle(.blue)
                    }
                    
                    Spacer()
                    
                    if !goalTransactions.isEmpty {
                        Button {
                            showingHistory.toggle()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "clock.arrow.circlepath")
                                Text("History")
                            }
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                        }
                    }
                    
                    if goal.progress >= 1.0 {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.seal.fill")
                            Text("Goal Achieved")
                        }
                        .font(.caption.bold())
                        .foregroundStyle(.green)
                    } else {
                        Text("\((goal.targetAmount - goal.currentAmount), format: .currency(code: "INR")) left")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .sheet(isPresented: $showingHistory) {
            GoalHistoryView(goal: goal, transactions: goalTransactions)
        }
        .alert("Update Savings", isPresented: $showingUpdate) {
            TextField("Total Amount Saved", value: $updatedAmount, format: .number)
                .keyboardType(.decimalPad)
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                withAnimation {
                    let addition = updatedAmount - goal.currentAmount
                    if addition > 0 {
                        let savingsTransaction = Transaction(
                            amount: addition,
                            type: .expense,
                            category: .savings,
                            notes: "Saved for: \(goal.title)",
                            goalID: goal.id
                        )
                        modelContext.insert(savingsTransaction)
                    }
                    
                    goal.currentAmount = updatedAmount
                    HapticManager.notification(type: .success)
                    try? modelContext.save()
                }
            }
        } message: {
            Text("Update your current savings for '\(goal.title)'.")
        }
    }
}

struct GoalHistoryView: View {
    let goal: SavingsGoal
    let transactions: [Transaction]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Progress")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            Text(goal.currentAmount, format: .currency(code: "INR"))
                                .font(.title2.bold())
                            Spacer()
                            Text("of \(goal.targetAmount.formatted(.currency(code: "INR")))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        ProgressView(value: goal.progress)
                            .tint(.blue)
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Savings History") {
                    if transactions.isEmpty {
                        Text("No savings recorded yet.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(transactions) { tx in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(tx.date, format: .dateTime.day().month().year())
                                        .font(.subheadline.bold())
                                    if !tx.notes.isEmpty {
                                        Text(tx.notes)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                Text(tx.amount, format: .currency(code: "INR"))
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                }
            }
            .navigationTitle(goal.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    GoalsView()
        .modelContainer(previewContainer)
}
