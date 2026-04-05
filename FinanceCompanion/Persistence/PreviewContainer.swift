import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Transaction.self, SavingsGoal.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        let sampleTransactions = [
            Transaction(amount: 250000, type: .income, category: .salary, date: .now.addingTimeInterval(-86400 * 5), notes: "Monthly Salary"),
            Transaction(amount: 500, type: .expense, category: .food, date: .now.addingTimeInterval(-86400 * 2), notes: "Lunch at cafe"),
            Transaction(amount: 12000, type: .expense, category: .shopping, date: .now.addingTimeInterval(-86400), notes: "New headphones"),
            Transaction(amount: 450, type: .expense, category: .transport, date: .now, notes: "Uber ride"),
            Transaction(amount: 5000, type: .expense, category: .bills, date: .now.addingTimeInterval(-86400 * 10), notes: "Electricity bill")
        ]
        
        for transaction in sampleTransactions {
            container.mainContext.insert(transaction)
        }
        
        let sampleGoal = SavingsGoal(title: "New MacBook", targetAmount: 200000, currentAmount: 45000)
        container.mainContext.insert(sampleGoal)
        
        return container
    } catch {
        fatalError("Failed to create preview container: \(error.localizedDescription)")
    }
}()
