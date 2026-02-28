import SwiftUI

struct OnboardingProjectionView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var showHero = false
    @State private var showDetails = false // Controls Stat Card & Footer
    @State private var yearCount: Int = 0
    @State private var scaleEffect: CGFloat = 0.5
    @State private var flickerOpacity: Double = 1.0
    
    // (State Removed)
    
    // Calculation Logic
    var projectedYears: Int {
        let age = Int(viewModel.age) ?? 25
        let remainingYears = Double(max(0, 80 - age))
        let dailyHours = viewModel.dailyScreenTimeAvgHours
        let yearsLost = (dailyHours / 24.0) * remainingYears
        return max(1, Int(yearsLost))
    }
    
    var daysLost: Int {
        return projectedYears * 365
    }
    
    var body: some View {
        ZStack {
            // Dark Background
            LinearGradient(
                colors: [Color(hex: "0B1221"), Color(hex: "000000")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Grid Pattern Overlay
            GridPattern()
                .opacity(0.1)
                .mask(
                    LinearGradient(colors: [.white, .clear], startPoint: .top, endPoint: .bottom)
                )
            
            VStack(spacing: 0) {
                // MARK: - Header (Custom Badge)
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "clock.arrow.2.circlepath")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.appBrand)
                        Text("LIFE PROJECTION")
                            .font(.system(size: 11, weight: .black))
                            .foregroundStyle(Color.appBrand)
                            .tracking(1)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.white.opacity(0.15))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(.white.opacity(0.1), lineWidth: 1))
                }
                .padding(.top, 20)
                .opacity(showHero ? 1 : 0)
                .animation(.easeIn(duration: 0.8), value: showHero)
                
                Spacer()
                
                // MARK: - Hero Stat
                VStack(spacing: -24) { // Negative spacing to overlap line height
                    ZStack {
                        // Particles Background
                        if showHero {
                            ParticleSystem()
                                .frame(width: 300, height: 200)
                        }
                        
                        Text("\(yearCount) YEARS")
                            .font(.system(size: 68, weight: .heavy))
                            .foregroundStyle(Color.yellow) // Reverted to Yellow
                            .opacity(flickerOpacity) // Neon Flicker
                            .overlay(
                                LinearGradient(
                                    colors: [Color(hex: "FFD60A"), Color(hex: "FFAC0A")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .mask(Text("\(yearCount) YEARS").font(.system(size: 68, weight: .heavy)))
                            )
                            // Core Glow
                            .shadow(color: Color(hex: "FFD60A").opacity(0.8), radius: 10, x: 0, y: 0)
                            // Ambient Haze Flicker
                            .shadow(color: Color(hex: "FFAC0A").opacity(flickerOpacity * 0.5), radius: 40, x: 0, y: 0)
                            .scaleEffect(scaleEffect)
                            // We do NOT animate the number change itself via spring to avoid "lag", we just animate scale
                            .animation(.spring(response: 0.6, dampingFraction: 0.5), value: scaleEffect)
                    }
                    
                    // Divider Dots
                    HStack(spacing: 6) {
                        Capsule().fill(Color(hex: "FFD60A")).frame(width: 24, height: 4)
                        Circle().fill(Color(hex: "FFD60A")).frame(width: 4, height: 4)
                        Capsule().fill(Color(hex: "FFD60A").opacity(0.5)).frame(width: 12, height: 4)
                    }
                    .opacity(showHero ? 1 : 0)
                    .animation(.easeIn(duration: 0.5).delay(0.2), value: showHero)
                }
                .padding(.bottom, 24)
                
                // MARK: - Explanation
                Group {
                    Text("You are currently on track to\nspend ")
                        .foregroundStyle(.white) +
                    Text("\(projectedYears) years")
                        .foregroundStyle(Color(hex: "FFD60A"))
                        .font(.system(size: 20, weight: .heavy)) +
                    Text(" of your remaining\nlife staring at your phone.")
                        .foregroundStyle(.white)
                }
                .font(.system(size: 20, weight: .medium))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .shadow(color: Color(hex: "FFD60A").opacity(0.5), radius: 8, x: 0, y: 0)
                .padding(.horizontal, 32)
                .frame(height: 100, alignment: .top)
                .opacity(showDetails ? 1 : 0)
                .animation(.easeOut(duration: 0.8), value: showDetails)
                
                // MARK: - Stat Card
                VStack(spacing: 12) {
                    Text("\(daysLost.formatted()) DAYS OF DIGITAL NOISE")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color.white.opacity(0.7))
                        .tracking(2)
                    
                    HStack(spacing: 6) {
                        ForEach(0..<5) { i in
                            Circle()
                                .fill(Color(hex: "FFAC0A").opacity(i == 2 ? 1 : 0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 24)
                .padding(.top, 40)
                // Animation Modifiers
                .opacity(showDetails ? 1 : 0)
                .blur(radius: showDetails ? 0 : 10)
                .scaleEffect(showDetails ? 1 : 0.95)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showDetails)
                
                Spacer()
                
                // MARK: - Choice Divider
                HStack(spacing: 20) {
                    Rectangle().fill(.white.opacity(0.1)).frame(height: 1)
                    Text("THE CHOICE IS YOURS")
                        .font(.system(size: 11, weight: .black))
                        .foregroundStyle(.white.opacity(0.4))
                        .tracking(1)
                        .fixedSize(horizontal: true, vertical: false)
                    Rectangle().fill(.white.opacity(0.1)).frame(height: 1)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
                .opacity(showDetails ? 1 : 0)
                
                // MARK: - Footer (Button)
                OnboardingFooter(
                    title: "Change My Path",
                    currentStep: nil,
                    isEnabled: true,
                    action: {
                        let impact = UIImpactFeedbackGenerator(style: .heavy)
                        impact.impactOccurred()
                        viewModel.nextStep()
                    },
                    showGradient: false
                )
                .opacity(showDetails ? 1 : 0)
                .scaleEffect(showDetails ? 1 : 0.5)
            }
            .padding(.bottom, 40)
        }
        .task {
            // Start Sequence
            await runAnimationSequence()
        }
    }
    
// MARK: - Animation Sequence
    func runAnimationSequence() async {
        // 1. Reset
        yearCount = 0
        showHero = false
        showDetails = false
        scaleEffect = 0.5
        
        // 2. Reveal Hero
        withAnimation(.easeOut(duration: 1.2)) {
            showHero = true
            scaleEffect = 1.0
        }
        startFlicker()
        
        // 3. Count Up (1.5s - Balanced)
        await animateCount(to: projectedYears, duration: 1.5)
        
        // 4. Slam Effect
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        await MainActor.run { impact.impactOccurred() }
        
        // 5. Long pause for impact (0.8s)
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        // 6. Reveal Explanation & Details together (Sleek Fade)
        await MainActor.run {
            withAnimation(.easeOut(duration: 1.5)) {
                showDetails = true
            }
        }
    }
    
    // Counter Animation (Sequential)
    func animateCount(to target: Int, duration: Double) async {
        let steps = 40
        let stepDuration = UInt64((duration / Double(steps)) * 1_000_000_000)
        
        for i in 0...steps {
            try? await Task.sleep(nanoseconds: stepDuration)
            
            await MainActor.run {
                let progress = Double(i) / Double(steps)
                // Sine ease out for smooth "landing"
                let easedProgress = sin((progress * .pi) / 2)
                self.yearCount = Int(Double(target) * easedProgress)
                
                // Rapid haptics as numbers increase 
                Haptics.shared.play(.selection)
            }
        }
        await MainActor.run { self.yearCount = target }
    }
    
    // Neon Flicker Logic
    func startFlicker() {
        Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 150_000_000)
                await MainActor.run {
                    withAnimation(.easeIn(duration: 0.1)) {
                        self.flickerOpacity = Double.random(in: 0...1) > 0.8 ? Double.random(in: 0.7...0.9) : 1.0
                    }
                }
            }
        }
    }
}

// MARK: - Visual Helpers
// GridPattern and ParticleSystem moved to OnboardingEffects.swift

#Preview {
    OnboardingProjectionView(viewModel: OnboardingViewModel())
}
