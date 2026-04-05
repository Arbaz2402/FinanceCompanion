import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                VStack(spacing: 20) {
                    Image(systemName: "indianrupeesign.circle.fill")
                        .font(.system(size: 100))
                        .foregroundStyle(.blue.gradient)
                    
                    Text("FinanceCompanion")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.black.opacity(0.80))
                    
                    Text("Your Smart Money Habit")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
