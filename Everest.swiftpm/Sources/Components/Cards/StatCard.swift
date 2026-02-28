import SwiftUI

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let icon: String?
    let trend: TrendView.Direction?
    let trendValue: String?
    
    init(
        title: String,
        value: String,
        subtitle: String? = nil,
        icon: String? = nil,
        trend: TrendView.Direction? = nil,
        trendValue: String? = nil
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.icon = icon
        self.trend = trend
        self.trendValue = trendValue
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                if let icon {
                    Circle()
                        .fill(Color.appBrandLight.opacity(0.5))
                        .frame(width: 32, height: 32)
                        .overlay {
                            Image(systemName: icon)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.appBrand)
                        }
                }
                
                Spacer()
                
                if let trend, let trendValue {
                    TrendView(direction: trend, value: trendValue)
                }
            }
            
            Spacer(minLength: 0)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.system(size: 32, weight: .regular))
                        .foregroundStyle(Color.appTextPrimary)
                    
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.appTextSecondary)
                    }
                }
                
                Text(title)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 160)
        .glassCardStyle()
    }
}

// MARK: - Trend View
struct TrendView: View {
    enum Direction { case up, down }
    
    let direction: Direction
    let value: String
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: direction == .up ? "arrow.up" : "arrow.down")
                .font(.system(size: 10, weight: .bold))
            Text(value)
                .font(.system(size: 10, weight: .medium))
        }
        .foregroundStyle(Color.appBrand)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.appBrandLight)
        .clipShape(Capsule())
    }
}

// MARK: - Level Progress Card
struct LevelProgressCard: View {
    let currentLevel: Int
    let currentXP: Int
    let xpForNextLevel: Int
    let lessonsCompleted: Int
    
    private var progress: Double {
        guard xpForNextLevel > 0 else { return 0 }
        return Double(currentXP) / Double(xpForNextLevel)
    }
    
    private var levelTitle: String {
        switch currentLevel {
        case 1...5: return "Novice"
        case 6...10: return "Apprentice"
        case 11...20: return "Scholar"
        case 21...35: return "Sage"
        case 36...50: return "Master"
        default: return "Legend"
        }
    }
    
    private var levelIcon: String {
        switch currentLevel {
        case 1...5: return "leaf.fill"
        case 6...10: return "flame.fill"
        case 11...20: return "book.fill"
        case 21...35: return "brain.head.profile"
        case 36...50: return "crown.fill"
        default: return "star.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            levelBadge
            statsView
            Spacer()
        }
        .padding(16)
        .glassCardStyle()
    }
    
    private var levelBadge: some View {
        ZStack {
            Circle()
                .stroke(Color.appBrand.opacity(0.15), lineWidth: 6)
                .frame(width: 72, height: 72)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.appBrand, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .frame(width: 72, height: 72)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .fill(Color.appBrandLight.opacity(0.5))
                .frame(width: 56, height: 56)
                .overlay {
                    Image(systemName: levelIcon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Color.appBrand)
                }
        }
    }
    
    private var statsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text("Level \(currentLevel)")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.appTextPrimary)
                
                Text("•")
                    .foregroundStyle(Color.appTextSecondary)
                
                Text(levelTitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.appBrand)
            }
            
            HStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.appBrand)
                
                Text("\(currentXP) / \(xpForNextLevel) XP")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.appTextSecondary)
            }
            
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.appBrand)
                
                Text("\(lessonsCompleted) lessons completed")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
    }
}

// MARK: - Glass Card Style
struct GlassCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.85))
                    
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(Color(hex: "E2E2E2").opacity(0.6), lineWidth: 1)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: .black.opacity(0.10), radius: 2, x: 0, y: 1)
            .shadow(color: .black.opacity(0.10), radius: 3, x: 0, y: 1)
    }
}

// MARK: - Glass Circle Style
struct GlassCircleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                    
                    Circle()
                        .fill(Color.white.opacity(0.85))
                    
                    Circle()
                        .strokeBorder(Color(hex: "E2E2E2").opacity(0.6), lineWidth: 1)
                }
            )
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.10), radius: 2, x: 0, y: 1)
            .shadow(color: .black.opacity(0.10), radius: 3, x: 0, y: 1)
    }
}

extension View {
    func glassCardStyle() -> some View {
        modifier(GlassCardStyle())
    }
    
    func glassCircleStyle() -> some View {
        modifier(GlassCircleStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        LevelProgressCard(
            currentLevel: 7,
            currentXP: 450,
            xpForNextLevel: 600,
            lessonsCompleted: 23
        )
        
        HStack(spacing: 12) {
            StatCard(
                title: "Hours Reclaimed",
                value: "24",
                icon: "clock.fill",
                trend: .up,
                trendValue: "+12%"
            )
            StatCard(
                title: "Current Streak",
                value: "12",
                subtitle: "days",
                icon: "flame.fill"
            )
        }
    }
    .padding()
}
