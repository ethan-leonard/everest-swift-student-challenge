import SwiftUI

struct StreakCelebrationView: View {
    @Binding var streakCount: Int
    @State private var pulseFlame = false
    let onContinue: () -> Void
    
    var body: some View {
        ZStack {
            Color(hex: "5C5470")
                .ignoresSafeArea()
            
            ConfettiView()
            
            VStack(spacing: 32) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color(hex: "FF6B35").opacity(0.2))
                        .frame(width: 200, height: 200)
                        .scaleEffect(pulseFlame ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulseFlame)
                    
                    Image(systemName: "flame.fill")
                        .font(.system(size: 120))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "FF6B35"), Color(hex: "F7C94B")],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .shadow(color: Color(hex: "FF6B35").opacity(0.5), radius: 30, y: 10)
                        .rotationEffect(.degrees(0))
                }
                
                VStack(spacing: 8) {
                    Text("You're on a")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 0) {
                        Text("\(streakCount)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(Color(hex: "F7C94B"))
                            .contentTransition(.numericText(value: Double(streakCount)))
                        
                        Text("-day streak!")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .multilineTextAlignment(.center)
                
                Spacer()
                
                Button(action: onContinue) {
                    Text("Continue")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.appTextPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity)
        .zIndex(4)
        .onAppear {
            pulseFlame = true
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred() // Impact on appear
            
            // Mock increment streak
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    streakCount += 1
                }
                Haptics.shared.play(.success) // Success on increment
            }
        }
    }
}
