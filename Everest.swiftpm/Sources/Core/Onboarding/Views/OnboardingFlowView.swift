import SwiftUI

/// Coordinator view for the condensed onboarding flow.
/// Steps: 0 = Calculating, 1 = Commitment, then complete → MainTabView
struct OnboardingFlowView: View {
    @State private var viewModel = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            switch viewModel.currentStep {
            case 0:
                OnboardingCalculatingView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
            case 1:
                OnboardingCommitmentView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
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
}
