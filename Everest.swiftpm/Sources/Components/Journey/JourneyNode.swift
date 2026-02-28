import SwiftUI

// MARK: - Journey Node
/// Circular milestone on the journey path
struct JourneyNode: View {
    let milestone: JourneyMilestone
    let size: CGFloat
    
    init(milestone: JourneyMilestone, size: CGFloat = 56) {
        self.milestone = milestone
        self.size = size
    }
    
    private var backgroundColor: Color {
        switch milestone.state {
        case .completed: return Color.appBrand
        case .active: return Color.appBrandLight
        case .locked: return Color.appCardBackground
        }
    }
    
    private var iconColor: Color {
        switch milestone.state {
        case .completed: return .white
        case .active: return Color.appBrand
        case .locked: return Color.appTextSecondary
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Circle with icon
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: size, height: size)
                
                // Pulsing ring for active state
                if milestone.state == .active {
                    Circle()
                        .stroke(Color.appBrand.opacity(0.3), lineWidth: 3)
                        .frame(width: size + 12, height: size + 12)
                }
                
                Image(systemName: milestone.icon)
                    .font(.system(size: size * 0.35, weight: .medium))
                    .foregroundStyle(iconColor)
            }
            
            // Labels
            if !milestone.title.isEmpty {
                VStack(spacing: 2) {
                    Text(milestone.title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.appTextPrimary)
                    
                    if !milestone.subtitle.isEmpty {
                        Text(milestone.subtitle)
                            .font(.captionSmall)
                            .foregroundStyle(Color.appTextSecondary)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: 24) {
        JourneyNode(milestone: JourneyMilestone(
            id: "1", title: "Base Camp", subtitle: "Beginner",
            icon: "tent.fill", state: .completed
        ))
        
        JourneyNode(milestone: JourneyMilestone(
            id: "2", title: "Ridge Walk", subtitle: "Intermediate",
            icon: "figure.walk", state: .active
        ))
        
        JourneyNode(milestone: JourneyMilestone(
            id: "3", title: "Summit", subtitle: "Expert",
            icon: "lock.fill", state: .locked
        ))
    }
    .padding()
}
