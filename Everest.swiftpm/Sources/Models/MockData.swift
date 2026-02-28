import Foundation

// MARK: - Mock Data for Previews & Development
enum MockData {
    
    // MARK: - Courses
    static let courses: [Course] = [
        Course(
            id: "1",
            title: "Modern Stoicism",
            description: "Learn the timeless principles of Stoic philosophy adapted for modern life.",
            category: "Philosophy",
            imageURL: "stoicism",
            chapters: [
                Chapter(id: "1-1", title: "Introduction to Stoicism", order: 1, lessons: [
                    Lesson(id: "1-1-1", title: "What is Stoicism?", order: 1, durationMinutes: 8, pages: MockData.samplePages),
                    Lesson(id: "1-1-2", title: "Core Principles", order: 2, durationMinutes: 10, pages: MockData.samplePages),
                ]),

                Chapter(id: "1-2", title: "Daily Practice", order: 2, lessons: [
                    Lesson(id: "1-1-1", title: "The Dopamine Loop", order: 1, durationMinutes: 5, pages: currentLesson.pages),
                    Lesson(id: "1-1-2", title: "Breaking the Cycle", order: 2, durationMinutes: 7, pages: currentLesson.pages)
                ])
            ],
            durationMinutes: 45,
            altitude: 4392,
            rating: 4.8,
            whatsInside: ["Stoic fundamentals", "Daily practices", "Mindset shifts"],
            expertReview: nil,
            reviews: [
                UserReview(name: "Sarah Jenkins", text: "This course completely changed how I view my daily stressors. Highly recommended!", rating: 5, timeAgo: "2 days ago"),
                UserReview(name: "Michael Chen", text: "Short, punchy lessons that actually stick. The exercises are practical.", rating: 5, timeAgo: "1 week ago"),
                UserReview(name: "David Smith", text: "Great introduction to Stoicism however I wish it was longer.", rating: 4, timeAgo: "2 weeks ago"),
                UserReview(name: "Emma Wilson", text: "The audio quality is fantastic and the content is life-changing.", rating: 5, timeAgo: "3 weeks ago")
            ]
        ),
        Course(
            id: "2",
            title: "Shadow Work",
            description: "Explore and integrate the hidden aspects of your psyche for personal growth.",
            category: "Psychology",
            imageURL: "shadow",
            chapters: [
                Chapter(id: "2-1", title: "Understanding the Shadow", order: 1, lessons: [
                    Lesson(id: "2-1-1", title: "What is Shadow Work?", order: 1, durationMinutes: 12, pages: MockData.samplePages),
                    Lesson(id: "2-1-2", title: "Your First Exploration", order: 2, durationMinutes: 15, pages: MockData.samplePages),
                ]),
            ],
            durationMinutes: 180,
            altitude: 3200,
            rating: 4.5,
            whatsInside: ["Psychological integration", "Self-discovery", "Healing"],
            expertReview: nil
        ),
        Course(
            id: "3",
            title: "Marcus Aurelius",
            description: "Study the meditations and philosophy of the Stoic emperor.",
            category: "Stoicism",
            imageURL: "marcus",
            chapters: [
                Chapter(id: "3-1", title: "Meditations Book 1", order: 1, lessons: [
                    Lesson(id: "3-1-1", title: "Introduction", order: 1, durationMinutes: 20, pages: MockData.samplePages),
                ]),
                Chapter(id: "3-2", title: "Meditations Book 2", order: 2, lessons: [
                    Lesson(id: "3-2-1", title: "On Self-Control", order: 1, durationMinutes: 25, pages: MockData.samplePages),
                ]),
            ],
            durationMinutes: 300,
            altitude: 5895,
            rating: 4.9,
            whatsInside: ["Emperor's wisdom", "Resilience", "Leadership"],
            expertReview: nil
        ),
        Course(
            id: "4",
            title: "Epicurus' Joy",
            description: "Discover the path to happiness through Epicurean philosophy.",
            category: "Habits",
            imageURL: "epicurus",
            chapters: [
                Chapter(id: "4-1", title: "The Art of Pleasure", order: 1, lessons: [
                    Lesson(id: "4-1-1", title: "Simple Pleasures", order: 1, durationMinutes: 10, pages: MockData.samplePages),
                    Lesson(id: "4-1-2", title: "Friendship", order: 2, durationMinutes: 8, pages: MockData.samplePages),
                ]),
            ],
            durationMinutes: 120,
            altitude: 2500,
            rating: 4.2,
            whatsInside: ["Happiness science", "Simple living", "Connection"],
            expertReview: nil
        ),
        Course(
            id: "5",
            title: "Mindful Parenting",
            description: "Apply psychological principles to raise resilient children.",
            category: "Psychology",
            imageURL: "shadow",
            chapters: [],
            durationMinutes: 150,
            altitude: 1500,
            rating: 4.6,
            whatsInside: ["Parenting tools", "Emotional regulation", "Bonding"],
            expertReview: nil
        ),
        Course(
            id: "6",
            title: "Seneca's Letters",
            description: "Wisdom from the Stoic philosopher on friendship and time.",
            category: "Stoicism",
            imageURL: "marcus",
            chapters: [],
            durationMinutes: 200,
            altitude: 4000,
            rating: 4.7,
            whatsInside: ["Time management", "Friendship", "Philosophy of life"],
            expertReview: nil
        ),
        Course(
            id: "7",
            title: "Building Habits",
            description: "The science of creating good habits and breaking bad ones.",
            category: "Habits",
            imageURL: "epicurus",
            chapters: [],
            durationMinutes: 90,
            altitude: 2000,
            rating: 4.8,
            whatsInside: ["Habit formation", "Breaking bad habits", "Consistency"],
            expertReview: nil
        ),
        Course(
            id: "8",
            title: "Existentialism",
            description: "Finding meaning in a chaotic world through freedom and choice.",
            category: "Philosophy",
            imageURL: "stoicism",
            chapters: [],
            durationMinutes: 180,
            altitude: 3500,
            rating: 4.4,
            whatsInside: ["Freedom", "Responsibility", "Meaning making"],
            expertReview: nil
        ),
    ]
    
    // MARK: - Sample Lesson Pages (6 content + 2 questions = 8 total)
    static let samplePages: [LessonPage] = [
        LessonPage(
            id: "p1",
            pageType: .content,
            headline: "Insight isn't about finding new data,",
            body: "but about viewing existing patterns through a different lens.\n\nWhen the sliding door of perspective opens, the most complex problems reveal their simplest forms.",
            imageURL: "lesson_insight",
            question: nil
        ),
        LessonPage(
            id: "p2",
            pageType: .content,
            headline: "Deep work is the ability to focus",
            body: "without distraction on a cognitively demanding task. It's a skill that allows you to quickly master complicated information and produce better results in less time.",
            imageURL: "lesson_focus",
            question: nil
        ),
        LessonPage(
            id: "p3",
            pageType: .content,
            headline: "The key to developing a deep work habit",
            body: "is to move beyond good intentions and add routines and rituals designed to minimize the amount of your limited willpower necessary to transition into and maintain a state of unbroken concentration.",
            imageURL: nil,
            question: nil
        ),
        LessonPage(
            id: "p4",
            pageType: .question,
            headline: "What is the main benefit of deep work?",
            body: "Select the best answer below.",
            imageURL: nil,
            question: QuestionContent(
                options: [
                    "Multitasking more effectively",
                    "Producing better results in less time",
                    "Checking notifications frequently",
                    "Working longer hours"
                ],
                correctIndex: 1
            )
        ),
        LessonPage(
            id: "p5",
            pageType: .content,
            headline: "Embrace boredom",
            body: "If you constantly switch to low-stimulus activities at the slightest hint of boredom, you'll train your mind to crave novelty and lose the ability to focus deeply.",
            imageURL: "lesson_boredom",
            question: nil
        ),
        LessonPage(
            id: "p6",
            pageType: .content,
            headline: "Schedule every minute of your day",
            body: "Give every minute of your workday a job. This doesn't mean your schedule is fixed—it's about being intentional with your time.",
            imageURL: nil,
            question: nil
        ),
        LessonPage(
            id: "p7",
            pageType: .content,
            headline: "Quit social media",
            body: "Not entirely, but be more selective. The any-benefit mindset is flawed. Ask if the benefits truly outweigh the costs to your time and attention.",
            imageURL: "lesson_social",
            question: nil
        ),
        LessonPage(
            id: "p8",
            pageType: .question,
            headline: "What should you embrace to strengthen focus?",
            body: "Select the best answer below.",
            imageURL: nil,
            question: QuestionContent(
                options: [
                    "Constant stimulation",
                    "Boredom",
                    "Social media breaks",
                    "Multitasking"
                ],
                correctIndex: 1
            )
        ),
    ]
    
    // MARK: - User Progress
    static let userProgress = UserProgress(
        hoursReclaimed: 24,
        currentStreak: 12,
        dailyScreenTimeMinutes: [180, 165, 150, 145, 130, 135, 125], // Trending down
        lessonsCompletedThisWeek: [2, 1, 3, 2, 1, 4, 0], // M-S
        courseProgress: [
            "1": CourseProgress(courseId: "1", completedLessonIds: ["1-1-1", "1-1-2", "1-2-1"], isSaved: true, lastAccessedAt: Date()),
            "2": CourseProgress(courseId: "2", completedLessonIds: ["2-1-1"], isSaved: false, lastAccessedAt: Date().addingTimeInterval(-86400)),
        ],
        totalXP: 1250,
        currentLevel: 7,
        activeCourseId: "1",
        lastActivityDate: Date()
    )
    
    // MARK: - Journey Milestones
    static let milestones: [JourneyMilestone] = [
        JourneyMilestone(id: "m1", title: "Peak Awaits", subtitle: "", icon: "crown.fill", state: .locked),
        JourneyMilestone(id: "m2", title: "The Summit", subtitle: "Mastery", icon: "lock.fill", state: .locked),
        JourneyMilestone(id: "m3", title: "High Altitude", subtitle: "Expert", icon: "briefcase.fill", state: .locked),
        JourneyMilestone(id: "m4", title: "Ridge Walk", subtitle: "Intermediate", icon: "figure.walk", state: .active),
        JourneyMilestone(id: "m5", title: "Base Camp", subtitle: "Beginner", icon: "tent.fill", state: .completed),
    ]
    
    // MARK: - Current Lesson
    static let currentLesson = Lesson(
        id: "1-2-1",
        title: "Ridge Walk",
        order: 3,
        durationMinutes: 12,
        pages: samplePages
    )
}
