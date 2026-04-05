import Foundation
import SwiftData
import SwiftUI

@Observable
final class GoalViewModel {
    var goals: [SavingsGoal] = []
    
    func update(goals: [SavingsGoal]) {
        self.goals = goals
    }
}
