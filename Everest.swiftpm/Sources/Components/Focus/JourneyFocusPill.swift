import SwiftUI

// MARK: - Journey Focus Pill (Glass UI with Animated Border)
// Lives below the streak bar in JourneyView

struct JourneyFocusPill: View {
    private let breakService = BreakService.shared
    var onTakeBreak: () -> Void
    
    @State private var animateBorder = false
    
    var body: some View {
        if breakService.isInScheduledHours {
            HStack(spacing: 12) {
                if breakService.isBreakActive {
                    // Break active state
                    HStack(spacing: 8) {
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.orange)
                            .symbolEffect(.pulse, options: .repeating)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("On Break")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color.appTextPrimary)
                            
                            Text("\(breakService.formattedRemainingTime) left")
                                .font(.system(size: 15, weight: .bold, design: .monospaced))
                                .foregroundStyle(.orange)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        Haptics.shared.play(.medium)
                        breakService.endBreak()
                    } label: {
                        Text("End Break")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.appTextSecondary)
                            .clipShape(Capsule())
                    }
                } else {
                    // Focus active state
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.appBrand.opacity(0.15))
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: "lock.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.appBrand)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Focus Active")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.appTextPrimary)
                            
                            Text(breakService.scheduleDescription)
                                .font(.system(size: 12))
                                .foregroundStyle(Color.appTextSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        Haptics.shared.play(.medium)
                        onTakeBreak()
                    } label: {
                        HStack(spacing: 6) {
                            Text("Take Break")
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11, weight: .bold))
                        }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [Color.appBrand, Color.appBrand.opacity(0.85)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: Color.appBrand.opacity(0.3), radius: 6, y: 3)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                ZStack {
                    // Glass background
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                    
                    // Subtle gradient overlay
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: breakService.isBreakActive 
                                    ? [Color.orange.opacity(0.08), Color.yellow.opacity(0.04)]
                                    : [Color.appBrand.opacity(0.06), Color.white.opacity(0.02)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Animated border for focus mode
                    if !breakService.isBreakActive {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(
                                AngularGradient(
                                    colors: [
                                        Color.appBrand.opacity(animateBorder ? 0.5 : 0.2),
                                        Color.appBrand.opacity(0.1),
                                        Color.appBrand.opacity(animateBorder ? 0.4 : 0.15),
                                        Color.appBrand.opacity(0.1)
                                    ],
                                    center: .center,
                                    startAngle: .degrees(animateBorder ? 360 : 0),
                                    endAngle: .degrees(animateBorder ? 720 : 360)
                                ),
                                lineWidth: 1.5
                            )
                    }
                }
            )
            .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
            .padding(.horizontal, 20)
            .onAppear {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    animateBorder = true
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        JourneyFocusPill(onTakeBreak: {})
    }
    .padding()
    .background(Color.appBackground)
}
