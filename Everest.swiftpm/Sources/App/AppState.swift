import SwiftUI

@MainActor
@Observable
final class AppState {
    static let shared = AppState()
    
    var selectedCourse: Course?
    var selectedTab: MainTabView.Tab = .courses
    
    var triggerTakeBreakLesson: Bool = false
    var showBreakEarnedScreen: Bool = false
    var isLessonPopupVisible: Bool = false
    
    init() {}
    
    func selectCourseAndNavigate(_ course: Course) {
        selectedCourse = course
        selectedTab = .journey
    }
    
    func clearAllData() {
        selectedCourse = nil
        selectedTab = .courses
        triggerTakeBreakLesson = false
        showBreakEarnedScreen = false
        isLessonPopupVisible = false
    }
}
