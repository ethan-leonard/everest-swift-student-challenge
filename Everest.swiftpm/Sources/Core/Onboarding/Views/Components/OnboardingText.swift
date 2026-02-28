import SwiftUI

// MARK: - Onboarding Title
struct OnboardingTitle: View {
    let text: String
    var highlightedText: String? = nil
    var alignment: TextAlignment = .center
    
    var body: some View {
        Group {
            if let highlightedText = highlightedText {
                Text(text) + Text(highlightedText).foregroundStyle(Color.appBrand)
            } else {
                Text(text)
            }
        }
        .font(.system(size: 32, weight: .bold))
        .foregroundStyle(Color.appTextPrimary)
        .multilineTextAlignment(alignment)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: alignment == .center ? .center : .leading)
        .padding(.horizontal, 24)
    }
}

// MARK: - Onboarding Subtitle
struct OnboardingSubtitle: View {
    let text: String
    var alignment: TextAlignment = .center
    
    var body: some View {
        Text(text)
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(Color.appTextSecondary)
            .multilineTextAlignment(alignment)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: alignment == .center ? .center : .leading)
            .padding(.horizontal, alignment == .center ? 32 : 24)
            .padding(.top, 8)
            .lineSpacing(4)
    }
}
