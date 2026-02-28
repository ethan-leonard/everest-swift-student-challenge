import SwiftUI

// MARK: - XP Breakdown Item
struct XPBreakdownItem: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let xp: Int
    let icon: String
}

// MARK: - Level Progress View
struct LevelProgressView: View {
    let xpBreakdown: [XPBreakdownItem] // e.g., [q1, q2, lesson, streak]

    let onContinue: () -> Void
    
    init(xpBreakdown: [XPBreakdownItem], onContinue: @escaping () -> Void) {
        self.xpBreakdown = xpBreakdown
        self.onContinue = onContinue
    }
    
    private var progressService = UserProgressService.shared
    
    // Animation states
    @State private var showCard = false
    @State private var showBreakdown = false

    @State private var animatedProgress: Double = 0
    @State private var animatedXP: Double = 0
    @State private var showConfetti = false
    @State private var showSuccess = false
    
    private var totalXPEarned: Int {
        xpBreakdown.reduce(0) { $0 + $1.xp }
    }
    
    private var currentLevel: Int {
        progressService.userProgress?.currentLevel ?? 1
    }
    
    private var currentXP: Int {
        progressService.userProgress?.totalXP ?? 0
    }
    
    private var xpNeededInCurrentLevel: Int {
        progressService.userProgress?.xpNeededInCurrentLevel ?? 400
    }
    
    private var xpProgressInLevel: Int {
        progressService.userProgress?.xpProgressInLevel ?? 0
    }
    
    private var levelProgress: Double {
        guard xpNeededInCurrentLevel > 0 else { return 0 }
        return min(1.0, max(0, Double(xpProgressInLevel) / Double(xpNeededInCurrentLevel)))
    }
    
    // MARK: - Dynamic State
    @State private var displayedLevel: Int = 1
    @State private var displayedTargetXP: Int = 400
    
    private var levelTitle: String {
        rankTitle(for: displayedLevel)
    }
    
    private func rankTitle(for level: Int) -> String {
        switch level {
        case 1...5: return "Novice"
        case 6...10: return "Apprentice"
        case 11...20: return "Scholar"
        case 21...35: return "Sage"
        case 36...50: return "Master"
        default: return "Legend"
        }
    }
    
    private func xpForLevel(_ level: Int) -> Int {
        return (level + 1) * (level + 1) * 100
    }
    
    private func xpNeededForLevel(_ level: Int) -> Int {
        if level == 1 {
            return 400  // Level 1 spans 0-399 XP
        }
        let prevLevelThreshold = level * level * 100
        let nextLevelThreshold = (level + 1) * (level + 1) * 100
        return nextLevelThreshold - prevLevelThreshold
    }
    
    private func xpProgressInLevel(totalXP: Int, level: Int) -> Int {
        if level == 1 {
            return totalXP  // Level 1 starts at 0
        }
        let prevLevelXP = level * level * 100
        return totalXP - prevLevelXP
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Confetti overlay when leveling up
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
            }
            
            // Ambient glow
            Circle()
                .fill(Color.appBrand.opacity(0.15))
                .frame(width: 300, height: 300)
                .blur(radius: 120)
                .offset(y: -50)
            
            VStack(spacing: 32) {
                Spacer()
                
                Text("Level Progress")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .opacity(showCard ? 1 : 0)
                    .offset(y: showCard ? 0 : 20)
                
                // Hero Card
                heroCard
                    .opacity(showCard ? 1 : 0)
                    .scaleEffect(showCard ? 1 : 0.9)
                
                // XP Breakdown List
                xpBreakdownList
                    .padding(.horizontal, 32)
                
                Spacer()
                
                Button(action: onContinue) {
                    Text("Continue")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.appBrand)
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                        .shadow(color: Color.appBrand.opacity(0.3), radius: 10, y: 5)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .opacity(showSuccess ? 1 : 0.3)
                .animation(.easeOut(duration: 0.3), value: showConfetti)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // MARK: - Hero Card
    
    private var heroCard: some View {
        HStack(spacing: 24) {
            // Progress Ring
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 10)
                    .frame(width: 90, height: 90)
                
                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(
                        LinearGradient(
                            colors: [Color.appBrand, Color(hex: "F7C94B")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 90, height: 90)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animatedProgress)
                
                // Icon (Flame or Checkmark or Level Icon)
                ZStack {
                    if showSuccess {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(Color.appBrand)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        // Change icon based on level? Or keep flame?
                        // User said "change icon for the level". Let's use rank icon.
                        Image(systemName: rankIcon(for: displayedLevel))
                            .font(.system(size: 28))
                            .foregroundStyle(Color.appBrand)
                            .scaleEffect(showConfetti ? 1.2 : 1.0)
                            .contentTransition(.symbolEffect(.replace))
                    }
                }
            }
            
            // Stats
            VStack(alignment: .leading, spacing: 6) {
                Text(levelTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .contentTransition(.numericText()) // Animate text change
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Level \(displayedLevel)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.appBrand)
                        .contentTransition(.numericText(value: Double(displayedLevel)))
                    
                    Text("\(xpProgressInLevel(totalXP: Int(animatedXP), level: displayedLevel)) / \(displayedTargetXP) XP")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                        .contentTransition(.numericText(value: animatedXP))
                }
            }
            
            Spacer()
        }
        .padding(24)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(hex: "151515"))
                
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 24)
    }
    
    // MARK: - XP Breakdown List
    
    private var xpBreakdownList: some View {
        VStack {
            if let index = activeItemIndex, index < xpBreakdown.count {
                XPBreakdownRow(item: xpBreakdown[index])
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity).combined(with: .scale(scale: 0.8)),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                    .id(xpBreakdown[index].id)
            } else {
                Spacer().frame(height: 60)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: activeItemIndex)
    }
    
    @State private var activeItemIndex: Int? = nil
    
    // MARK: - Animations
    
    private func startAnimations() {
        // 1. Show card
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showCard = true
        }
        
        // 2. Animate progress ring
        let totalNewXP = xpBreakdown.reduce(0) { $0 + $1.xp }
        let finalTotalXP = Double(progressService.userProgress?.totalXP ?? 0)
        let startXP = max(0, finalTotalXP - Double(totalNewXP))
        
        // Calculate initial level/target based on startXP
        let initialLevel = max(1, Int(sqrt(Double(startXP) / 100.0)))
        let initialTarget = xpNeededForLevel(initialLevel)
        
        // Initialize state
        displayedLevel = initialLevel
        displayedTargetXP = initialTarget
        animatedXP = startXP
        animatedProgress = calculateProgress(xp: Int(startXP), level: initialLevel)
        
        // 3. Sequential Animation
        var runningTotalXP = Int(startXP)
        var sequence = [(index: Int, targetXP: Int)]()
        
        for (index, item) in xpBreakdown.enumerated() {
            runningTotalXP += item.xp
            sequence.append((index, runningTotalXP))
        }

        var delay: TimeInterval = 0.8
        let itemDuration: TimeInterval = 2.0
        
        for (index, targetXP) in sequence {
            // Show item
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                Haptics.shared.play(.light)
                activeItemIndex = index
            }
            
            // Fill progress
            DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.2) {
                let currentLevelCap = Double(self.xpForLevel(self.displayedLevel))
                
                // Check if this step causes level up
                // A step levels up if targetXP >= currentLevelCap
                if Double(targetXP) >= currentLevelCap {
                    // Level Up Sequence
                    
                    // 1. Fill to 100%
                    withAnimation(.easeOut(duration: 0.4)) {
                        self.animatedProgress = 1.0
                        self.animatedXP = currentLevelCap
                    }
                    
                    // 2. Level Up Trigger
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        Haptics.shared.play(.success)
                        
                        // Update Level & Target
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            self.displayedLevel += 1
                            self.displayedTargetXP = self.xpNeededForLevel(self.displayedLevel)
                            self.animatedProgress = 0.0 // Reset bar
                        }
                        
                        // 3. Fill remaining in new level
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.easeOut(duration: 0.4)) {
                                self.animatedXP = Double(targetXP)
                                self.animatedProgress = self.calculateProgress(xp: targetXP, level: self.displayedLevel)
                            }
                        }
                    }
                } else {
                    // Standard fill
                    withAnimation(.easeOut(duration: 0.8)) {
                        self.animatedXP = Double(targetXP)
                        self.animatedProgress = self.calculateProgress(xp: targetXP, level: self.displayedLevel)
                    }
                }
            }
            
            // Hide previous item logic
            DispatchQueue.main.asyncAfter(deadline: .now() + delay + itemDuration - 0.4) {
                 self.activeItemIndex = nil
            }
            
            delay += itemDuration
        }
        
        // 4. Final celebration
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // Only play confetti if we leveled up
            if self.displayedLevel > initialLevel {
                showConfetti = true
                Haptics.shared.play(.success)
            } else {
                Haptics.shared.play(.light)
            }
            
            showSuccess = true
        }
    }
    
    private func calculateProgress(xp: Int, level: Int) -> Double {
        let prevLevelXP = level * level * 100
        let nextLevelXP = (level + 1) * (level + 1) * 100
        
        // For Level 1: prev=100 (clamped 0 in practice?), next=400.
        // If xp=60: 60/400.
        // If xp=500 (Level 2): prev=400, next=900.
        // 500-400 = 100. 900-400=500. 100/500 = 0.2.
        
        if level == 1 {
             return Double(xp) / 400.0
        }
        
        let progressInLevel = xp - prevLevelXP
        let xpNeeded = nextLevelXP - prevLevelXP
        return min(1.0, max(0, Double(progressInLevel) / Double(xpNeeded)))
    }
    
    private func rankIcon(for level: Int) -> String {
        switch level {
        case 1...3: return "flame.fill"
        case 4...6: return "bolt.fill"
        case 7...10: return "star.fill"
        case 11...15: return "crown.fill"
        default: return "trophy.fill"
        }
    }
}

// MARK: - XP Breakdown Row

struct XPBreakdownRow: View {
    let item: XPBreakdownItem
    @State private var appeared = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.appBrand.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: item.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appBrand)
            }
            
            // Label
            Text(item.label)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.9))
            
            Spacer()
            
            // XP Badge
            Text("+\(item.xp) XP")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Color(hex: "F7C94B"))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color(hex: "F7C94B").opacity(0.15))
                )
                .scaleEffect(appeared ? 1.0 : 0.5)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: appeared)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(hex: "1A1A1A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.05), lineWidth: 1)
                )
        )
        .onAppear {
            appeared = true
        }
    }
}

#Preview {
    LevelProgressView(
        xpBreakdown: [
            XPBreakdownItem(label: "Question 1 Correct", xp: 10, icon: "checkmark.circle.fill"),
            XPBreakdownItem(label: "Question 2 Correct", xp: 10, icon: "checkmark.circle.fill"),
            XPBreakdownItem(label: "Lesson Complete", xp: 50, icon: "book.fill"),
            XPBreakdownItem(label: "Daily Streak", xp: 20, icon: "flame.fill")
        ],
        onContinue: {}
    )
}
