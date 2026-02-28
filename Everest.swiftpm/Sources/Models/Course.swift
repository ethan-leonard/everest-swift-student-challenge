import Foundation

// MARK: - Course
struct Course: Identifiable, Codable, Sendable, Hashable {
    let id: String
    let title: String
    let description: String
    let category: String
    let imageURL: String
    let chapters: [Chapter]
    let durationMinutes: Int
    let altitude: Int // In meters, e.g. 4392
    let rating: Double // e.g. 4.8
    let whatsInside: [String]
    let expertReview: ExpertReview?
    let reviews: [UserReview]? // Community reviews
    let tag: String? // Optional badge like "Top Rated", "Quick Course", etc.
    
    var totalLessons: Int {
        chapters.reduce(0) { $0 + $1.lessons.count }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, category, imageURL, chapters, durationMinutes, altitude, rating, whatsInside, expertReview, reviews, tag
    }
    
    init(id: String, title: String, description: String, category: String, imageURL: String, chapters: [Chapter], durationMinutes: Int, altitude: Int, rating: Double, whatsInside: [String], expertReview: ExpertReview?, reviews: [UserReview]? = nil, tag: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.imageURL = imageURL
        self.chapters = chapters
        self.durationMinutes = durationMinutes
        self.altitude = altitude
        self.rating = rating
        self.whatsInside = whatsInside
        self.expertReview = expertReview
        self.reviews = reviews
        self.tag = tag
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        chapters = try container.decode([Chapter].self, forKey: .chapters)
        durationMinutes = try container.decode(Int.self, forKey: .durationMinutes)
        altitude = try container.decodeIfPresent(Int.self, forKey: .altitude) ?? 3500 // Default altitude if missing
        rating = try container.decodeIfPresent(Double.self, forKey: .rating) ?? 4.8
        whatsInside = try container.decodeIfPresent([String].self, forKey: .whatsInside) ?? []
        expertReview = try container.decodeIfPresent(ExpertReview.self, forKey: .expertReview)
        reviews = try container.decodeIfPresent([UserReview].self, forKey: .reviews)
        tag = try container.decodeIfPresent(String.self, forKey: .tag)
    }
}

// MARK: - User Review
struct UserReview: Codable, Sendable, Hashable, Identifiable {
    var id: String { "\(name)-\(timeAgo)" }
    let name: String
    let text: String
    let rating: Int // 1-5
    let timeAgo: String
}

// MARK: - Expert Review
struct ExpertReview: Codable, Sendable, Hashable {
    let quote: String
    let name: String
    let title: String
    let image: String? // SF Symbol name or asset name
}

// MARK: - Chapter
struct Chapter: Identifiable, Codable, Sendable, Hashable {
    let id: String
    let title: String
    let order: Int
    let lessons: [Lesson]
    
    var durationMinutes: Int {
        lessons.reduce(0) { $0 + $1.durationMinutes }
    }
}

// MARK: - Lesson
struct Lesson: Identifiable, Codable, Sendable, Hashable {
    let id: String
    let title: String
    let order: Int
    let durationMinutes: Int
    let pages: [LessonPage]
}

// MARK: - Lesson Page
struct LessonPage: Identifiable, Codable, Sendable, Hashable {
    let id: String
    let pageType: PageType
    let headline: String
    let body: String
    let imageURL: String?
    let question: QuestionContent?
    
    enum PageType: String, Codable, Sendable, Hashable {
        case content
        case question
    }
}

// MARK: - Question Content
struct QuestionContent: Codable, Sendable, Hashable {
    let options: [String]
    let correctIndex: Int
}

// MARK: - User Progress
struct UserProgress: Codable, Sendable, Hashable {
    var hoursReclaimed: Double
    var currentStreak: Int
    var dailyScreenTimeMinutes: [Int]
    var lessonsCompletedThisWeek: [Int]
    var courseProgress: [String: CourseProgress]
    
    // New fields for XP/Levels
    var totalXP: Int
    var currentLevel: Int
    var activeCourseId: String?
    var lastActivityDate: Date? // Used for simulated screen time updates
    var lastStreakDate: Date? // Used specifically for streak tracking

    
    // Stats Tracking
    var baselineScreenTimeMinutes: Int = 300 // Default 5h
    var screenTimeGoalMinutes: Int = 120 // Default 2h
    
    // Calculate cumulative XP needed for next level: level^2 * 100
    var xpForNextLevel: Int {
        return (currentLevel + 1) * (currentLevel + 1) * 100
    }
    
    // XP needed within current level to reach next level
    var xpNeededInCurrentLevel: Int {
        if currentLevel == 1 {
            // Level 1 spans 0-399 XP (need 400 total to reach level 2)
            return 400
        }
        let prevLevelThreshold = currentLevel * currentLevel * 100
        return xpForNextLevel - prevLevelThreshold
    }
    
    var xpProgressInLevel: Int {
        if currentLevel == 1 {
            return totalXP
        }
        let prevLevelXP = currentLevel * currentLevel * 100
        return totalXP - prevLevelXP
    }
    
    mutating func addXP(_ amount: Int) {
        totalXP += amount
        // Recalculate level: level = floor(sqrt(totalXP / 100))
        currentLevel = max(1, Int(sqrt(Double(totalXP) / 100.0)))
    }
}

struct CourseProgress: Codable, Sendable, Hashable {
    let courseId: String
    var completedLessonIds: Set<String>
    var isSaved: Bool
    var lastAccessedAt: Date?
    var currentLessonIndex: Int
    var lockedAnswers: [String: Int] // lessonId -> selectedAnswerIndex
    var pageProgress: [String: Int] // lessonId -> maxPageIndexReached
    
    init(courseId: String, completedLessonIds: Set<String> = [], isSaved: Bool = false, lastAccessedAt: Date? = nil, currentLessonIndex: Int = 0, lockedAnswers: [String: Int] = [:], pageProgress: [String: Int] = [:]) {
        self.courseId = courseId
        self.completedLessonIds = completedLessonIds
        self.isSaved = isSaved
        self.lastAccessedAt = lastAccessedAt
        self.currentLessonIndex = currentLessonIndex
        self.lockedAnswers = lockedAnswers
        self.pageProgress = pageProgress
    }
    
    func progressPercent(totalLessons: Int) -> Int {
        guard totalLessons > 0 else { return 0 }
        return Int((Double(completedLessonIds.count) / Double(totalLessons)) * 100)
    }
}

// MARK: - Journey Node
struct JourneyMilestone: Identifiable, Sendable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String // SF Symbol name
    let state: MilestoneState
}

enum MilestoneState: Sendable, Hashable {
    case completed
    case active
    case locked
}
