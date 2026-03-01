import SwiftUI

struct WeeklyStreakBar: View {
    let streakDays: [Bool]
    var actualStreak: Int = 0
    
    private let dayLabels = ["S", "M", "T", "W", "T", "F", "S"]
    
    @State private var animateToday = false
    @State private var showFlame = false
    
    // Track if animation has played today
    @AppStorage(StorageKey.lastStreakAnimationDate) private var lastAnimationDateString: String = ""
    
    private var hasAnimatedToday: Bool {
        lastAnimationDateString == HourFormatter.todayString()
    }
    
    private func markAnimationPlayed() {
        lastAnimationDateString = HourFormatter.todayString()
    }
    
    private var displayStreak: Int {
        return actualStreak // For the playground demo, we always want the exact computed integer to sync with the Profile card.
    }
    
    // Identify today's index (0-6) based on current weekday
    private var todayIndex: Int {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return weekday - 1 // 1-based to 0-based (Sun=0)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Current Streak: \(displayStreak) \(displayStreak == 1 ? "Day" : "Days")")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.appTextSecondary)
            
            HStack(spacing: 12) {
                ForEach(0..<7, id: \.self) { index in
                    VStack(spacing: 6) {
                        Text(dayLabels[index])
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color.appTextSecondary)
                        
                        ZStack {
                            // Base Circle (Empty) - with visible border
                            Circle()
                                .fill(Color.appCardBackground)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle()
                                        .strokeBorder(Color.appTextSecondary.opacity(0.2), lineWidth: 1.5)
                                )
                            
                            // Filled Circle (Animated only if not already animated today)
                            if streakDays[index] {
                                Circle()
                                    .fill(Color.appBrand)
                                    .frame(width: 36, height: 36)
                                    // Only animate if it's today AND hasn't animated yet
                                    .scaleEffect(isToday(index) && !hasAnimatedToday ? (animateToday ? 1.0 : 0.0) : 1.0)
                                    .animation(isToday(index) && !hasAnimatedToday ? .spring(response: 0.5, dampingFraction: 0.6) : nil, value: animateToday)
                                
                                // Flame Icon (Animated)
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .scaleEffect(isToday(index) && !hasAnimatedToday ? (showFlame ? 1.0 : 0.0) : 1.0)
                                    .animation(isToday(index) && !hasAnimatedToday ? .spring(response: 0.4, dampingFraction: 0.5).delay(0.2) : nil, value: showFlame)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .glassCardStyle()
        .onAppear {
            // Only animate if today is complete AND we haven't animated today yet
            if streakDays.indices.contains(todayIndex) && streakDays[todayIndex] && !hasAnimatedToday {
                triggerAnimation()
            } else if hasAnimatedToday {
                // Already animated today, show filled state immediately
                animateToday = true
                showFlame = true
            }
        }
        .onChange(of: streakDays) { oldValue, newValue in
            // Detect if today just got marked as complete
            if newValue.indices.contains(todayIndex) && newValue[todayIndex] && !oldValue[todayIndex] && !hasAnimatedToday {
                triggerAnimation()
            }
        }
    }
    
    private func triggerAnimation() {
        // Longer delay so user sees animation after lesson dismisses and Journey page loads
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Pre-animation haptic
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            
            animateToday = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                showFlame = true
                // Success haptic when flame appears
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                markAnimationPlayed()
            }
        }
    }
    
    private func isToday(_ index: Int) -> Bool {
        return index == todayIndex
    }
}
