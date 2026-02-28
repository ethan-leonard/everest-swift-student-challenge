import SwiftUI

// MARK: - Onboarding Selection Row
struct OnboardingSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.appTextPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Color.appBrand)
                } else {
                    Circle()
                        .stroke(Color.appTextSecondary.opacity(0.3), lineWidth: 2)
                        .frame(width: 22, height: 22)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(isSelected ? Color.appBrand.opacity(0.1) : Color.appCardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(isSelected ? Color.appBrand : Color.clear, lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Onboarding Text Field
struct OnboardingTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.system(size: 17))
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.appCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.appTextSecondary.opacity(0.1), lineWidth: 1)
            )
            .padding(.horizontal, 24)
    }
}

// MARK: - Onboarding Option Card
struct OnboardingOptionCard: View {
    let title: String
    let subtitle: String?
    let icon: String // SF Symbol
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Circle()
                    .fill(isSelected ? Color.appBrand : Color.appBrand.opacity(0.1))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundStyle(isSelected ? .white : Color.appBrand)
                    )
                
                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 15))
                            .foregroundStyle(Color.appTextSecondary)
                    }
                }
                
                Spacer()
                
                // Radio Button
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.appBrand)
                        .background(Circle().fill(Color.white).padding(4))
                } else {
                    Circle()
                        .stroke(Color.appTextSecondary.opacity(0.2), lineWidth: 1.5)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(16)
            .background(isSelected ? Color.appBrand.opacity(0.05) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(isSelected ? Color.appBrand : Color.black.opacity(0.05), lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: isSelected ? Color.appBrand.opacity(0.1) : Color.black.opacity(0.02), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Onboarding Grid Card
struct OnboardingGridCard: View {
    let title: String
    let icon: String // SF Symbol
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // Icon Circle
                Circle()
                    .fill(isSelected ? Color.appBrand : Color.appBrand.opacity(0.1))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundStyle(isSelected ? .white : Color.appBrand)
                    )
                
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.appTextPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(isSelected ? Color.appBrand.opacity(0.05) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(isSelected ? Color.appBrand : Color.black.opacity(0.05), lineWidth: isSelected ? 2 : 1)
            )
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.appBrand)
                        .background(Circle().fill(Color.white).padding(2))
                        .padding(12)
                }
            }
            .shadow(color: isSelected ? Color.appBrand.opacity(0.1) : Color.black.opacity(0.02), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.plain)
    }
}
