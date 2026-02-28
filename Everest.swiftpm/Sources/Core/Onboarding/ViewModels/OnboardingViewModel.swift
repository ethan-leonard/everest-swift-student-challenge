import SwiftUI

@MainActor
@Observable
final class OnboardingViewModel {
    var name: String = ""
    var age: String = ""
    var occupation: String = ""
    var selectedGoals: Set<String> = []
    var dailyScreenTimeAvg: String = ""
    var desiredScreenTime: String = ""
    var referralSource: String = ""
    var distractingApps: Set<String> = []
    var learningTime: Date = Date()
    var selectedInterests: Set<String> = []
    
    var firstName: String {
        name.split(separator: " ").first.map(String.init) ?? name
    }
    
    var previousAttempts: Set<String> = []
    var previousAttemptsText: String = ""
    
    var currentStep: Int = 0
    var navigationDirection: NavigationDirection = .forward
    
    enum NavigationDirection {
        case forward, backward
    }
    
    let goalOptions = [
        "Reduce screen time",
        "Learn new skills",
        "Improve focus",
        "Better sleep",
        "More free time"
    ]
    
    let sourceOptions = [
        "Instagram",
        "TikTok",
        "App Store",
        "Friend/Family",
        "Other"
    ]
    
    let appOptions = [
        "Instagram",
        "TikTok",
        "Twitter/X",
        "YouTube",
        "Snapchat",
        "Facebook"
    ]
    
    let interestOptions = [
        "Psychology",
        "History",
        "Science",
        "Business",
        "Technology",
        "Art & Design",
        "Health & Wellness"
    ]
    
    func nextStep() {
        navigationDirection = .forward
        withAnimation {
            currentStep += 1
        }
    }
    
    func previousStep() {
        navigationDirection = .backward
        withAnimation {
            currentStep = max(0, currentStep - 1)
        }
    }
    
    var dailyScreenTimeAvgHours: Double = 6.0
    
    var desiredScreenTimeHours: Double = 1.0
    
    func requestReview() {
        // No-op for playground
    }
    
    func saveOnboardingData() async throws {
        // Just update the user progress service screen time goals
        await UserProgressService.shared.fetchProgress()
        await UserProgressService.shared.updateScreenTimeGoals(
            baseline: Int(dailyScreenTimeAvgHours * 60),
            goal: Int(desiredScreenTimeHours * 60)
        )
    }
}
