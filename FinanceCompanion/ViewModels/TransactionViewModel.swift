import Foundation
import SwiftData
import SwiftUI

@Observable
final class TransactionViewModel {
    var transactions: [Transaction] = []
    var searchText: String = ""
    var selectedType: TransactionType?
    var selectedMonth: Date?
    var selectedDate: Date?
    
    var filteredTransactions: [Transaction] {
        transactions.filter { transaction in
            let matchesSearch = searchText.isEmpty || transaction.notes.localizedCaseInsensitiveContains(searchText) || transaction.category.rawValue.localizedCaseInsensitiveContains(searchText)
            let matchesType = selectedType == nil || transaction.type == selectedType
            
            let calendar = Calendar.current
            let matchesMonth: Bool
            if let selectedMonth {
                let components = calendar.dateComponents([.year, .month], from: selectedMonth)
                let txComponents = calendar.dateComponents([.year, .month], from: transaction.date)
                matchesMonth = components.year == txComponents.year && components.month == txComponents.month
            } else {
                matchesMonth = true
            }
            
            let matchesDate: Bool
            if let selectedDate {
                matchesDate = calendar.isDate(transaction.date, inSameDayAs: selectedDate)
            } else {
                matchesDate = true
            }
            
            return matchesSearch && matchesType && matchesMonth && matchesDate
        }
    }
    
    var availableMonths: [Date] {
        let calendar = Calendar.current
        let months = transactions.map { 
            calendar.date(from: calendar.dateComponents([.year, .month], from: $0.date))!
        }
        return Array(Set(months)).sorted(by: >)
    }
    
    func update(transactions: [Transaction]) {
        self.transactions = transactions
    }
}
