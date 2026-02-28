import SwiftUI

struct LessonCompleteView: View {
    let xpEarned: Int
    @Binding var showCompletionScreen: Bool
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
                        .fill(Color.appBrand)
                        .frame(width: 160, height: 160)
                        .shadow(color: Color.appBrand.opacity(0.5), radius: 30, y: 10)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundStyle(.white)
                }
                .rotation3DEffect(.degrees(showCompletionScreen ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: showCompletionScreen)
                
                VStack(spacing: 12) {
                    Text("Lesson\nComplete!")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .offset(y: showCompletionScreen ? 0 : 20)
                        .opacity(showCompletionScreen ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.2), value: showCompletionScreen)
                    
                    Text("TOTAL LESSON XP")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white.opacity(0.7))
                        .tracking(1)
                        .offset(y: showCompletionScreen ? 0 : 20)
                        .opacity(showCompletionScreen ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.3), value: showCompletionScreen)
                    
                    Text("\(xpEarned)")
                        .font(.system(size: 56, weight: .bold))
                        .foregroundStyle(Color.appBrand)
                        .scaleEffect(showCompletionScreen ? 1 : 0.5)
                        .opacity(showCompletionScreen ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.4), value: showCompletionScreen)
                }
                
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
                .offset(y: showCompletionScreen ? 0 : 100)
                .opacity(showCompletionScreen ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: showCompletionScreen)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity)
        .zIndex(2)
    }
}
