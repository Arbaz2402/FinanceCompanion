import SwiftUI

struct BackgroundDecorationView: View {
    let colors: [Color]
    
    var body: some View {
        ZStack {
            ForEach(0..<colors.count, id: \.self) { index in
                Circle()
                    .fill(colors[index].opacity(index == 0 ? 0.1 : 0.05))
                    .frame(width: index == 0 ? 400 : 300, height: index == 0 ? 400 : 300)
                    .offset(x: index == 0 ? -200 : 150, y: index == 0 ? -300 : 100)
                    .blur(radius: index == 0 ? 80 : 60)
            }
        }
        .ignoresSafeArea()
    }
}

struct FinanceCard<Content: View>: View {
    var padding: CGFloat = 24
    var cornerRadius: CGFloat = 24
    var backgroundColor: Color = Color(uiColor: .secondarySystemGroupedBackground)
    let content: Content
    
    init(padding: CGFloat = 24, cornerRadius: CGFloat = 24, backgroundColor: Color = Color(uiColor: .secondarySystemGroupedBackground), @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
    }
}

struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var actionLabel: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            Spacer()
            if let actionLabel = actionLabel, let action = action {
                Button(action: action) {
                    Text(actionLabel)
                        .font(.subheadline.bold())
                        .foregroundStyle(.blue)
                }
            }
        }
        .padding(.horizontal, 4)
    }
}

struct AppEmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    var actionLabel: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundStyle(.blue.gradient)
                .padding(.top, 60)
            
            Text(title)
                .font(.title2.bold())
            
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            if let actionLabel = actionLabel, let action = action {
                Button(action: action) {
                    Text(actionLabel)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.gradient)
                        .cornerRadius(16)
                        .padding(.horizontal, 60)
                }
                .padding(.top, 20)
            }
        }
    }
}
