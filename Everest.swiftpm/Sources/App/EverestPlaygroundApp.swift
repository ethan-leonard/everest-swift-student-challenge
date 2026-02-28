import SwiftUI

@main
struct EverestPlaygroundApp: App {
    @State private var appState = AppState.shared
    @State private var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: StorageKey.hasCompletedOnboarding)
    
    // We add the mock services to the environment so any descendant can use them if needed.
    @State private var courseService = CourseService.shared
    @State private var userProgressService = UserProgressService.shared
    @State private var screenTimeService = ScreenTimeService.shared
    @State private var breakService = BreakService.shared
    @State private var authService = AuthenticationService.shared
    
    init() {
        // ALWAYS clear progress on cold start for Playgrounds judging
        if UserDefaults.standard.bool(forKey: "HAS_LAUNCHED_ONCE") == false {
            UserDefaults.standard.set(true, forKey: "HAS_LAUNCHED_ONCE")
        } else {
            // Reset to onboarding on every fresh launch for the judges
            UserDefaults.standard.removeObject(forKey: StorageKey.hasCompletedOnboarding)
            UserDefaults.standard.removeObject(forKey: "PlaygroundUserProgress")
        }
        
        authService.configure()
        
        // Define Custom Fonts for NavigationBar/TabBar globally
        let navbarAppearance = UINavigationBarAppearance()
        navbarAppearance.configureWithOpaqueBackground()
        navbarAppearance.backgroundColor = .white
        navbarAppearance.shadowColor = .clear
        
        if let navFont = UIFont(name: "InstrumentSans-Bold", size: 17) {
            navbarAppearance.titleTextAttributes = [
                .font: navFont,
                .foregroundColor: UIColor(Color.appTextPrimary)
            ]
            navbarAppearance.largeTitleTextAttributes = [
                .font: UIFont(name: "InstrumentSans-Bold", size: 34) ?? navFont,
                .foregroundColor: UIColor(Color.appTextPrimary)
            ]
        }
        
        UINavigationBar.appearance().standardAppearance = navbarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navbarAppearance
        UINavigationBar.appearance().compactAppearance = navbarAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingFlowView()
                }
            }
            .preferredColorScheme(.light) // Force light mode for consistent demo view
            .environment(appState)
            .environment(courseService)
            .environment(userProgressService)
            .environment(screenTimeService)
            .environment(breakService)
            .onReceive(NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)) { _ in
                hasCompletedOnboarding = UserDefaults.standard.bool(forKey: StorageKey.hasCompletedOnboarding)
            }
        }
    }
}
