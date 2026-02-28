import SwiftUI

struct OnboardingCalculatingView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var progress: CGFloat = 0.1
    @State private var statusText: String = ""
    @State private var subStatusText: String = ""
    
    // Status config
    private let steps: [(progress: CGFloat, title: String, subtitle: String, duration: Double)] = [
        (0.1, "Analyzing daily habits...", "Identifying your peak focus windows", 0.5), // Delayed start
        (0.45, "Calculating potential...", "Benchmarking against top performers", 2.0),
        (0.75, "Structure & Routine...", "Mapping your ideal daily schedule", 3.5),
        (1.0, "Finalizing plan...", "Creating your personalized journey", 5.0)
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                OnboardingHeader(showBackButton: false)
                
                Spacer()
                
                // MARK: - Center Content
                VStack(spacing: 40) { // Increased spacing for better separation
                    VStack(spacing: 16) {
                        Text(statusText)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(Color.appTextPrimary)
                            .multilineTextAlignment(.center)
                            .contentTransition(.numericText()) // Smooth text transitions if iOS 16+
                            .animation(.snappy, value: statusText)
                        
                        Text(subStatusText)
                            .font(.system(size: 17))
                            .foregroundStyle(Color.appTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .animation(.snappy, value: subStatusText)
                    }
                    
                    // Progress Slider Animation
                    ZStack(alignment: .leading) {
                        // Track
                        Capsule()
                            .fill(Color.appTextSecondary.opacity(0.1))
                            .frame(height: 6) // Slightly thicker track
                        
                        // Fill
                        GeometryReader { geo in
                            Capsule()
                                .fill(Color.appBrand)
                                .frame(width: geo.size.width * progress)
                                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progress) // "Real" feeling spring
                        }
                        .frame(height: 6)
                        
                        // Hiker Icon (Handle)
                        GeometryReader { geo in
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 56, height: 56) // Slightly larger
                                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.appTextSecondary.opacity(0.1), lineWidth: 1)
                                    )
                                
                                Image(systemName: "figure.hiking")
                                    .font(.system(size: 26))
                                    .foregroundStyle(Color.appBrand)
                            }
                            // Center the circle on the progress point
                            .position(x: geo.size.width * progress, y: geo.size.height / 2)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progress)
                        }
                        .frame(height: 56)
                    }
                    .frame(height: 56)
                    .padding(.horizontal, 32)
                }
                
                Spacer()
                
                // MARK: - Footer Text
                HStack(spacing: 16) {
                    Rectangle()
                        .fill(Color.appTextSecondary.opacity(0.1))
                        .frame(height: 1)
                    
                    Text("PERSONALIZING FOR \(viewModel.firstName.uppercased())")
                        .font(.system(size: 12, weight: .bold)) // Smaller, cleaner font
                        .foregroundStyle(Color.appTextSecondary.opacity(0.8))
                        .fixedSize()
                        .tracking(1) // Add letter spacing for technical feel
                    
                    Rectangle()
                        .fill(Color.appTextSecondary.opacity(0.1))
                        .frame(height: 1)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            startSimulation()
        }
    }
    
    private func startSimulation() {
        // Leave fields blank for the first 0.5s so the view transition 
        // has time to finish before text pops in.
        
        for step in steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + step.duration) {
                self.statusText = step.title
                self.subStatusText = step.subtitle
                self.progress = step.progress
                Haptics.shared.play(.light)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            Haptics.shared.play(.success)
            viewModel.nextStep()
        }
    }
}

#Preview {
    OnboardingCalculatingView(viewModel: OnboardingViewModel())
}
