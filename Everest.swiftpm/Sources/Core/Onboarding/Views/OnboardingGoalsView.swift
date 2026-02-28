import SwiftUI

struct OnboardingGoalsView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    // Goal Options
    let goalItems = [
        GoalOption(id: "Productivity", icon: "pencil.and.outline"),
        GoalOption(id: "Balance", icon: "arrow.up.right.and.arrow.down.left.rectangle"),
        GoalOption(id: "Better Sleep", icon: "moon.fill"),
        GoalOption(id: "Focus", icon: "target"),
        GoalOption(id: "Stress Relief", icon: "sun.max.fill"),
        GoalOption(id: "Health", icon: "heart.fill")
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                OnboardingHeader(action: viewModel.previousStep)
                
                // MARK: - Progress Bar
                OnboardingProgressBar(currentStep: 3) // Step 4
                
                // MARK: - Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // Title
                        VStack(alignment: .leading, spacing: 12) {
                            OnboardingTitle(
                                text: "What are your\ngoals, \(viewModel.firstName)?",
                                alignment: .leading
                            )
                            
                            OnboardingSubtitle(
                                text: "Choose the areas where you want to see the most change.",
                                alignment: .leading
                            )
                        }
                        
                        // Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(goalItems) { item in
                                OnboardingGridCard(
                                    title: item.id,
                                    icon: item.icon,
                                    isSelected: viewModel.selectedGoals.contains(item.id),
                                    action: {
                                        if viewModel.selectedGoals.contains(item.id) {
                                            viewModel.selectedGoals.remove(item.id)
                                        } else {
                                            viewModel.selectedGoals.insert(item.id)
                                        }
                                    }
                                )
                            }
                        }
                        
                        // Info Box
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.appTextSecondary)
                                .padding(.top, 2)
                            
                            Text("Your goals help us curate a personalized dashboard with exercises and insights that matter most to you.")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.appTextSecondary)
                                .lineSpacing(2)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.appCardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                
                // MARK: - Footer
                OnboardingFooter(
                    currentStep: 4,
                    isEnabled: !viewModel.selectedGoals.isEmpty,
                    action: viewModel.nextStep
                )
            }
        }
    }
}

// MARK: - Models
struct GoalOption: Identifiable {
    let id: String
    let icon: String
}

#Preview {
    OnboardingGoalsView(viewModel: OnboardingViewModel())
}
