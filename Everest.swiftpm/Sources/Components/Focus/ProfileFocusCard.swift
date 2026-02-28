import SwiftUI

// MARK: - Profile Focus Card
// Card in Profile page with detailed focus/break info

struct ProfileFocusCard: View {
    private let breakService = BreakService.shared
    var onTakeBreak: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Image(systemName: breakService.isBreakActive ? "sun.max.fill" : "lock.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(breakService.isBreakActive ? .yellow : Color.appBrand)
                        
                        Text(breakService.isBreakActive ? "BREAK ACTIVE" : "FOCUS MODE")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Color.appTextSecondary)
                    }
                    
                    if breakService.isBreakActive {
                        Text("\(breakService.formattedRemainingTime) remaining")
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.appTextPrimary)
                    } else if breakService.isInScheduledHours {
                        Text("Apps blocked")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.appTextPrimary)
                    } else {
                        Text("Scheduled: \(breakService.scheduleDescription)")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.appTextPrimary)
                    }
                }
                
                Spacer()
            }
            .padding(20)
            
            Divider()
                .padding(.horizontal, 20)
            
            // Action Button
            if breakService.isInScheduledHours {
                Button {
                    Haptics.shared.play(.medium)
                    if breakService.isBreakActive {
                        breakService.endBreak()
                    } else {
                        onTakeBreak()
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: breakService.isBreakActive ? "xmark.circle.fill" : "brain.head.profile")
                            .font(.system(size: 18))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(breakService.isBreakActive ? "End Break Early" : "Take a Break")
                                .font(.system(size: 16, weight: .semibold))
                            
                            if !breakService.isBreakActive {
                                Text("Complete a lesson for 10 minutes")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.appTextSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.appTextSecondary)
                    }
                    .foregroundStyle(breakService.isBreakActive ? .red : Color.appBrand)
                    .padding(20)
                }
            } else {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.green)
                    
                    Text("You're free! Focus mode is scheduled.")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.appTextSecondary)
                    
                    Spacer()
                }
                .padding(20)
            }
        }
        .frame(minHeight: 120) // Prevents squishing bug in ScrollView
        .glassCardStyle()
    }
}

// MARK: - Journey Focus Badge
struct JourneyFocusBadge: View {
    private let breakService = BreakService.shared
    
    var body: some View {
        if breakService.isInScheduledHours {
            HStack(spacing: 4) {
                Image(systemName: breakService.isBreakActive ? "sun.max.fill" : "lock.fill")
                    .font(.system(size: 12, weight: .semibold))
                
                if breakService.isBreakActive {
                    Text(breakService.formattedRemainingTime)
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                }
            }
            .foregroundStyle(breakService.isBreakActive ? .yellow : Color.appBrand)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProfileFocusCard(onTakeBreak: {})
        JourneyFocusBadge()
    }
    .padding()
    .background(Color.appBackground)
}
