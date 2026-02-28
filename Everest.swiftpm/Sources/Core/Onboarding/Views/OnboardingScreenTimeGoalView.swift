import SwiftUI

struct OnboardingScreenTimeGoalView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    @State private var selectedHours: Int = 1
    @State private var lastAngle: Double = 0
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                OnboardingHeader(action: viewModel.previousStep)
                
                OnboardingProgressBar(currentStep: 5)
                
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 12) {
                        OnboardingTitle(
                            text: "What is your\ntarget daily goal?",
                            alignment: .leading
                        )
                        
                        OnboardingSubtitle(
                            text: "Rotate the dial to set your goal.",
                            alignment: .leading
                        )
                    }
                    
                    Spacer()
                    
                    GeometryReader { geometry in
                        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        
                        ZStack {
                            GoalDialTickMarks(selectedValue: selectedHours, maxValue: 8)
                            
                            Circle()
                                .fill(Color.white)
                                .frame(width: 160, height: 160)
                                .shadow(color: Color.black.opacity(0.06), radius: 16, y: 4)
                            
                            VStack(spacing: 2) {
                                Text("\(selectedHours)")
                                    .font(.system(size: 64, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.appBrand)
                                
                                Text("hours / day")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color.appTextSecondary)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let vector = CGVector(
                                        dx: value.location.x - center.x,
                                        dy: value.location.y - center.y
                                    )
                                    let angle = atan2(vector.dy, vector.dx) * 180 / .pi
                                    
                                    var delta = angle - lastAngle
                                    
                                    if delta > 180 { delta -= 360 }
                                    if delta < -180 { delta += 360 }
                                    
                                    if abs(delta) > 25 {
                                        let direction = delta > 0 ? 1 : -1
                                        let newValue = max(1, min(8, selectedHours + direction))
                                        if newValue != selectedHours {
                                            selectedHours = newValue
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        }
                                        lastAngle = angle
                                    }
                                }
                                .onEnded { _ in
                                    lastAngle = 0
                                }
                        )
                        .onAppear {
                            lastAngle = 0
                        }
                    }
                    .frame(height: 260)
                    
                    Spacer()

                }
                .padding(.horizontal, 24)
                
                OnboardingFooter(
                    currentStep: 6,
                    isEnabled: true,
                    action: {
                        viewModel.desiredScreenTimeHours = Double(selectedHours)
                        viewModel.nextStep()
                    }
                )
            }
        }
        .onAppear {
            let hours = Int(viewModel.desiredScreenTimeHours)
            selectedHours = hours > 0 ? hours : 1
        }
    }
}

struct GoalDialTickMarks: View {
    let selectedValue: Int
    let maxValue: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.appBrand.opacity(0.08), lineWidth: 3)
                .frame(width: 220, height: 220)
            
            ForEach(0..<24, id: \.self) { index in
                let angle = Double(index) * 15.0 - 90
                let isMajor = index % 3 == 0
                let tickIndex = index * maxValue / 24
                let isActive = tickIndex < selectedValue
                
                Rectangle()
                    .fill(isActive ? Color.appBrand : Color.appBrand.opacity(0.15))
                    .frame(width: isMajor ? 3 : 2, height: isMajor ? 12 : 6)
                    .offset(y: -100)
                    .rotationEffect(.degrees(angle))
            }
        }
    }
}

#Preview {
    OnboardingScreenTimeGoalView(viewModel: OnboardingViewModel())
}
