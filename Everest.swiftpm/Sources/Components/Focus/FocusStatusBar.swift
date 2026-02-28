import SwiftUI

// MARK: - Focus Status Bar (Above Tab Bar)
// Animated pill that shows focus status, positioned above the navigation bar

struct FocusStatusBar: View {
    private let breakService = BreakService.shared
    var onTakeBreak: () -> Void
    var isHidden: Bool = false
    
    @State private var pulseAnimation = false
    
    var body: some View {
        if breakService.isInScheduledHours && !isHidden {
            HStack(spacing: 12) {
                if breakService.isBreakActive {
                    // Break Active State
                    breakActiveContent
                } else {
                    // Focus Active State
                    focusActiveContent
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                ZStack {
                    // Base glass
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                    
                    // Gradient overlay
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: breakService.isBreakActive 
                                    ? [Color.orange.opacity(0.15), Color.yellow.opacity(0.1)]
                                    : [Color.appBrand.opacity(0.15), Color.blue.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Animated border
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: breakService.isBreakActive
                                    ? [Color.orange.opacity(pulseAnimation ? 0.6 : 0.2),
                                       Color.yellow.opacity(pulseAnimation ? 0.3 : 0.1)]
                                    : [Color.appBrand.opacity(pulseAnimation ? 0.6 : 0.2), 
                                       Color.appBrand.opacity(pulseAnimation ? 0.3 : 0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            )
            .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            ))
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    pulseAnimation = true
                }
            }
        }
    }
    
    private var focusActiveContent: some View {
        Group {
            // Animated icon
            ZStack {
                Circle()
                    .fill(Color.appBrand.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                
                Image(systemName: "lock.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.appBrand)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Focus Active")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.appTextPrimary)
                
                Text(breakService.scheduleDescription)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.appTextSecondary)
            }
            
            Spacer()
            
            Button {
                Haptics.shared.play(.medium)
                onTakeBreak()
            } label: {
                Text("Take Break")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: [Color.appBrand, Color.appBrand.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color.appBrand.opacity(0.3), radius: 8, y: 4)
            }
        }
    }
    
    private var breakActiveContent: some View {
        Group {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.orange.opacity(0.3), Color.orange.opacity(0.1)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 20
                        )
                    )
                    .frame(width: 36, height: 36)
                    .scaleEffect(pulseAnimation ? 1.15 : 1.0)
                
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .yellow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("On Break")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
                
                Text("\(breakService.formattedRemainingTime) remaining")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.orange)
            }
            
            Spacer()
            
            Button {
                Haptics.shared.play(.medium)
                breakService.endBreak()
            } label: {
                Text("End Break")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: [Color.orange, Color.orange.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color.orange.opacity(0.3), radius: 8, y: 4)
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        FocusStatusBar(onTakeBreak: {})
    }
    .background(Color.appBackground)
}
