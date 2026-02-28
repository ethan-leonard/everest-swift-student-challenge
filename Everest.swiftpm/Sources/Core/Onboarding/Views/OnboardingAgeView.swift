import SwiftUI

struct OnboardingAgeView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    // Age check helper
    private func isAgeIn(_ range: ClosedRange<Int>) -> Bool {
        guard let age = Int(viewModel.age) else { return false }
        return range.contains(age)
    }
    
    private func isAge(_ target: Int) -> Bool {
        guard let age = Int(viewModel.age) else { return false }
        return age >= target
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                OnboardingHeader(action: viewModel.previousStep)
                
                // MARK: - Progress Bar
                OnboardingProgressBar(currentStep: 1) // Step 2
                
                // MARK: - Content
                VStack(alignment: .leading, spacing: 32) {
                    // Title
                    VStack(alignment: .leading, spacing: 12) {
                        OnboardingTitle(
                            text: "How old are you, \(viewModel.firstName)?",
                            alignment: .leading
                        )
                        
                        OnboardingSubtitle(
                            text: "We use your age to create a personalized plan just for you.",
                            alignment: .leading
                        )
                    }
                    
                    // Age Input Box
                    HStack {
                        Spacer()
                        ZStack {
                            TextField("0", text: $viewModel.age)
                                .keyboardType(.numberPad)
                                .font(.system(size: 64, weight: .bold))
                                .foregroundStyle(Color.appBrand)
                                .frame(minWidth: 40)
                                .fixedSize(horizontal: true, vertical: false)
                                .multilineTextAlignment(.center)
                            
                            if viewModel.age.isEmpty {
                                BlinkingCursor()
                            }
                        }
                        
                        Text("Years")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(Color.appTextSecondary)
                            .padding(.top, 12)
                        Spacer()
                    }
                    .padding(.vertical, 40)
                    .background(Color.appCardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .stroke(Color.appTextSecondary.opacity(0.1), lineWidth: 1)
                    )
                    
                    // Pills
                    HStack(spacing: 12) {
                        AgePill(text: "18-24", isSelected: isAgeIn(18...24), action: { viewModel.age = "21" })
                        AgePill(text: "25-34", isSelected: isAgeIn(25...34), action: { viewModel.age = "30" })
                        AgePill(text: "35+", isSelected: isAge(35), action: { viewModel.age = "40" })
                    }
                }
                .padding(.horizontal, 24)
                
                
                Spacer()
                
                // MARK: - Footer
                OnboardingFooter(
                    currentStep: 2,
                    isEnabled: !viewModel.age.isEmpty,
                    action: viewModel.nextStep
                )
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.appBrand)
            }
        }
    }
}

struct AgePill: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 15, weight: isSelected ? .bold : .semibold))
                .foregroundStyle(isSelected ? Color.appBrand : Color.appTextPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isSelected ? Color.appBrand.opacity(0.1) : Color.appCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(isSelected ? Color.appBrand : Color.clear, lineWidth: 1.5)
                )
        }
    }
}

struct BlinkingCursor: View {
    @State private var isVisible = true
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.appBrand)
            .frame(width: 3, height: 48)
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                    isVisible = false
                }
            }
    }
}

#Preview {
    OnboardingAgeView(viewModel: OnboardingViewModel())
}

