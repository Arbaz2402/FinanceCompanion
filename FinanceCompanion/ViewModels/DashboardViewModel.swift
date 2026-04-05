import Foundation
import SwiftData
import SwiftUI
import Combine

@Observable
final class DashboardViewModel {
    var transactions: [Transaction] = []
    var goals: [SavingsGoal] = []
    
    var totalIncome: Double {
        transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpenses: Double {
        transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
    
    var balance: Double {
        totalIncome - totalExpenses
    }
    
    var categorySpending: [(category: TransactionCategory, amount: Double)] {
        let expenses = transactions.filter { $0.type == .expense }
        let grouped = Dictionary(grouping: expenses) { $0.category }
        return grouped.map { (category: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.amount > $1.amount }
    }
    
    var noSpendStreak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let expenses = transactions.filter { $0.type == .expense && $0.category != .savings }
            .map { calendar.startOfDay(for: $0.date) }
        
        // If there are no expenses at all, we don't have a streak yet
        guard !expenses.isEmpty else { return 0 }
        
        // If there's an expense today, the streak is broken (0)
        if expenses.contains(today) { return 0 }
        
        var streak = 0
        var checkDay = today
        
        // Find the oldest expense to set a limit
        let oldestExpense = expenses.min() ?? today
        
        // Count consecutive days going backwards from yesterday
        while true {
            let previousDay = calendar.date(byAdding: .day, value: -1, to: checkDay)!
            
            // If we find an expense on this previous day, the streak ends
            if expenses.contains(previousDay) {
                break
            }
            
            // If we've gone back further than our oldest expense, the streak ends
            if previousDay < oldestExpense {
                break
            }
            
            streak += 1
            checkDay = previousDay
            
            // Safety break
            if streak >= 365 { break }
        }
        return streak
    }
    
    var welcomeMessage: String {
         let hour = Calendar.current.component(.hour, from: .now)
         switch hour {
         case 0..<5: return "Good Night!"
         case 5..<12: return "Good Morning!"
         case 12..<17: return "Good Afternoon!"
         case 17..<21: return "Good Evening!"
         default: return "Good Night!"
         }
     }
    
    var dailyTip: String {
        let tips = [
            "Track every ₹, even the small ones. It adds up!",
            "Review your weekly spending on Sundays.",
            "Aim to save at least 20% of your income.",
            "Avoid impulsive purchases. Wait 24 hours.",
            "Categorize your needs vs wants.",
            "Check your progress towards your goals today.",
            "A no-spend day is a win for your future self."
        ]
        // Use the day of the year to pick a consistent tip for the day
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: .now) ?? 0
        return tips[dayOfYear % tips.count]
    }
    
    func update(transactions: [Transaction], goals: [SavingsGoal]) {
        self.transactions = transactions
        self.goals = goals
    }
}
