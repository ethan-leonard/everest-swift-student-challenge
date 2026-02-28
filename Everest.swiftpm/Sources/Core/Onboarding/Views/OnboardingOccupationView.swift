import SwiftUI

struct OnboardingOccupationView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    let occupations = [
        OccupationOption(id: "Healthcare", icon: "cross.case.fill"),
        OccupationOption(id: "Technology", icon: "desktopcomputer"),
        OccupationOption(id: "Creative", icon: "paintpalette.fill"),
        OccupationOption(id: "Corporate", icon: "briefcase.fill"),
        OccupationOption(id: "Education", icon: "book.closed.fill"),
        OccupationOption(id: "Student", icon: "graduationcap.fill")
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                OnboardingHeader(action: viewModel.previousStep)
                
                // MARK: - Progress Bar
                OnboardingProgressBar(currentStep: 2) // Step 3 (0,1,2)
                
                // MARK: - Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // Title
                        VStack(alignment: .leading, spacing: 12) {
                            OnboardingTitle(
                                text: "What is your\noccupation, \(viewModel.firstName)?",
                                alignment: .leading
                            )
                            
                            OnboardingSubtitle(
                                text: "Daily stress and movement patterns vary greatly by profession.",
                                alignment: .leading
                            )
                        }
                        
                        // Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(occupations) { option in
                                OnboardingGridCard(
                                    title: option.id,
                                    icon: option.icon,
                                    isSelected: viewModel.occupation == option.id,
                                    action: { viewModel.occupation = option.id }
                                )
                            }
                        }
                        
                        // Info Box
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.appTextSecondary)
                                .padding(.top, 2)
                            
                            Text("We use this to tailor your daily stress relief recommendations.")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.appTextSecondary)
                                .lineSpacing(2)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                                .background(Color.appCardBackground)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                
                // MARK: - Footer
                OnboardingFooter(
                    currentStep: 3,
                    isEnabled: !viewModel.occupation.isEmpty,
                    action: viewModel.nextStep
                )
            }
        }
    }
}

struct OccupationOption: Identifiable {
    let id: String
    let icon: String // SF Symbol
}

#Preview {
    OnboardingOccupationView(viewModel: OnboardingViewModel())
}
