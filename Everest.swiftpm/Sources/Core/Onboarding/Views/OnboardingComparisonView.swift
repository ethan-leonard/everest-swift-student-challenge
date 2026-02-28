import SwiftUI

struct OnboardingComparisonView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    @State private var showContent = false
    @State private var showAverageBar = false
    @State private var showUserBar = false
    @State private var displayDifference: Int = 0 // Counting state
    
    // Constants
    let averageYears = 2
    
    var projectedYears: Int {
        let age = Int(viewModel.age) ?? 25
        let remainingYears = Double(max(0, 80 - age))
        let dailyHours = viewModel.dailyScreenTimeAvgHours
        let yearsLost = (dailyHours / 24.0) * remainingYears
        return max(1, Int(yearsLost))
    }
    
    var difference: Int {
        return max(0, projectedYears - averageYears)
    }
    
    // Theme Color
    let themeRed = Color(hex: "AA5A5A") // Terra-cotta / Marsala
    
    var body: some View {
        ZStack {
            // Background
            themeRed
                .ignoresSafeArea()
            
            // Grid Pattern (Subtle)
            GridPattern()
                .opacity(0.1)
                .mask(LinearGradient(colors: [.white, .clear], startPoint: .top, endPoint: .bottom))
            
            VStack(spacing: 0) {
                // MARK: - Header (Custom Badge)
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 14, weight: .bold))
                        Text("BENCHMARK ANALYSIS")
                            .font(.system(size: 11, weight: .black))
                            .tracking(1)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.white.opacity(0.15))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(.white.opacity(0.2), lineWidth: 1))
                }
                .padding(.top, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : -20)
                
                Spacer()
                
                // MARK: - Hero Content
                VStack(spacing: 32) {
                    // Hero Number
                    VStack(spacing: 8) {
                        Text("+\(displayDifference) YEARS")
                            .font(.system(size: 60, weight: .heavy)) // Shrunk to 60
                            .foregroundStyle(.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                            .minimumScaleFactor(0.5) // Ensure it fits
                            .lineLimit(1)
                            .contentTransition(.numericText(value: Double(displayDifference)))
                        
                        // Underline
                        Capsule()
                            .fill(Color.white)
                            .frame(width: 140, height: 6)
                    }
                    
                    // Subtitle with Highlight Box
                    VStack(spacing: 4) {
                        HStack(spacing: 0) {
                            Text("That is ")
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text(" \(displayDifference) years ")
                                .foregroundColor(.white)
                                .font(.system(size: 22, weight: .bold))
                                .padding(.vertical, 4)
                                .padding(.horizontal, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.black.opacity(0.2)) // Dark highlight box
                                )
                            
                            Text(" higher than")
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .font(.system(size: 22, weight: .medium))
                        
                        Text("average.")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .multilineTextAlignment(.center)
                }
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.9)
                
                Spacer()
                
                // MARK: - Horizontal Bars
                VStack(spacing: 32) {
                    // Dynamic Scaling
                    let maxYears = max(Double(averageYears), Double(projectedYears))
                    let maxBarWidthRatio = 0.85
                    
                    // Average User
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("THE AVERAGE USER")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(Color.white.opacity(0.7))
                                .tracking(1)
                            Spacer()
                            Text("\(averageYears) Years")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(Color.white)
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.black.opacity(0.1))
                                Capsule()
                                    .fill(.ultraThinMaterial) // Glassy
                                    .overlay(
                                        Capsule()
                                            .fill(Color.white.opacity(0.3)) // Subtle white tint
                                    )
                                    .frame(width: showAverageBar ? (geo.size.width * (Double(averageYears) / maxYears) * maxBarWidthRatio) : 0)
                            }
                        }
                        .frame(height: 18)
                    }
                    
                    // User Projection
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("YOUR PROJECTION")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(Color.white)
                                .tracking(1)
                            Spacer()
                            Text("\(projectedYears) Years")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(Color.white)
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.black.opacity(0.1))
                                Capsule()
                                    .fill(.ultraThinMaterial) // Glassy
                                    .overlay(
                                        Capsule()
                                            .fill(Color.white.opacity(0.9)) // Brighter glassy
                                    )
                                    .frame(width: showUserBar ? (geo.size.width * (Double(projectedYears) / maxYears) * maxBarWidthRatio) : 0)
                                    .shadow(color: Color.white.opacity(0.2), radius: 8, x: 0, y: 0)
                            }
                        }
                        .frame(height: 18)
                    }
                    
                    // Data Source & Indicator
                    VStack(spacing: 12) {
                        Text("DATA BASED ON GLOBAL DIGITAL CONSUMPTION")
                            .font(.system(size: 9, weight: .black))
                            .foregroundStyle(Color.white.opacity(0.4))
                            .tracking(1)
                        
                        HStack(spacing: 6) {
                            ForEach(0..<5) { i in
                                Circle()
                                    .fill(Color.white.opacity(i == 3 ? 1 : 0.2))
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }
                    .padding(.top, 40)
                    .opacity(showUserBar ? 1 : 0)
                }
                .padding(.horizontal, 32)
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // MARK: - Footer section
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        Rectangle().fill(.white.opacity(0.1)).frame(height: 1)
                        Text("TIME DISCOVERY")
                            .font(.system(size: 11, weight: .black))
                            .foregroundStyle(.white.opacity(0.4))
                            .tracking(1)
                            .fixedSize(horizontal: true, vertical: false)
                        Rectangle().fill(.white.opacity(0.1)).frame(height: 1)
                    }
                    .padding(.horizontal, 32)
                    
                    OnboardingFooter(
                        title: "See How Everest Can Help",
                        currentStep: nil,
                        isEnabled: true,
                        action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            viewModel.nextStep()
                        },
                        showGradient: false,
                        style: .secondary(color: themeRed) // White bg with red text
                    )
                }
                .padding(.bottom, 20)
                .opacity(showContent ? 1 : 0)
            }
        }
        .task {
            // Strict Sequential Animation
            
            // 1. Reveal Content (Crisp, no float)
            try? await Task.sleep(nanoseconds: 300_000_000)
            await MainActor.run {
                withAnimation(.easeOut(duration: 1.0)) {
                    showContent = true
                    // Only start showing text, don't count yet
                }
            }
            
            // 1.5 Count up the difference
             await animateDifference(to: difference, duration: 1.5)
            
            // 2. Average Bar Fills (Duration 1.5s)
            try? await Task.sleep(nanoseconds: 500_000_000)
            await MainActor.run {
                withAnimation(.easeOut(duration: 1.5)) {
                    showAverageBar = true
                }
            }
            
            // 3. User Bar Fills (Wait until Average is DONE + slight pause)
            try? await Task.sleep(nanoseconds: 1_800_000_000)
            
            // "Spam" haptics during the fill
            Task {
                await playHapticTicks(count: 25, duration: 1.2)
            }
            
            await MainActor.run {
                withAnimation(.interpolatingSpring(stiffness: 40, damping: 12)) { // Slower, more suspenseful fill
                    showUserBar = true
                }
            }
        }
    }
    
    // Counting Helper (Adding Haptics)
    func animateDifference(to target: Int, duration: Double) async {
        let steps = 30
        let stepDuration = UInt64((duration / Double(steps)) * 1_000_000_000)
        
        for i in 0...steps {
            try? await Task.sleep(nanoseconds: stepDuration)
            
            await MainActor.run {
                let progress = Double(i) / Double(steps)
                let easedProgress = sin((progress * .pi) / 2) // Ease out
                self.displayDifference = Int(Double(target) * easedProgress)
                
                // Haptic Pop
                Haptics.shared.play(.selection)
            }
        }
        await MainActor.run { self.displayDifference = target }
    }
    
    // Helper for spamming haptics
    func playHapticTicks(count: Int, duration: Double) async {
        let interval = UInt64((duration / Double(count)) * 1_000_000_000)
        for _ in 0..<count {
            await MainActor.run {
                Haptics.shared.play(.light)
            }
            try? await Task.sleep(nanoseconds: interval)
        }
    }
}

#Preview {
    OnboardingComparisonView(viewModel: OnboardingViewModel())
}
