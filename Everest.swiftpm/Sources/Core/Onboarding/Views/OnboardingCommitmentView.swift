import SwiftUI

struct OnboardingCommitmentView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var lines: [Line] = []
    
    // UI State
    @State private var isAnimatingCompletion = false
    @State private var showConfetti = false
    @State private var isLocked = false // Locking state
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            // Confetti Layer (Top level)
            if showConfetti {
                ConfettiView()
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 0) {
                // Header
                OnboardingHeader(action: {
                    viewModel.previousStep()
                })
                
                VStack(spacing: 32) {
                        
                        // Title Section
                        VStack(spacing: 12) {
                            OnboardingTitle(text: "Seal Your Commitment")
                            OnboardingSubtitle(text: "This signature marks the beginning of your ascent. Make it official.")
                        }
                        
                        // Signature Pad
                        VStack(spacing: 0) {
                            // Clear/Reset Button
                            HStack {
                                Spacer()
                                Button(action: clearSignature) {
                                    HStack(spacing: 4) {
                                        Image(systemName: isLocked ? "arrow.counterclockwise" : "eraser.fill")
                                            .font(.system(size: 10))
                                        Text(isLocked ? "RETRY" : "RESET")
                                            .font(.system(size: 11, weight: .bold))
                                    }
                                    .foregroundStyle(Color.appTextSecondary)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.appBackground)
                                    .clipShape(Capsule())
                                    .opacity(lines.isEmpty ? 0 : 1) // Hide if empty
                                    .animation(.default, value: lines.isEmpty)
                                }
                            }
                            .padding(12)
                            
                            // Drawing Area (Optimized)
                            GeometryReader { geometry in
                                ZStack {
                                    // Placeholder "X"
                                    HStack {
                                        Text("X")
                                            .font(.system(size: 32, weight: .medium))
                                            .foregroundStyle(Color.appTextSecondary.opacity(0.15))
                                            .padding(.leading, 32)
                                        Spacer()
                                    }
                                    
                                    // Baseline
                                    VStack {
                                        Spacer()
                                        Rectangle()
                                            .fill(Color.appTextSecondary.opacity(0.1))
                                            .frame(height: 1)
                                            .padding(.horizontal, 20)
                                            .padding(.bottom, 30)
                                    }
                                    
                                    // Canvas-based Drawing & Sparkles
                                    SignatureCanvas(lines: $lines, isLocked: $isLocked, onDrawingChanged: {
                                        // Parent callback
                                    })
                                    
                                    // Lock Overlay (blocks touches)
                                    if isLocked {
                                        Color.white.opacity(0.001)
                                    }
                                    
                                    // ⚡️ OFFICIAL STAMP ANIMATION
                                    if isAnimatingCompletion {
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.system(size: 80))
                                            .foregroundStyle(Color.appBrand)
                                            .background(
                                                Circle()
                                                    .fill(Color.white)
                                                    .frame(width: 80, height: 80)
                                            )
                                            .shadow(color: Color.appBrand.opacity(0.3), radius: 10, x: 0, y: 5)
                                            .rotationEffect(.degrees(-15)) // Jaunty angle
                                            .scaleEffect(showConfetti ? 1.0 : 2.5) // Slam effect
                                            .opacity(showConfetti ? 1.0 : 0.0)
                                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showConfetti)
                                    }
                                }
                            }
                            .frame(height: 120)
                            
                            Divider()
                                .opacity(0.5)
                            
                            // Footer Details
                            HStack {
                                HStack(spacing: 12) {
                                    // Profile Icon
                                    Circle()
                                        .fill(Color.appTextPrimary)
                                        .frame(width: 36, height: 36)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 16))
                                                .foregroundStyle(.white)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("SIGNATORY")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundStyle(Color.appTextSecondary)
                                            .tracking(1.0) // Official spacing
                                        Text(viewModel.firstName)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundStyle(Color.appTextPrimary)
                                    }
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("DATE")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(Color.appTextSecondary)
                                        .tracking(1.0)
                                    Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(Color.appTextPrimary)
                                    
                                }
                            }
                            .padding(16)
                            .background(Color.appBackground.opacity(0.3))
                        }
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                        )
                        // Deeper, more "paper" shadow
                        .shadow(color: .black.opacity(0.06), radius: 20, x: 0, y: 10)
                        .padding(.horizontal, 24)
                        
                        // Personal Pledge
                        HStack(spacing: 16) {
                            Circle() // Shield Icon
                                .fill(Color.appBrand.opacity(0.1))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Image(systemName: "hand.raised.fill") // More active icon
                                        .font(.system(size: 20))
                                        .foregroundStyle(Color.appBrand)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Personal Pledge")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Color.appTextPrimary)
                                
                                Text("I hereby commit to prioritizing my growth, clarity, and discipline.")
                                    .font(.system(size: 12))
                                    .italic()
                                    .foregroundStyle(Color.appTextSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineSpacing(2)
                            }
                        }
                        .padding(20)
                        .background(Color.appBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .padding(.horizontal, 24)
                        
                }
                .padding(.top, 30)
                
                Spacer()
                
                // Footer
                VStack {
                    Button(action: completeCommitment) {
                        HStack {
                            if isAnimatingCompletion {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 20, weight: .bold))
                                    .transition(.scale)
                            } else {
                                Text("Make It Official")
                                    .font(.system(size: 18, weight: .bold))
                                    .transition(.opacity)
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .bold))
                                    .transition(.opacity)
                            }
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(lines.isEmpty ? Color.appTextSecondary.opacity(0.3) : Color.appBrand)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(color: (lines.isEmpty && !isAnimatingCompletion) ? .clear : Color.appBrand.opacity(0.3), radius: 10, y: 5)
                        .scaleEffect(isAnimatingCompletion ? 0.95 : 1.0)
                        .animation(.spring(response: 0.3), value: isAnimatingCompletion)
                    }
                    .disabled(lines.isEmpty || isAnimatingCompletion)
                    
                    Text("SECURELY ENCRYPTED")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.appTextSecondary.opacity(0.5))
                        .tracking(2)
                        .padding(.top, 16)
                }
                .padding(24)
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Logic
    
    private func completeCommitment() {
        guard !lines.isEmpty else { return }
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        
        withAnimation {
            isAnimatingCompletion = true
            showConfetti = true
        }
        
        // Haptic Success immediately
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        // Brief delay before nav
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            viewModel.nextStep()
        }
    }
    
    private func clearSignature() {
        lines.removeAll()
        isLocked = false // Unlock
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

#Preview {
    OnboardingCommitmentView(viewModel: OnboardingViewModel())
}
