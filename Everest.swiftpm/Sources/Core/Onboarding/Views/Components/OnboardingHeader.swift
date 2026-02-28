import SwiftUI

// MARK: - Onboarding Header
struct OnboardingHeader: View {
    var action: (() -> Void)? = nil
    var showBackButton: Bool = true
    var isHighContrast: Bool = false
    
    var body: some View {
        ZStack {
            HStack(spacing: 6) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(isHighContrast ? .white : Color.appBrand)
                Text("Everest")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(isHighContrast ? .white : Color.appBrand)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background {
                if isHighContrast {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.white.opacity(0.1))
                        )
                } else {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                }
            }
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isHighContrast ? .white.opacity(0.3) : Color.appBrand.opacity(0.15), lineWidth: 1)
            )
            
            HStack {
                if showBackButton, let action = action {
                    OnboardingBackButton(action: action)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }
}

// MARK: - Onboarding Progress Bar
struct OnboardingProgressBar: View {
    let currentStep: Int
    var totalSteps: Int = 7
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(index <= currentStep ? Color.appBrand : Color.appTextSecondary.opacity(0.1))
                    .frame(maxWidth: .infinity)
                    .frame(height: 4)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 32)
    }
}
