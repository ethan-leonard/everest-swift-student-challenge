import SwiftUI

// MARK: - Option B: Floating Focus Pill
// Persistent floating pill at top of screen, visible on ALL tabs

struct FloatingFocusPill: View {
    private let breakService = BreakService.shared
    var onTakeBreak: () -> Void
    
    var body: some View {
        if breakService.isInScheduledHours {
            HStack(spacing: 10) {
                if breakService.isBreakActive {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.yellow)
                    
                    Text(breakService.formattedRemainingTime)
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Text("Focus")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Text("•")
                        .foregroundStyle(.white.opacity(0.5))
                    
                    Button {
                        Haptics.shared.play(.medium)
                        onTakeBreak()
                    } label: {
                        Text("Take Break")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.appBrand)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .background(
                        Capsule()
                            .fill(breakService.isBreakActive ? Color.orange.opacity(0.3) : Color.appBrand.opacity(0.3))
                    )
            )
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.15), radius: 10, y: 4)
        }
    }
}

// MARK: - Floating Container
// Wraps content and adds the floating pill at top

struct FloatingFocusContainer<Content: View>: View {
    @ViewBuilder var content: Content
    var onTakeBreak: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            content
            
            FloatingFocusPill(onTakeBreak: onTakeBreak)
                .padding(.top, 8)
        }
    }
}

#Preview {
    FloatingFocusPill(onTakeBreak: {})
        .padding()
        .background(Color.gray)
}
