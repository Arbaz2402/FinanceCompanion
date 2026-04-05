import Foundation
import SwiftData
import SwiftUI

@Observable
final class AddGoalViewModel {
    var title: String = ""
    var targetAmount: Double = 0
    var currentAmount: Double = 0
    var deadline: Date = .now.addingTimeInterval(86400 * 30)
    var hasDeadline: Bool = false
    
    var isValid: Bool {
        !title.isEmpty && targetAmount > 0
    }
    
    func save(context: ModelContext) {
        let goal = SavingsGoal(
            title: title,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            deadline: hasDeadline ? deadline : nil
        )
        context.insert(goal)
        
        // If there's an initial amount, create a transaction for it
        if currentAmount > 0 {
            let initialSavingsTransaction = Transaction(
                amount: currentAmount,
                type: .expense,
                category: .savings,
                notes: "Initial Savings for: \(title)",
                goalID: goal.id
            )
            context.insert(initialSavingsTransaction)
        }
        
        try? context.save()
    }
}
