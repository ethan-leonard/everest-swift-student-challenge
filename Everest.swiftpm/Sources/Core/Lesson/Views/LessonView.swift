import SwiftUI

// MARK: - Lesson View
struct LessonView: View {
    let lesson: Lesson
    let chapterTitle: String
    let courseId: String
    let onDismiss: () -> Void
    
    @State private var progressService = UserProgressService.shared
    
    init(lesson: Lesson, chapterTitle: String, courseId: String, onDismiss: @escaping () -> Void) {
        self.lesson = lesson
        self.chapterTitle = chapterTitle
        self.courseId = courseId
        self.onDismiss = onDismiss
    }
    
    @State private var currentPageIndex = 0
    @State private var selectedAnswerIndex: Int? = nil
    @State private var showAnswerFeedback = false
    @State private var totalXP = 0
    @State private var showCompletionScreen = false
    @State private var showStreakScreen = false
    @State private var didIncrementStreak = false
    @State private var isMovingForward = true
    @State private var isAnswerLockedForPage = false
    @State private var xpBreakdown: [XPBreakdownItem] = []
    @State private var shuffledIndices: [String: [Int]] = [:]
    
    private let xpPerCorrectAnswer = 10
    private let xpPerLesson = 50
    
    private var currentPage: LessonPage {
        lesson.pages[currentPageIndex]
    }
    
    private var progress: Double {
        guard !lesson.pages.isEmpty else { return 0 }
        return Double(currentPageIndex + 1) / Double(lesson.pages.count)
    }
    
    private var isAnswerCorrect: Bool {
        guard let selected = selectedAnswerIndex,
              let question = currentPage.question else { return false }
        return selected == question.correctIndex
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            if showStreakScreen {
                StreakCelebrationView(
                    streakCount: $streakCount,
                    onContinue: onDismiss
                )
            } else if showLevelScreen {
                LevelProgressView(
                    xpBreakdown: xpBreakdown,
                    onContinue: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if didIncrementStreak {
                                showStreakScreen = true
                            } else {
                                onDismiss()
                            }
                        }
                    }
                )
            } else if showCompletionScreen {
                LessonCompleteView(
                    xpEarned: totalXP + xpPerLesson,
                    showCompletionScreen: $showCompletionScreen,
                    onContinue: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showLevelScreen = true
                        }
                    }
                )
            } else {
                mainLessonContent
            }
            
            if showAnswerFeedback {
                answerFeedbackOverlay
            }
        }
        .hideTabBar()
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            currentPageIndex = progressService.getSavedPageIndex(courseId: courseId, lessonId: lesson.id)

            // Pre-generate shuffled indices for all questions so we don't mutate state during view render
            var newShuffled: [String: [Int]] = [:]
            for page in lesson.pages {
                if let q = page.question {
                    newShuffled[page.id] = Array(0..<q.options.count).shuffled()
                }
            }
            shuffledIndices = newShuffled

            // Check for locked answer
            checkForLockedAnswer()
        }
        .onChange(of: currentPageIndex) { _, newValue in
            Task {
                await progressService.updatePageProgress(courseId: courseId, lessonId: lesson.id, pageIndex: newValue, totalPages: lesson.pages.count)
            }
            // Check for locked answer on new page
            checkForLockedAnswer()
        }
    }
    
    // MARK: - Main Lesson Content
    
    private var mainLessonContent: some View {
        VStack(spacing: 0) {
            progressBar
            headerSection
                .padding(.horizontal, 24)
                .padding(.top, 16)
            
            ZStack {
                if currentPage.pageType == .question {
                    questionContent
                        .id(currentPageIndex)
                        .transition(.asymmetric(
                            insertion: .move(edge: isMovingForward ? .trailing : .leading),
                            removal: .move(edge: isMovingForward ? .leading : .trailing)
                        ))
                } else {
                    lessonContent
                        .id(currentPageIndex)
                        .transition(.asymmetric(
                            insertion: .move(edge: isMovingForward ? .trailing : .leading),
                            removal: .move(edge: isMovingForward ? .leading : .trailing)
                        ))
                }
                
                if currentPage.pageType != .question {
                    tapZones
                }
            }
            // Add drag gesture to content area so swiping works
            .contentShape(Rectangle()) 
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { value in
                        if currentPage.pageType == .question {
                            // Only allow swiping back (right)
                            if value.translation.width > 50 { goPrevious() }
                        } else {
                            if value.translation.width < -50 { goNext() }
                            else if value.translation.width > 50 { goPrevious() }
                        }
                    }
            )
            .animation(.easeInOut(duration: 0.3), value: currentPageIndex)
            
            navigationHints
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
        }
    }
    
    // MARK: - Subviews
    
    private var progressBar: some View {
        GeometryReader { geo in
            Rectangle()
                .fill(Color.appBrand)
                .frame(width: geo.size.width * progress, height: 4)
                .animation(.linear(duration: 0.3), value: progress)
        }
        .frame(height: 4)
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: {
                // Ensure we save exact progress state before dismissing
                Task {
                    await progressService.updatePageProgress(courseId: courseId, lessonId: lesson.id, pageIndex: currentPageIndex, totalPages: lesson.pages.count)
                    await progressService.saveProgress()
                    await MainActor.run {
                        onDismiss()
                    }
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.appTextSecondary)
                    .frame(width: 44, height: 44)
                    .glassCircleStyle()
            }
            .accessibilityLabel("Back")
            
            Spacer()
            
            Text("CHAPTER \(String(format: "%02d", lesson.order)) • \(chapterTitle)")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Color.appBrand)
                .tracking(1)
            
            Spacer()
            
            Color.clear.frame(width: 44, height: 44)
        }
    }
    
    private var lessonContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                // Show illustration even if imageURL is nil (LessonIllustration handles defaults)
                LessonIllustration(imageKey: currentPage.imageURL, pageIndex: currentPageIndex)
                    .padding(.top, 40)
                    .transition(.scale.combined(with: .opacity))
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(currentPage.headline)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                    
                    Text(currentPage.body)
                        .font(.system(size: 17))
                        .foregroundStyle(Color.appTextSecondary)
                        .lineSpacing(6)
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 20)
        }
    }
    
    private var questionContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                Spacer(minLength: 40)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(currentPage.headline)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                    
                    Text(currentPage.body)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.appTextSecondary)
                }
                .padding(.horizontal, 24)
                
                if let question = currentPage.question {
                    let indices = getShuffledIndices(for: currentPage.id, optionCount: question.options.count)
                    VStack(spacing: 12) {
                        ForEach(Array(indices.enumerated()), id: \.offset) { displayIndex, originalIndex in
                            AnswerOptionButton(
                                text: question.options[originalIndex],
                                isSelected: selectedAnswerIndex == originalIndex,
                                isCorrect: originalIndex == question.correctIndex,
                                showResult: selectedAnswerIndex != nil
                            ) {
                                selectAnswer(originalIndex)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer(minLength: 120)
            }
            .padding(.top, 20)
        }
    }
    
    private func getShuffledIndices(for pageId: String, optionCount: Int) -> [Int] {
        return shuffledIndices[pageId] ?? Array(0..<optionCount)
    }
    
    private var navigationHints: some View {
        HStack {
            Button(action: goPrevious) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(currentPageIndex > 0 ? Color.appTextSecondary : Color.clear)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .disabled(currentPageIndex <= 0)
            
            Spacer()
            
            HStack(spacing: 6) {
                ForEach(0..<lesson.pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPageIndex ? Color.appBrand : Color.appTextSecondary.opacity(0.3))
                        .frame(width: 6, height: 6)
                        .animation(.spring, value: currentPageIndex)
                }
            }
            
            Spacer()
            
            Button(action: goNext) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(currentPageIndex < lesson.pages.count - 1 && (currentPage.pageType != .question || isAnswerLockedForPage) ? Color.appTextSecondary : Color.clear)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .disabled(currentPageIndex >= lesson.pages.count - 1 || (currentPage.pageType == .question && !isAnswerLockedForPage))
        }
    }
    
    private var tapZones: some View {
        HStack(spacing: 0) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { goPrevious() }
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { goNext() }
        }
    }
    
    // MARK: - Answer Feedback Overlay
    
    private var answerFeedbackOverlay: some View {
        VStack {
            Spacer()
            
            ZStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(isAnswerCorrect ? "Correct!" : "Incorrect")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .padding(.top, 8)
                    
                    if !isAnswerCorrect, let question = currentPage.question {
                        Text("Correct answer: \(question.options[question.correctIndex])")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.appTextPrimary.opacity(0.8))
                    }
                    
                    Button {
                        continueAfterAnswer()
                    } label: {
                        Text("Continue")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.appTextPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    }
                }
                .padding(24)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity)
                .background(
                    (isAnswerCorrect ? Color.appBrand : Color(hex: "F4A393"))
                        .clipShape(
                            .rect(
                                topLeadingRadius: 32,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 32
                            )
                        )
                        .shadow(color: .black.opacity(0.1), radius: 20, y: -5)
                        .ignoresSafeArea(edges: .bottom)
                )
                
                if isAnswerCorrect {
                    XPBadge(xp: xpPerCorrectAnswer)
                        .offset(y: -24)
                        .transition(.scale.combined(with: .move(edge: .bottom)))
                        .zIndex(1)
                }
            }
        }
        .transition(.move(edge: .bottom))
        .zIndex(100) // Ensure it stays on top
    }
    
    @State private var streakCount = 0
    @State private var pulseFlame = false
    @State private var showLevelScreen = false
    @State private var levelXP: Double = 450 // Start XP (Mock)
    @State private var levelProgress: Double = 0.75 // Start Progress
    

    
    // MARK: - Actions
    
    private func selectAnswer(_ index: Int) {
        guard !isAnswerLockedForPage else { return }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedAnswerIndex = index
        }
        
        if let question = currentPage.question, index == question.correctIndex {
            totalXP += xpPerCorrectAnswer
            // Track which question this is
            let questionNumber = lesson.pages.prefix(currentPageIndex + 1).filter { $0.pageType == .question }.count
            xpBreakdown.append(XPBreakdownItem(
                label: "Question \(questionNumber) Correct",
                xp: xpPerCorrectAnswer,
                icon: "checkmark.circle.fill"
            ))
        }
        
        Haptics.shared.play(.selection)
        
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(300))
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showAnswerFeedback = true
                Haptics.shared.play(self.isAnswerCorrect ? .success : .error)
                if self.isAnswerCorrect {
                    SoundManager.shared.playCorrect()
                } else {
                    SoundManager.shared.playIncorrect()
                }
            }
        }
    }
    
    private func continueAfterAnswer() {
        Haptics.shared.play(.medium)
        
        if let selectedIndex = selectedAnswerIndex {
            Task {
                await progressService.lockAnswer(courseId: courseId, pageId: currentPage.id, answerIndex: selectedIndex)
            }
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            showAnswerFeedback = false
        }
        
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(300))
            if currentPageIndex < lesson.pages.count - 1 {
                isMovingForward = true
                withAnimation(.easeInOut(duration: 0.2)) {
                    currentPageIndex += 1
                    selectedAnswerIndex = nil
                    isAnswerLockedForPage = false
                }
            } else {
                completeLesson()
            }
        }
    }
    
    private func goNext() {
        // Prevent skipping quiz questions without answering
        if currentPage.pageType == .question && selectedAnswerIndex == nil {
            Haptics.shared.play(.warning)
            return
        }
        
        guard currentPageIndex < lesson.pages.count - 1 else {
            completeLesson()
            return
        }
        isMovingForward = true
        Haptics.shared.play(.light)
        withAnimation(.easeInOut(duration: 0.2)) {
            currentPageIndex += 1
        }
        checkForLockedAnswer()
    }
    
    private func goPrevious() {
        guard currentPageIndex > 0 else { return }
        isMovingForward = false
        Haptics.shared.play(.light)
        withAnimation(.easeInOut(duration: 0.2)) {
            currentPageIndex -= 1
            showAnswerFeedback = false
        }
        checkForLockedAnswer()
    }
    
    private func completeLesson() {
        xpBreakdown.append(XPBreakdownItem(
            label: "Lesson Complete",
            xp: xpPerLesson,
            icon: "book.fill"
        ))
        
        let streakBonus = progressService.getPotentialStreakBonus()
        if streakBonus > 0 {
            xpBreakdown.append(XPBreakdownItem(
                label: "Daily Streak Bonus",
                xp: streakBonus,
                icon: "flame.fill"
            ))
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showCompletionScreen = true
            if BreakService.shared.isEarningBreak {
                BreakService.shared.lessonDidComplete = true
            }
            Haptics.shared.play(.success)
            Task {
                let streakIncremented = await progressService.addXP(totalXP + xpPerLesson + streakBonus)
                await MainActor.run {
                    self.didIncrementStreak = streakIncremented
                    if streakIncremented, let progress = progressService.userProgress {
                        self.streakCount = progress.currentStreak - 1
                    }
                }
                await progressService.markLessonComplete(
                    courseId: courseId,
                    lessonId: lesson.id,
                    xpEarned: totalXP + xpPerLesson + streakBonus,
                    lessonIndex: lesson.order - 1
                )
            }
        }
    }
    
    private func checkForLockedAnswer() {
        selectedAnswerIndex = nil
        isAnswerLockedForPage = false
        showAnswerFeedback = false
        
        if let lockedIndex = progressService.getLockedAnswer(courseId: courseId, pageId: currentPage.id) {
            selectedAnswerIndex = lockedIndex
            isAnswerLockedForPage = true
        }
    }
}

#Preview {
    LessonView(
        lesson: MockData.currentLesson,
        chapterTitle: "The Insight",
        courseId: "1",
        onDismiss: {}
    )
}
