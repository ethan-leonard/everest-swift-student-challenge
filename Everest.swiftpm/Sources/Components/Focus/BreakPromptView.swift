import SwiftUI

// MARK: - Break Prompt View
// Shows before opening lesson when user taps "Take Break"
// Explains that completing the lesson earns a 10 minute break

struct BreakPromptView: View {
    var onContinue: () -> Void
    var onCancel: () -> Void
    
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }
            
            // Card
            VStack(spacing: 24) {
                // Icon
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.appBrand.opacity(0.2), Color.clear],
                                center: .center,
                                startRadius: 30,
                                endRadius: 70
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 72, height: 72)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(Color.appBrand)
                }
                
                // Text
                VStack(spacing: 8) {
                    Text("Earn Your Break")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                    
                    Text("Complete this lesson to unlock\na 10-minute break from focus mode.")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.appTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                
                // Reward indicator
                HStack(spacing: 12) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.orange)
                    
                    Text("10 minutes of free time")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.appTextPrimary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.orange.opacity(0.1))
                )
                
                // Buttons
                VStack(spacing: 12) {
                    Button {
                        Haptics.shared.play(.medium)
                        onContinue()
                    } label: {
                        HStack(spacing: 8) {
                            Text("Start Lesson")
                                .font(.system(size: 17, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            LinearGradient(
                                colors: [Color.appBrand, Color.appBrand.opacity(0.85)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: Color.appBrand.opacity(0.3), radius: 8, y: 4)
                    }
                    
                    Button {
                        onCancel()
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.appTextSecondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                    }
                }
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.15), radius: 24, y: 12)
            )
            .padding(.horizontal, 32)
            .scaleEffect(showContent ? 1 : 0.9)
            .opacity(showContent ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
}

#Preview {
    BreakPromptView(onContinue: {}, onCancel: {})
}
