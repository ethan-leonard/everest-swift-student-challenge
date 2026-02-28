import SwiftUI

struct OnboardingReferralSourceView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    // Options
    let options = [
        ReferralOption(id: "Instagram", icon: "camera.fill"),
        ReferralOption(id: "TikTok", icon: "music.note"),
        ReferralOption(id: "Influencer", icon: "star.fill"),
        ReferralOption(id: "Reddit", icon: "bubble.left.and.bubble.right.fill"),
        ReferralOption(id: "App Store", icon: "app.badge.fill"),
        ReferralOption(id: "Other", icon: "ellipsis")
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                OnboardingHeader(action: viewModel.previousStep)
                
                // MARK: - Progress Bar
                OnboardingProgressBar(currentStep: 6) // Step 7
                
                // MARK: - Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // Title
                        VStack(alignment: .leading, spacing: 12) {
                            OnboardingTitle(
                                text: viewModel.firstName.isEmpty ? "How did you\nfind us?" : "How did you\nfind us, \(viewModel.firstName)?",
                                alignment: .leading
                            )
                            
                            OnboardingSubtitle(
                                text: "We'd love to know how you discovered Everest.",
                                alignment: .leading
                            )
                        }
                        
                        // Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(options) { option in
                                OnboardingGridCard(
                                    title: option.id,
                                    icon: option.icon,
                                    isSelected: viewModel.referralSource == option.id,
                                    action: { viewModel.referralSource = option.id }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                
                // MARK: - Footer
                OnboardingFooter(
                    currentStep: 7,
                    isEnabled: !viewModel.referralSource.isEmpty,
                    action: viewModel.nextStep
                )
            }
        }
    }
}

// MARK: - Models
struct ReferralOption: Identifiable {
    let id: String
    let icon: String
}

#Preview {
    OnboardingReferralSourceView(viewModel: OnboardingViewModel())
}
