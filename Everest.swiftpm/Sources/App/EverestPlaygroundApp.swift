import SwiftUI

@main
struct EverestPlaygroundApp: App {
    @State private var appState = AppState.shared
    @State private var hasCompletedOnboarding: Bool = false // Always start as false
    
    // We add the mock services to the environment so any descendant can use them if needed.
    @State private var courseService = CourseService.shared
    @State private var userProgressService = UserProgressService.shared
    @State private var screenTimeService = ScreenTimeService.shared
    @State private var breakService = BreakService.shared
    @State private var authService = AuthenticationService.shared
    
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        // FORCE clear everything on init (this fires on every cold launch)
        UserDefaults.standard.removeObject(forKey: StorageKey.hasCompletedOnboarding)
        UserDefaults.standard.removeObject(forKey: "PlaygroundUserProgress")
        UserDefaults.standard.synchronize()
        
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
