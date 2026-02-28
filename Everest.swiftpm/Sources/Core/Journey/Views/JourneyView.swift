import SwiftUI

// MARK: - Journey View
struct JourneyView: View {
    let course: Course
    @State private var selectedLesson: Lesson?
    @State private var lessonToNavigate: Lesson?
    @State private var showBreakEarned = false
    @State private var showBreakPrompt = false
    
    private let appState = AppState.shared
    @State private var breakService = BreakService.shared
    
    init(course: Course) {
        self.course = course
    }
    
    @State private var progressService = UserProgressService.shared
    
    private var allLessons: [Lesson] {
        course.chapters.flatMap { $0.lessons }
    }
    
    var journeyLessons: [JourneyLesson] {
        allLessons.enumerated().map { index, lesson in
            JourneyLesson(
                id: lesson.id,
                order: index + 1,
                title: lesson.title,
                icon: iconForIndex(index + 1)
            )
        }
    }
    
    var currentLessonIndex: Int {
        progressService.getCurrentLessonIndex(for: course.id)
    }
    
    private func iconForIndex(_ index: Int) -> String {
        let icons = ["star.fill", "camera.fill", "flag.fill", "book.fill", "lightbulb.fill", "heart.fill"]
        return icons[(index - 1) % icons.count]
    }
    
    private func calculateStreakDays() -> [Bool] {
        guard let progress = progressService.userProgress else {
            return Array(repeating: false, count: 7)
        }
        return progress.lessonsCompletedThisWeek.map { $0 > 0 }
    }
    
    private func scrollToCurrentLesson(proxy: ScrollViewProxy) {
        // Increased delay to ensure layout is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let index = currentLessonIndex
            guard index < journeyLessons.count else { return }
            withAnimation(.easeOut(duration: 0.6)) {
                proxy.scrollTo(journeyLessons[index].id, anchor: .center)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            MountainBackground()
                .drawingGroup() // Optimize complex path drawing
                .ignoresSafeArea()
            
            ZStack(alignment: .top) {
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        JourneyPathView(
                            lessons: journeyLessons,
                            currentIndex: currentLessonIndex,
                            onLessonTap: { journeyLesson in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if selectedLesson?.id == journeyLesson.id {
                                    selectedLesson = nil
                                } else if let lesson = allLessons.first(where: { $0.id == journeyLesson.id }) {
                                    selectedLesson = lesson
                                }
                            }
                        }
                        )
                        .frame(height: CGFloat(journeyLessons.count) * 120 + 200)
                        .padding(.top, 160)
                        
                        // Large bottom spacer to allow centering any element
                        Spacer()
                            .frame(height: 500)
                    }
                    .onChange(of: progressService.userProgress) { _, _ in
                        scrollToCurrentLesson(proxy: proxy)
                    }
                    .onAppear {
                        scrollToCurrentLesson(proxy: proxy)
                    }
                }
                
                JourneyHeader(
                    course: course,
                    completed: progressService.userProgress?.courseProgress[course.id]?.completedLessonIds.count ?? 0,
                    total: course.totalLessons,
                    streakDays: calculateStreakDays(),
                    actualStreak: progressService.userProgress?.currentStreak ?? 0,
                    onTakeBreak: {
                        // Show BlockerView
                        showBreakPrompt = true
                    }
                )
                .padding(.top, 16)
            }
            .task {
                await progressService.fetchProgress()
            }
            
            if let lesson = selectedLesson {
                // Tap-to-dismiss overlay
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedLesson = nil
                        }
                    }
                
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        LessonCardGlass(
                            lesson: lesson,
                            isLocked: lesson.order > currentLessonIndex + 1,
                            isCompleted: lesson.order <= currentLessonIndex,
                            progress: progressService.getLessonProgress(courseId: course.id, lessonId: lesson.id, totalPages: lesson.pages.count),
                            onPlayTap: {
                                let lessonToOpen = lesson
                                selectedLesson = nil
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    lessonToNavigate = lessonToOpen
                                }
                            },
                            onDismiss: { selectedLesson = nil }
                        )
                        .padding(.horizontal, 24)
                        .padding(.bottom, 90)
                    }
                    .frame(maxWidth: .infinity)
                }
                .ignoresSafeArea(.keyboard)
            }
        }
        .fullScreenCover(item: $lessonToNavigate) { lesson in
            LessonView(
                lesson: lesson,
                chapterTitle: course.title,
                courseId: course.id,
                onDismiss: {
                    lessonToNavigate = nil
                    // Check if user was earning a break AND actually completed the lesson
                    if breakService.isEarningBreak && breakService.lessonDidComplete {
                        breakService.isEarningBreak = false
                        breakService.lessonDidComplete = false
                        showBreakEarned = true
                    } else {
                        // User exited without completing - reset flags
                        breakService.isEarningBreak = false
                        breakService.lessonDidComplete = false
                    }
                }
            )
        }
        .fullScreenCover(isPresented: $showBreakEarned) {
            BreakEarnedView(onStartBreak: {
                showBreakEarned = false
                breakService.startBreak(from: .takeBreakButton)
            })
        }
        .onChange(of: appState.triggerTakeBreakLesson) { _, shouldTrigger in
            if shouldTrigger {
                appState.triggerTakeBreakLesson = false
                // Show BlockerView
                showBreakPrompt = true
            }
        }
        .onChange(of: selectedLesson) { _, newValue in
            appState.isLessonPopupVisible = (newValue != nil)
        }
        .fullScreenCover(isPresented: $showBreakPrompt) {
            BlockerView(
                variant: BlockerVariant.allCases.randomElement() ?? .cosmic,
                onEarnTime: {
                    showBreakPrompt = false
                    breakService.beginEarningBreak()
                    // Open current lesson
                    if currentLessonIndex < allLessons.count {
                        lessonToNavigate = allLessons[currentLessonIndex]
                    }
                },
                onExit: {
                    showBreakPrompt = false
                }
            )
        }
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Journey Lesson Model
struct JourneyLesson: Identifiable {
    let id: String
    let order: Int
    let title: String
    let icon: String
}

// MARK: - Components
// Components are now in Core/Journey/Views/Components/

// MARK: - Mountain Background
private struct MountainBackground: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            Canvas { context, size in
                var distantPath = Path()
                distantPath.move(to: CGPoint(x: 0, y: h * 0.3))
                distantPath.addLine(to: CGPoint(x: w * 0.08, y: h * 0.22))
                distantPath.addLine(to: CGPoint(x: w * 0.15, y: h * 0.28))
                distantPath.addLine(to: CGPoint(x: w * 0.25, y: h * 0.15))
                distantPath.addLine(to: CGPoint(x: w * 0.35, y: h * 0.25))
                distantPath.addLine(to: CGPoint(x: w * 0.45, y: h * 0.12))
                distantPath.addLine(to: CGPoint(x: w * 0.55, y: h * 0.2))
                distantPath.addLine(to: CGPoint(x: w * 0.65, y: h * 0.1))
                distantPath.addLine(to: CGPoint(x: w * 0.75, y: h * 0.18))
                distantPath.addLine(to: CGPoint(x: w * 0.85, y: h * 0.08))
                distantPath.addLine(to: CGPoint(x: w * 0.92, y: h * 0.15))
                distantPath.addLine(to: CGPoint(x: w, y: h * 0.1))
                context.stroke(distantPath, with: .color(Color.appTextSecondary.opacity(0.06)), lineWidth: 1)
                
                var midPath = Path()
                midPath.move(to: CGPoint(x: 0, y: h * 0.55))
                midPath.addLine(to: CGPoint(x: w * 0.1, y: h * 0.45))
                midPath.addLine(to: CGPoint(x: w * 0.18, y: h * 0.52))
                midPath.addLine(to: CGPoint(x: w * 0.28, y: h * 0.38))
                midPath.addLine(to: CGPoint(x: w * 0.38, y: h * 0.48))
                midPath.addLine(to: CGPoint(x: w * 0.48, y: h * 0.32))
                midPath.addLine(to: CGPoint(x: w * 0.58, y: h * 0.42))
                midPath.addLine(to: CGPoint(x: w * 0.68, y: h * 0.3))
                midPath.addLine(to: CGPoint(x: w * 0.78, y: h * 0.4))
                midPath.addLine(to: CGPoint(x: w * 0.88, y: h * 0.28))
                midPath.addLine(to: CGPoint(x: w, y: h * 0.35))
                context.stroke(midPath, with: .color(Color.appTextSecondary.opacity(0.08)), lineWidth: 1)
                
                var frontPath = Path()
                frontPath.move(to: CGPoint(x: 0, y: h * 0.85))
                frontPath.addLine(to: CGPoint(x: w * 0.08, y: h * 0.72))
                frontPath.addLine(to: CGPoint(x: w * 0.15, y: h * 0.78))
                frontPath.addLine(to: CGPoint(x: w * 0.25, y: h * 0.62))
                frontPath.addLine(to: CGPoint(x: w * 0.32, y: h * 0.7))
                frontPath.addLine(to: CGPoint(x: w * 0.42, y: h * 0.55))
                frontPath.addLine(to: CGPoint(x: w * 0.52, y: h * 0.65))
                frontPath.addLine(to: CGPoint(x: w * 0.62, y: h * 0.5))
                frontPath.addLine(to: CGPoint(x: w * 0.72, y: h * 0.6))
                frontPath.addLine(to: CGPoint(x: w * 0.82, y: h * 0.48))
                frontPath.addLine(to: CGPoint(x: w * 0.92, y: h * 0.58))
                frontPath.addLine(to: CGPoint(x: w, y: h * 0.52))
                context.stroke(frontPath, with: .color(Color.appTextSecondary.opacity(0.12)), lineWidth: 1.5)
            }
        }
    }
}

// MARK: - Glass Lesson Card
private struct LessonCardGlass: View {
    let lesson: Lesson
    let isLocked: Bool
    let isCompleted: Bool
    let progress: Double
    let onPlayTap: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Lesson \(String(format: "%02d", lesson.order)) • Mastery")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.appBrand)
                
                Text(lesson.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.appTextPrimary)
                
                Group {
                    if !isLocked && progress > 0 {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.appCardBackground)
                                    .frame(height: 4)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.appBrand)
                                    .frame(width: geo.size.width * progress, height: 4)
                            }
                        }
                    } else {
                        Color.clear
                    }
                }
                .frame(height: 4)
            }
            
            Spacer()
            
            actionButton
        }
        .padding(20)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.appBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(Color.appTextSecondary.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
                    .shadow(color: .black.opacity(0.05), radius: 25, x: 0, y: 20)
            }
        )
    }
    
    @ViewBuilder
    private var actionButton: some View {
        if isLocked {
            Circle()
                .fill(Color.appCardBackground)
                .frame(width: 48, height: 48)
                .overlay {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.appTextSecondary)
                }
        } else {
            Button(action: onPlayTap) {
                Circle()
                    .fill(Color.appBrandLight)
                    .frame(width: 48, height: 48)
                    .overlay {
                        Image(systemName: isCompleted ? "arrow.counterclockwise" : "play.fill")
                            .font(.system(size: 16, weight: isCompleted ? .semibold : .regular))
                            .foregroundStyle(Color.appBrand)
                    }
            }
        }
    }
}

#Preview {
    MainTabView(selection: .journey)
}
