import Foundation

@MainActor
@Observable
final class CourseService {
    static let shared = CourseService()
    
    private(set) var courses: [Course] = []
    private(set) var isLoading = false
    private(set) var error: Error?
    
    private init() {}
    
    func fetchAllCourses() async {
        isLoading = true
        error = nil
        
        do {
            // In the playground, we load courses from bundled JSON files.
            // We will bundle a few specific courses.
            let fileNames = [
                "adhd_superpowers",
                "anxiety_antidote",
                "art_of_happiness",
                "atomic_habits_screen_time",
                "attachment_theory",
                "body_language_decoder",
                "breathwork_basics",
                "crypto_for_normies",
                "deep_work_mastery",
                "digital_minimalism",
                "dopamine_detox",
                "emotional_intelligence",
                "essentialism",
                "feminism_decoded",
                "five_second_rule",
                "flow_state_science",
                "four_hour_workweek",
                "gut_health_101",
                "ikigai_your_purpose",
                "influence",
                "mindfulness_for_beginners",
                "morning_miracle",
                "negotiation_ninja",
                "pomodoro_power",
                "psychology_of_money",
                "rich_dad_mindset",
                "sleep_smarter",
                "start_with_why",
                "stoicism_for_leaders",
                "thinking_fast_slow",
                "zero_to_one"
            ]
            
            var loadedCourses: [Course] = []
            
            for fileName in fileNames {
                if let url = Bundle.module.url(forResource: fileName, withExtension: "json") {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    // Assuming DateDecodingStrategy if necessary, though original didn't specify
                    let course = try decoder.decode(Course.self, from: data)
                    loadedCourses.append(course)
                } else {
                    print("Failed to find \(fileName).json in bundle.")
                }
            }
            
            self.courses = loadedCourses
            self.isLoading = false
        } catch {
            print("[CourseService Mock] fetchAllCourses failed: \(error.localizedDescription)")
            self.error = error
            self.isLoading = false
        }
    }
    
    func fetchCourse(id: String) async -> Course? {
        if courses.isEmpty {
            await fetchAllCourses()
        }
        return courses.first { $0.id == id }
    }
    
    func fetchCoursesByCategory(_ category: String) async -> [Course] {
        if courses.isEmpty {
            await fetchAllCourses()
        }
        return courses.filter { $0.category == category }
    }
}
