import Foundation
import SwiftData
import SwiftUI

@Observable
final class AddTransactionViewModel {
    var amount: String = ""
    var type: TransactionType = .expense
    var category: TransactionCategory = .food
    var date: Date = .now
    var notes: String = ""
    
    private let transaction: Transaction?
    
    init(transaction: Transaction? = nil) {
        self.transaction = transaction
        if let transaction = transaction {
            self.amount = String(format: "%.0f", transaction.amount)
            self.type = transaction.type
            self.category = transaction.category
            self.date = transaction.date
            self.notes = transaction.notes
        }
    }
    
    var numericAmount: Double {
        Double(amount) ?? 0
    }
    
    var isValid: Bool {
        numericAmount > 0
    }
    
    func save(context: ModelContext) {
        if let transaction = transaction {
            transaction.amount = numericAmount
            transaction.type = type
            transaction.category = category
            transaction.date = date
            transaction.notes = notes
        } else {
            let newTransaction = Transaction(
                amount: numericAmount,
                type: type,
                category: category,
                date: date,
                notes: notes
            )
            context.insert(newTransaction)
        }
        try? context.save()
    }
}
