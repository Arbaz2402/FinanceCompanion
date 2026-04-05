import Foundation
import SwiftData
import SwiftUI

enum TransactionType: String, Codable, CaseIterable {
    case income = "Income"
    case expense = "Expense"
}

enum TransactionCategory: String, Codable, CaseIterable {
    case food = "Food & Drinks"
    case shopping = "Shopping"
    case transport = "Transport"
    case entertainment = "Entertainment"
    case bills = "Bills & Utilities"
    case salary = "Salary"
    case savings = "Savings"
    case health = "Health & Fitness"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .shopping: return "cart"
        case .transport: return "car"
        case .entertainment: return "tv"
        case .bills: return "doc.plaintext"
        case .salary: return "dollarsign.circle"
        case .savings: return "banknote"
        case .health: return "heart.fill"
        case .other: return "ellipsis.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .food: return .orange
        case .shopping: return .blue
        case .transport: return .cyan
        case .entertainment: return .purple
        case .bills: return .red
        case .salary: return .green
        case .savings: return .teal
        case .health: return .pink
        case .other: return .gray
        }
    }
}

@Model
final class Transaction {
    var id: UUID = UUID()
    var amount: Double
    var type: TransactionType
    var category: TransactionCategory
    var date: Date
    var notes: String
    var goalID: UUID?
    
    init(amount: Double, type: TransactionType, category: TransactionCategory, date: Date = .now, notes: String = "", goalID: UUID? = nil) {
        self.id = UUID()
        self.amount = amount
        self.type = type
        self.category = category
        self.date = date
        self.notes = notes
        self.goalID = goalID
    }
}

@Model
final class SavingsGoal {
    var id: UUID = UUID()
    var title: String
    var targetAmount: Double
    var currentAmount: Double
    var deadline: Date?
    
    init(title: String, targetAmount: Double, currentAmount: Double = 0, deadline: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.deadline = deadline
    }
    
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1.0)
    }
}
