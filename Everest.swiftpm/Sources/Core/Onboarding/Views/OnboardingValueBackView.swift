import SwiftUI

struct OnboardingValueBackView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    private var weeklyHoursReclaimed: Int {
        let diff = max(0, viewModel.dailyScreenTimeAvgHours - viewModel.desiredScreenTimeHours)
        return Int(round(diff * 7))
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                contentView
                
                Spacer()
                
                footerButton
            }
        }
        .navigationBarHidden(true)
    }
    
    private var contentView: some View {
        VStack(spacing: 0) {
            OnboardingHeader(action: viewModel.previousStep)
            
            Spacer().frame(height: 20)
            
            heroVisualization
            
            Spacer().frame(height: 40)
            
            titleSection
            
            Spacer().frame(height: 32)
            
            featureCards
            
            Spacer().frame(height: 32)
        }
    }
    
    private var heroVisualization: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 48, style: .continuous)
                .fill(Color(red: 240/255, green: 247/255, blue: 244/255))
                .frame(width: 166, height: 166)
                .shadow(color: .black.opacity(0.06), radius: 20, x: 0, y: 10)
                .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 2)
            
            VStack(spacing: -2) {
                Text("\(weeklyHoursReclaimed)")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(Color(red: 74/255, green: 124/255, blue: 89/255))
                
                Text("HOURS / WEEK")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color(red: 74/255, green: 124/255, blue: 89/255).opacity(0.7))
            }
            .frame(width: 166, height: 166)
            
            Circle()
                .fill(.white)
                .frame(width: 44, height: 44)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                .overlay(
                    Image(systemName: "clock.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color(red: 74/255, green: 124/255, blue: 89/255))
                )
                .offset(x: 10, y: -10)
        }
        .rotationEffect(.degrees(5))
        .padding(.top, 20)
    }
    
    private var titleSection: some View {
        VStack(spacing: 8) {
            OnboardingTitle(
                text: "Everest can help you\nget ",
                highlightedText: "\(weeklyHoursReclaimed) hours back a week",
                alignment: .center
            )
            
            let nameString = viewModel.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "" : "\(viewModel.firstName), "
            OnboardingSubtitle(
                text: "Based on your habits, \(nameString)we've identified significant pockets of time for your potential.",
                alignment: .center
            )
        }
    }
    
    private var featureCards: some View {
        VStack(spacing: 12) {
            ValueFeatureRow(
                icon: "calendar",
                title: "Weekly Reclaim",
                subtitle: "Extra \(Int(round(viewModel.dailyScreenTimeAvgHours - viewModel.desiredScreenTimeHours))) hours every single day"
            )
        }
        .padding(.horizontal, 24)
    }
    
    private var footerButton: some View {
        OnboardingFooter(
            title: "Continue",
            currentStep: nil,
            isEnabled: true,
            action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                viewModel.nextStep()
            }
        )
    }
}

// MARK: - Components

struct ValueFeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.appBrand.opacity(0.08))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.appBrand)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.appTextSecondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }
}

#Preview {
    OnboardingValueBackView(viewModel: OnboardingViewModel())
}
