import SwiftUI

// MARK: - Onboarding Button
struct OnboardingButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            Haptics.shared.play(.medium)
            action()
        }) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                Image(systemName: "arrow.right")
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(isEnabled ? Color.appBrand : Color.appTextSecondary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .shadow(color: isEnabled ? Color.appBrand.opacity(0.3) : .clear, radius: 15, x: 0, y: 8)
        }
        .disabled(!isEnabled)
        .padding(.horizontal, 24)
    }
}

// MARK: - Onboarding Back Button
struct OnboardingBackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.left")
                .font(.system(size: 18))
                .foregroundStyle(Color.appTextPrimary)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(Color.appTextSecondary.opacity(0.05))
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
        }
    }
}

enum OnboardingFooterStyle {
    case primary
    case secondary(color: Color)
}

// MARK: - Onboarding Footer
struct OnboardingFooter: View {
    var title: String = "Continue"
    let currentStep: Int?
    var totalSteps: Int = 7
    let isEnabled: Bool
    let action: () -> Void
    var showGradient: Bool = true
    var style: OnboardingFooterStyle = .primary
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                Haptics.shared.play(.medium)
                action()
            }) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundStyle(buttonForegroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(buttonBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .shadow(color: isEnabled ? shadowColor : .clear, radius: 15, x: 0, y: 8)
            }
            .disabled(!isEnabled)
            
            if let step = currentStep {
                Text("Step \(step) of \(totalSteps)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        .padding(24)
        .background(
            Group {
                if showGradient {
                    LinearGradient(
                        colors: [.white.opacity(0), .white, .white],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        )
    }
    
    private var buttonBackgroundColor: Color {
        if !isEnabled { return Color.appTextSecondary.opacity(0.3) }
        switch style {
        case .primary:
            return Color.appBrand
        case .secondary:
            return .white
        }
    }
    
    private var buttonForegroundColor: Color {
        if !isEnabled { return .white }
        switch style {
        case .primary:
            return .white
        case .secondary(let color):
            return color
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .primary:
            return Color.appBrand.opacity(0.3)
        case .secondary:
            return .black.opacity(0.1)
        }
    }
}
