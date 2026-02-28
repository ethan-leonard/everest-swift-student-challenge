import Foundation

@MainActor
@Observable
final class UserProgressService {
    static let shared = UserProgressService()
    
    private let storageKey = "PlaygroundUserProgress"
    private(set) var userProgress: UserProgress?
    private(set) var isLoading = false
    
    func clearAllData() {
        userProgress = nil
        UserDefaults.standard.removeObject(forKey: storageKey)
        isLoading = false
    }
    
    private init() {}
    
    func fetchProgress() async {
        isLoading = true
        
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let savedProgress = try? JSONDecoder().decode(UserProgress.self, from: data) {
            userProgress = savedProgress
        } else {
            // Seed the playground with a realistic demo slate requested by the user
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            
            let mockProgress = UserProgress(
                hoursReclaimed: 12.5,
                currentStreak: 3,
                dailyScreenTimeMinutes: [180, 160, 145, 120, 110, 95, 0], // Empty today
                lessonsCompletedThisWeek: [1, 0, 1, 2, 1, 1, 0], // Empty today
                courseProgress: [
                    "deep_work_mastery": CourseProgress(courseId: "deep_work_mastery", completedLessonIds: ["c1_l1", "c1_l2"], unlockedLessonIds: ["c1_l1", "c1_l2", "c1_l3"]),
                    "morning_miracle": CourseProgress(courseId: "morning_miracle", completedLessonIds: ["c1_l1"], unlockedLessonIds: ["c1_l1", "c1_l2"])
                ],
                totalXP: 450,
                currentLevel: 2,
                activeCourseId: "deep_work_mastery",
                lastActivityDate: yesterday, // So the streak isn't lost, but today is a fresh opportunity
                baselineScreenTimeMinutes: 240, // 4 hours baseline
                screenTimeGoalMinutes: 120 // 2 hours goal
            )
            userProgress = mockProgress
            await saveProgress()
        }
        
        checkForNewDay()
        isLoading = false
    }
    
    private func checkForNewDay() {
        guard var progress = userProgress else { return }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastActivity = progress.lastActivityDate.map { calendar.startOfDay(for: $0) } ?? today
        
        if lastActivity < today {
            let daysMissed = calendar.dateComponents([.day], from: lastActivity, to: today).day ?? 1
            
            for _ in 0..<min(daysMissed, 7) {
                if !progress.dailyScreenTimeMinutes.isEmpty {
                    progress.dailyScreenTimeMinutes.removeFirst()
                }
            }
            
            var isoCalendar = Calendar(identifier: .iso8601)
            isoCalendar.firstWeekday = 2 // Monday
            
            let lastWeek = isoCalendar.component(.weekOfYear, from: lastActivity)
            let currentWeek = isoCalendar.component(.weekOfYear, from: today)
            let lastYear = isoCalendar.component(.yearForWeekOfYear, from: lastActivity)
            let currentYear = isoCalendar.component(.yearForWeekOfYear, from: today)
            
            if lastWeek != currentWeek || lastYear != currentYear {
                progress.lessonsCompletedThisWeek = [0, 0, 0, 0, 0, 0, 0]
            }
            
            progress.lastActivityDate = Date()
            userProgress = progress
            
            Task {
                await saveProgress()
            }
        }
    }
    
    func saveProgress() async {
        guard let progress = userProgress else { return }
        
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func markLessonComplete(courseId: String, lessonId: String, xpEarned: Int, lessonIndex: Int? = nil) async {
        guard var progress = userProgress else { return }
        
        if progress.courseProgress[courseId] == nil {
            progress.courseProgress[courseId] = CourseProgress(
                courseId: courseId,
                completedLessonIds: [],
                isSaved: false,
                lastAccessedAt: Date()
            )
        }
        
        if var cp = progress.courseProgress[courseId] {
            cp.completedLessonIds.insert(lessonId)
            cp.lastAccessedAt = Date()
            
            if let idx = lessonIndex, idx >= cp.currentLessonIndex {
                cp.currentLessonIndex = idx + 1
            }
            
            progress.courseProgress[courseId] = cp
        }
        
        let today = Calendar.current.component(.weekday, from: Date()) - 1
        if today >= 0 && today < 7 {
            progress.lessonsCompletedThisWeek[today] += 1
        }
        
        userProgress = progress
        await saveProgress()
    }
    
    func startCourse(courseId: String) async {
        guard var progress = userProgress else { return }
        
        progress.activeCourseId = courseId
        
        if var cp = progress.courseProgress[courseId] {
            cp.lastAccessedAt = Date()
            progress.courseProgress[courseId] = cp
        } else {
            progress.courseProgress[courseId] = CourseProgress(
                courseId: courseId,
                completedLessonIds: [],
                isSaved: false,
                lastAccessedAt: Date(),
                currentLessonIndex: 0,
                lockedAnswers: [:]
            )
        }
        
        userProgress = progress
        await saveProgress()
    }
    
    func getCurrentLessonIndex(for courseId: String) -> Int {
        userProgress?.courseProgress[courseId]?.currentLessonIndex ?? 0
    }
    
    func setCurrentLessonIndex(courseId: String, index: Int) async {
        guard var progress = userProgress else { return }
        if var cp = progress.courseProgress[courseId] {
            cp.currentLessonIndex = index
            progress.courseProgress[courseId] = cp
        }
        userProgress = progress
        await saveProgress()
    }
    
    func lockAnswer(courseId: String, pageId: String, answerIndex: Int) async {
        guard var progress = userProgress else { return }
        if var cp = progress.courseProgress[courseId] {
            cp.lockedAnswers[pageId] = answerIndex
            progress.courseProgress[courseId] = cp
        }
        userProgress = progress
        await saveProgress()
    }
    
    func getLockedAnswer(courseId: String, pageId: String) -> Int? {
        userProgress?.courseProgress[courseId]?.lockedAnswers[pageId]
    }
    
    func isAnswerLocked(courseId: String, pageId: String) -> Bool {
        userProgress?.courseProgress[courseId]?.lockedAnswers[pageId] != nil
    }
    
    func updatePageProgress(courseId: String, lessonId: String, pageIndex: Int, totalPages: Int) async {
        guard var progress = userProgress else { return }
        
        if progress.courseProgress[courseId] == nil {
            progress.courseProgress[courseId] = CourseProgress(courseId: courseId)
            progress.activeCourseId = courseId
        }
        
        let currentMax = progress.courseProgress[courseId]?.pageProgress[lessonId] ?? 0
        if pageIndex > currentMax {
            if var cp = progress.courseProgress[courseId] {
                cp.pageProgress[lessonId] = pageIndex
                progress.courseProgress[courseId] = cp
            }
            userProgress = progress
            await saveProgress()
        }
    }
    
    func getLessonProgress(courseId: String, lessonId: String, totalPages: Int) -> Double {
        guard let courseProgress = userProgress?.courseProgress[courseId] else { return 0 }
        
        if courseProgress.completedLessonIds.contains(lessonId) { return 1.0 }
        
        let maxPage = courseProgress.pageProgress[lessonId] ?? 0
        if totalPages <= 0 { return 0 }
        
        return Double(maxPage) / Double(totalPages)
    }
    
    func getSavedPageIndex(courseId: String, lessonId: String) -> Int {
        userProgress?.courseProgress[courseId]?.pageProgress[lessonId] ?? 0
    }
    
    func addXP(_ amount: Int) async -> Bool {
        guard var progress = userProgress else { return false }
        progress.addXP(amount)
        userProgress = progress
        let didIncrement = await updateStreak()
        await saveProgress()
        return didIncrement
    }
    
    func getPotentialStreakBonus() -> Int {
        guard let progress = userProgress else { return 0 }
        
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastStreak = progress.lastStreakDate {
            let lastStreakDay = Calendar.current.startOfDay(for: lastStreak)
            if Calendar.current.isDate(lastStreakDay, inSameDayAs: today) {
                return 0
            }
        }
        
        var potentialNewStreak = 1
        if let lastStreak = progress.lastStreakDate {
            let lastStreakDay = Calendar.current.startOfDay(for: lastStreak)
            let daysDiff = Calendar.current.dateComponents([.day], from: lastStreakDay, to: today).day ?? 0
            
            if daysDiff == 1 {
                potentialNewStreak = progress.currentStreak + 1
            }
        }
        
        return 10 + (potentialNewStreak * 5)
    }
    
    func updateStreak() async -> Bool {
        guard var progress = userProgress else { return false }
        
        let today = Calendar.current.startOfDay(for: Date())
        var incremented = false
        
        if let lastStreak = progress.lastStreakDate {
            let lastStreakDay = Calendar.current.startOfDay(for: lastStreak)
            let daysDiff = Calendar.current.dateComponents([.day], from: lastStreakDay, to: today).day ?? 0
            
            if daysDiff == 1 {
                progress.currentStreak += 1
                incremented = true
                progress.lastStreakDate = today
            } else if daysDiff > 1 {
                progress.currentStreak = 1
                incremented = true
                progress.lastStreakDate = today
            }
        } else {
            progress.currentStreak = 1
            progress.lastStreakDate = today
            incremented = true
        }
        
        progress.lastActivityDate = Date()
        userProgress = progress
        
        return incremented
    }
    
    func toggleCourseSaved(courseId: String) async {
        guard var progress = userProgress else { return }
        
        if progress.courseProgress[courseId] == nil {
            progress.courseProgress[courseId] = CourseProgress(
                courseId: courseId,
                completedLessonIds: [],
                isSaved: true,
                lastAccessedAt: nil
            )
        } else if var cp = progress.courseProgress[courseId] {
            cp.isSaved.toggle()
            progress.courseProgress[courseId] = cp
        }
        
        userProgress = progress
        await saveProgress()
    }
    
    func isLessonComplete(courseId: String, lessonId: String) -> Bool {
        userProgress?.courseProgress[courseId]?.completedLessonIds.contains(lessonId) ?? false
    }
    
    func isCourseSaved(courseId: String) -> Bool {
        userProgress?.courseProgress[courseId]?.isSaved ?? false
    }
    
    func courseProgress(for courseId: String, totalLessons: Int) -> Int {
        userProgress?.courseProgress[courseId]?.progressPercent(totalLessons: totalLessons) ?? 0
    }
    
    func updateScreenTimeGoals(baseline: Int, goal: Int) async {
        guard var progress = userProgress else { return }
        
        progress.baselineScreenTimeMinutes = baseline
        progress.screenTimeGoalMinutes = goal
        
        userProgress = progress
        await saveProgress()
    }
}
