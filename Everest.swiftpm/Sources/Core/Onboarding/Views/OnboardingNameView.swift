import SwiftUI

struct OnboardingNameView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                OnboardingHeader(action: viewModel.previousStep)
                
                // MARK: - Progress Bar
                OnboardingProgressBar(currentStep: 0) // Step 1
                
                // MARK: - Content
                VStack(alignment: .leading, spacing: 32) {
                    // Title Group
                    VStack(alignment: .leading, spacing: 12) {
                        OnboardingTitle(
                            text: "What should we\ncall you?",
                            alignment: .leading
                        )
                        
                        OnboardingSubtitle(
                            text: "Help us personalize your\nexperience in Everest.",
                            alignment: .leading
                        )
                    }
                    
                    // Input Field
                    VStack(alignment: .leading, spacing: 8) {
                        // Container
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                if !viewModel.name.isEmpty {
                                    Text("Display Name")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundStyle(Color.appBrand)
                                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                                }
                                
                                TextField("e.g. Ethan", text: $viewModel.name)
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundStyle(Color.appTextPrimary)
                                    .tint(Color.appBrand)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "pencil")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.appBrand)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color.appCardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(viewModel.name.isEmpty ? Color.clear : Color.appBrand.opacity(0.3), lineWidth: 1)
                        )
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.name.isEmpty)
                    }
                    
                    // Info Box
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.appTextSecondary)
                            .padding(.top, 2)
                        
                        Text("You can always change your display name later in your profile settings.")
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
                
                Spacer()
                
                // MARK: - Footer
                OnboardingFooter(
                    currentStep: 1,
                    isEnabled: !viewModel.name.isEmpty,
                    action: viewModel.nextStep
                )
            }
        }
    }
}

#Preview {
    OnboardingNameView(viewModel: OnboardingViewModel())
}
