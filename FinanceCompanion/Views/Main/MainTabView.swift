import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            if isActive {
                TabView {
                    DashboardView()
                        .tabItem {
                            Label("Dashboard", systemImage: "house.fill")
                        }
                    
                    TransactionListView()
                        .tabItem {
                            Label("History", systemImage: "list.bullet.rectangle.portrait")
                        }
                    
                    InsightsView()
                        .tabItem {
                            Label("Insights", systemImage: "chart.bar.xaxis")
                        }
                    
                    GoalsView()
                        .tabItem {
                            Label("Goals", systemImage: "target")
                        }
                }
                .tint(.blue)
            } else {
                SplashScreenView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(previewContainer)
}
