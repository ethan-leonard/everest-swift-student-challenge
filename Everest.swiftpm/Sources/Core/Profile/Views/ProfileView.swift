import SwiftUI

struct ProfileView: View {
    @State private var progressService = UserProgressService.shared
    private let authService = AuthenticationService.shared
    private let appState = AppState.shared
    @State private var breakService = BreakService.shared
    
    @State private var knowledgeRange: WeeklyBarChart.TimeRange = .week
    @State private var showBreakPrompt = false
    
    private var userName: String {
        return "Student"
    }
    
    private var progress: UserProgress? {
        progressService.userProgress
    }
    
    private var knowledgeData: [Int] {
        guard let progress = progress else { return Array(repeating: 0, count: 7) }
        
        switch knowledgeRange {
        case .week:
            let data = progress.lessonsCompletedThisWeek
            if data.isEmpty { return Array(repeating: 0, count: 7) }
            var rotated = Array(data.dropFirst())
            
            let weekday = Calendar.current.component(.weekday, from: Date())
            let isSunday = weekday == 1
            rotated.append(isSunday ? data[0] : 0)
            
            return rotated
            
        case .month:
            let currentWeekTotal = progress.lessonsCompletedThisWeek.reduce(0, +)
            let weekOfMonth = Calendar.current.component(.weekOfMonth, from: Date())
            var monthData = [0, 0, 0, 0]
            let weekIndex = max(0, min(3, weekOfMonth - 1))
            monthData[weekIndex] = currentWeekTotal
            return monthData
            
        case .year:
            let currentWeekTotal = progress.lessonsCompletedThisWeek.reduce(0, +)
            let currentMonth = Calendar.current.component(.month, from: Date())
            var yearlyData = Array(repeating: 0, count: 12)
            yearlyData[currentMonth - 1] = currentWeekTotal
            return yearlyData
        }
    }
    
    private var knowledgeSubtitle: String {
        let total = knowledgeData.reduce(0, +)
        if total == 0 { return "No lessons yet" }
        return "\(total) lessons this week"
    }
    
    private var hoursReclaimed: Double {
        let trackedHours = breakService.totalFocusHours
        let progressHours = progress?.hoursReclaimed ?? 0
        return max(trackedHours, progressHours)
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome **\(userName)**")
                                .font(.system(size: 28, weight: .regular))
                                .foregroundStyle(Color.appTextPrimary)
                        }
                        Spacer()
                    }
                    .padding(.top, 24)
                    
                    ProfileFocusCard(onTakeBreak: {
                        appState.selectedTab = .journey
                    })
                    
                    if let progress = progress {
                         let totalLessons = progress.courseProgress.values.reduce(0) { $0 + $1.completedLessonIds.count }
                        
                        LevelProgressCard(
                            currentLevel: progress.currentLevel,
                            currentXP: progress.xpProgressInLevel,
                            xpForNextLevel: progress.xpNeededInCurrentLevel,
                            lessonsCompleted: totalLessons
                        )
                    }
                    
                    bentoGrid
                    
                    ZStack {
                        ScreenTimePlaceholderView()
                    }
                    .frame(height: 180)
                    
                    WeeklyBarChart(
                        dailyCounts: knowledgeData,
                        title: "Knowledge Growth",
                        subtitle: knowledgeSubtitle,
                        selectedRange: $knowledgeRange
                    )
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 80)
            }
        }
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
        .hideTabBar(false)
        .onAppear {
             Task {
                 await progressService.fetchProgress()
             }
        }
        .fullScreenCover(isPresented: $showBreakPrompt) {
            BlockerView(
                variant: BlockerVariant.allCases.randomElement() ?? .cosmic,
                onEarnTime: {
                    showBreakPrompt = false
                    breakService.beginEarningBreak()
                    appState.selectedTab = .journey
                    appState.triggerTakeBreakLesson = true
                },
                onExit: {
                    showBreakPrompt = false
                }
            )
        }
    }
    
    private var bentoGrid: some View {
        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 12) {
            StatCard(
                title: "Total Reclaimed",
                value: String(format: "%.1f", hoursReclaimed),
                subtitle: "hours",
                icon: "clock.fill",
                trend: hoursReclaimed > 0 ? .up : nil,
                trendValue: calculateTrend()
            )
            
            StatCard(
                title: "Current Streak",
                value: "\(progress?.currentStreak ?? 0)",
                subtitle: "days",
                icon: "flame.fill"
            )
        }
    }
    
    private func calculateTrend() -> String? {
        guard let progress = progress else { return nil }
        if progress.hoursReclaimed <= 0 { return nil }
        guard let last = progress.dailyScreenTimeMinutes.last else { return nil }
        let baseline = Double(progress.baselineScreenTimeMinutes)
        let yesterday = Double(last)
        
        if baseline > 0 && yesterday < baseline {
            let reduction = ((baseline - yesterday) / baseline) * 100
            return String(format: "+%.0f%%", min(reduction, 99))
        }
        return nil
    }
}

#Preview {
    MainTabView()
}
