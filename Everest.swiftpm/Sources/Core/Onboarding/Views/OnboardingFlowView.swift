import SwiftUI

/// Coordinator view for the expanded onboarding flow.
/// Orchestrates the 14-step flow requested from original app.
struct OnboardingFlowView: View {
    @State private var viewModel = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            switch viewModel.currentStep {
            case 0: OnboardingOpeningView(viewModel: viewModel).transition(currentTransition)
            case 1: OnboardingNameView(viewModel: viewModel).transition(currentTransition)
            case 2: OnboardingAgeView(viewModel: viewModel).transition(currentTransition)
            case 3: OnboardingOccupationView(viewModel: viewModel).transition(currentTransition)
            case 4: OnboardingGoalsView(viewModel: viewModel).transition(currentTransition)
            case 5: OnboardingScreenTimeAvgView(viewModel: viewModel).transition(currentTransition)
            case 6: OnboardingScreenTimeGoalView(viewModel: viewModel).transition(currentTransition)
            case 7: OnboardingReferralSourceView(viewModel: viewModel).transition(currentTransition)
            case 8: OnboardingCalculatingView(viewModel: viewModel).transition(currentTransition)
            case 9: OnboardingProjectionView(viewModel: viewModel).transition(currentTransition)
            case 10: OnboardingComparisonView(viewModel: viewModel).transition(currentTransition)
            case 11: OnboardingValueBackView(viewModel: viewModel).transition(currentTransition)
            case 12: OnboardingPreparingPlanView(viewModel: viewModel).transition(currentTransition)
            case 13: OnboardingCommitmentView(viewModel: viewModel).transition(currentTransition)
            default:
                // Onboarding complete — save data and mark as done
                Color.appBackground
                    .ignoresSafeArea()
                    .onAppear {
                        Task {
                            try? await viewModel.saveOnboardingData()
                            UserDefaults.standard.set(true, forKey: StorageKey.hasCompletedOnboarding)
                        }
                    }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: viewModel.currentStep)
    }
    
    private var currentTransition: AnyTransition {
        // Steps 1-7: Quiz Transitions
        if viewModel.currentStep >= 1 && viewModel.currentStep <= 7 {
            return .asymmetric(
                insertion: .move(edge: viewModel.navigationDirection == .forward ? .trailing : .leading),
                removal: .move(edge: viewModel.navigationDirection == .forward ? .leading : .trailing)
            )
        }
        // Steps 9-11: Data Projection & Comparison
        if viewModel.currentStep >= 9 && viewModel.currentStep <= 11 {
            return .opacity
        }
        // Default: Professional Slide
        return .asymmetric(
            insertion: .move(edge: viewModel.navigationDirection == .forward ? .trailing : .leading),
            removal: .move(edge: viewModel.navigationDirection == .forward ? .leading : .trailing)
        )
    }
}
