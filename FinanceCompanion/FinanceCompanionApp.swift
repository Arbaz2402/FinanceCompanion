//
//  FinanceCompanionApp.swift
//  FinanceCompanion
//
//  Created by Arbaz Kaladiya on 02/04/26.
//

import SwiftUI
import SwiftData

@main
struct FinanceCompanionApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [Transaction.self, SavingsGoal.self])
    }
}
