import SwiftUI

// MARK: - Break Earned View
// Shows when user completes a lesson after tapping Take Break
// Similar aesthetic to the streak celebration screen

struct BreakEarnedView: View {
    var onStartBreak: () -> Void
    
    @State private var showContent = false
    @State private var showTimer = false
    @State private var showButton = false
    
    private let breakService = BreakService.shared
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(hex: "0a1a1f"),
                    Color(hex: "0D4D45"),
                    Color(hex: "0a1a1f")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating particles
            FloatingParticlesView()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Icon with glow
                if showContent {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.orange.opacity(0.3), Color.clear],
                                    center: .center,
                                    startRadius: 40,
                                    endRadius: 100
                                )
                            )
                            .frame(width: 180, height: 180)
                            .blur(radius: 20)
                        
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 120, height: 120)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                        
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 48, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .yellow],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .symbolEffect(.pulse, options: .repeating)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                // Title
                if showContent {
                    VStack(spacing: 12) {
                        Text("Break Earned")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text("You've unlocked 10 minutes of free time")
                            .font(.system(size: 17))
                            .foregroundStyle(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .transition(.opacity.combined(with: .offset(y: 20)))
                }
                
                // Timer display
                if showTimer {
                    VStack(spacing: 8) {
                        Text("10:00")
                            .font(.system(size: 64, weight: .bold, design: .monospaced))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.8)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Text("minutes")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
                
                // Start Break Button
                if showButton {
                    Button {
                        Haptics.shared.play(.heavy)
                        onStartBreak()
                    } label: {
                        HStack(spacing: 10) {
                            Text("Start Break")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: .orange.opacity(0.4), radius: 16, y: 8)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 50)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                showContent = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5)) {
                showTimer = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8)) {
                showButton = true
            }
            
            // Haptic feedback
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }
    }
}

// MARK: - Floating Particles
private struct FloatingParticlesView: View {
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<15, id: \.self) { i in
                FloatingParticle(
                    size: CGFloat.random(in: 4...12),
                    startX: CGFloat.random(in: 0...geo.size.width),
                    startY: CGFloat.random(in: 0...geo.size.height),
                    duration: Double.random(in: 4...8)
                )
            }
        }
    }
}

private struct FloatingParticle: View {
    let size: CGFloat
    let startX: CGFloat
    let startY: CGFloat
    let duration: Double
    
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 0.3
    
    var body: some View {
        Circle()
            .fill(Color.orange.opacity(opacity))
            .frame(width: size, height: size)
            .position(x: startX, y: startY)
            .offset(offset)
            .blur(radius: size / 4)
            .onAppear {
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                    offset = CGSize(
                        width: CGFloat.random(in: -50...50),
                        height: CGFloat.random(in: -80...80)
                    )
                    opacity = Double.random(in: 0.2...0.6)
                }
            }
    }
}

#Preview {
    BreakEarnedView(onStartBreak: {})
}
