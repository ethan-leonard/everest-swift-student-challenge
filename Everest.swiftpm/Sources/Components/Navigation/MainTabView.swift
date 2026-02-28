import SwiftUI

// MARK: - Tab Bar Visibility Preference Key
struct TabBarVisibilityKey: PreferenceKey {
    static let defaultValue: Bool = true
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value && nextValue()
    }
}

extension View {
    func hideTabBar(_ hide: Bool = true) -> some View {
        preference(key: TabBarVisibilityKey.self, value: !hide)
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    private var appState = AppState.shared
    @State private var previousTab: Tab = .courses
    @State private var isTabBarVisible: Bool = true
    
    init(selection: Tab = .courses) {
        _previousTab = State(initialValue: selection)
    }
    
    enum Tab: String, CaseIterable {
        case journey = "Journey"
        case courses = "Courses"
        case library = "Library"
        case profile = "Profile"
        
        var icon: String {
            switch self {
            case .journey: return "diamond"
            case .courses: return "doc.text"
            case .library: return "at.circle"
            case .profile: return "person"
            }
        }
        
        var index: Int {
            switch self {
            case .journey: return 0
            case .courses: return 1
            case .library: return 2
            case .profile: return 3
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: Binding(
                get: { appState.selectedTab },
                set: { appState.selectedTab = $0 }
            )) {
                NavigationStack {
                    if let course = appState.selectedCourse {
                        JourneyView(course: course)
                    } else {
                        JourneyEmptyView()
                    }
                }
                .toolbar(.hidden, for: .tabBar)
                .tag(Tab.journey)
                
                NavigationStack { CoursesView() }
                .toolbar(.hidden, for: .tabBar)
                .tag(Tab.courses)
                
                NavigationStack { LibraryView() }
                .toolbar(.hidden, for: .tabBar)
                .tag(Tab.library)
                
                NavigationStack { ProfileView() }
                .toolbar(.hidden, for: .tabBar)
                .tag(Tab.profile)
            }
            .ignoresSafeArea()
            .onPreferenceChange(TabBarVisibilityKey.self) { visible in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isTabBarVisible = visible
                }
            }
            
            if isTabBarVisible {
                VStack(spacing: 0) {
                    // Focus Status Bar - only on Journey tab when course selected, hidden when lesson popup is showing
                    if appState.selectedTab == .journey && !appState.isLessonPopupVisible && appState.selectedCourse != nil {
                        FocusStatusBar(onTakeBreak: {
                            appState.triggerTakeBreakLesson = true
                        })
                    }
                    
                    FigmaTabBar(
                        selectedTab: Binding(
                            get: { appState.selectedTab },
                            set: { appState.selectedTab = $0 }
                        ),
                        previousTab: $previousTab
                    )
                    .padding(.horizontal, 24)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .ignoresSafeArea(.keyboard)
        .task {
            // Restore state on launch
            await UserProgressService.shared.fetchProgress()
            if let activeId = UserProgressService.shared.userProgress?.activeCourseId,
               let course = await CourseService.shared.fetchCourse(id: activeId) {
                withAnimation {
                    appState.selectCourseAndNavigate(course)
                }
            }
        }
    }
}

// MARK: - Figma Tab Bar
struct FigmaTabBar: View {
    @Binding var selectedTab: MainTabView.Tab
    @Binding var previousTab: MainTabView.Tab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(MainTabView.Tab.allCases, id: \.self) { tab in
                Button {
                    if selectedTab != tab {
                        previousTab = selectedTab
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedTab = tab
                        }
                    }
                } label: {
                    VStack(spacing: 4) {
                        if selectedTab == tab {
                            Circle()
                                .fill(Color.appBrand)
                                .frame(width: 4, height: 4)
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            Color.clear.frame(width: 4, height: 4)
                        }
                        
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .regular))
                            .foregroundStyle(selectedTab == tab ? Color.appBrand : Color.appTextSecondary)
                        
                        Text(tab.rawValue)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(selectedTab == tab ? Color.appBrand : Color.appTextSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 6)
                    .padding(.bottom, 12)
                }
                .accessibilityLabel(tab.rawValue)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(tabBarBackground)
    }
    
    private var tabBarBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .blur(radius: 12)
            
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.white.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .strokeBorder(Color(hex: "E2E2E2").opacity(0.4), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
                .shadow(color: .black.opacity(0.05), radius: 25, x: 0, y: 20)
        }
    }
}

#Preview {
    MainTabView()
}
