import SwiftUI

// MARK: - Library View
struct LibraryView: View {
    @State private var selectedFilter = "All"
    
    private var courseService = CourseService.shared
    private var progressService = UserProgressService.shared
    
    let filters = ["All", "Started", "Completed", "Saved"]
    
    private var courses: [Course] {
        courseService.courses
    }
    
    private var filteredCourses: [Course] {
        guard let progress = progressService.userProgress else {
            return [] // If no progress loaded, show nothing in My Progress
        }
        
        return courses.filter { course in
            guard let courseProgress = progress.courseProgress[course.id] else {
                return false // Not started or saved
            }
            
            switch selectedFilter {
            case "All":
                // Show if started OR saved
                let isStarted = !courseProgress.completedLessonIds.isEmpty || 
                                !courseProgress.pageProgress.isEmpty || 
                                courseProgress.currentLessonIndex > 0
                return courseProgress.isSaved || isStarted
                
            case "Started":
                return !courseProgress.completedLessonIds.isEmpty &&
                       courseProgress.completedLessonIds.count < course.totalLessons
            case "Completed":
                return courseProgress.completedLessonIds.count >= course.totalLessons
            case "Saved":
                return courseProgress.isSaved
            default:
                return false
            }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                
                SlidingSegmentedControl(options: filters, selected: $selectedFilter)
                
                if progressService.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else if filteredCourses.isEmpty {
                    emptyState
                } else {
                    courseGrid
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
        .background(Color.appBackground)
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
        .hideTabBar(false)
        .navigationDestination(for: Course.self) { course in
            CourseDetailView(course: course)
        }
        .task {
            await progressService.fetchProgress()
            if courses.isEmpty {
                await courseService.fetchAllCourses()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Progress")
                    .font(.system(size: 34, weight: .regular))
                    .foregroundStyle(Color.appTextPrimary)
                
                Text("Tracking your growth, Ethan")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.appTextSecondary)
            }
            
            Spacer()
            
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.appTextSecondary)
                    .frame(width: 44, height: 44)
                    .glassCircleStyle()
            }
        }
    }
    
    private var courseGrid: some View {
        LazyVGrid(columns: [.init(.flexible(), spacing: 16), .init(.flexible())], spacing: 16) {
            ForEach(filteredCourses) { course in
                let percent = Double(progressService.courseProgress(for: course.id, totalLessons: course.totalLessons))
                
                NavigationLink(value: course) {
                    ProgressCourseCard(
                        course: course,
                        progressPercent: percent,
                        completedCount: progressService.userProgress?.courseProgress[course.id]?.completedLessonIds.count ?? 0
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.closed")
                .font(.system(size: 48))
                .foregroundStyle(Color.appTextSecondary)
            
            Text("No courses yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.appTextPrimary)
            
            Text("Start exploring to add courses here")
                .font(.system(size: 14))
                .foregroundStyle(Color.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

// MARK: - Sliding Segmented Control
struct SlidingSegmentedControl: View {
    let options: [String]
    @Binding var selected: String
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(options, id: \.self) { option in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selected = option
                    }
                } label: {
                    Text(option)
                        .font(.system(size: 13, weight: .medium)) // Slightly smaller font
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .foregroundStyle(selected == option ? .white : Color.appTextSecondary)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity) // Equal width distribution
                        .background {
                            if selected == option {
                                selectedBackground
                            }
                        }
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
             RoundedRectangle(cornerRadius: 16, style: .continuous)
                 .fill(.white)
                 .overlay {
                     RoundedRectangle(cornerRadius: 16, style: .continuous)
                         .strokeBorder(Color(hex: "E5E5EA").opacity(0.8), lineWidth: 1)
                 }
        )
    }
    
    private var selectedBackground: some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [Color.appBrand.opacity(0.9), Color.appBrand],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay {
                Capsule()
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.25), .white.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            }
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 3)
            .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
            .matchedGeometryEffect(id: "segment", in: animation)
    }
}

struct ProgressCourseCard: View {
    let course: Course
    let progressPercent: Double
    var completedCount: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.appCardBackground)
                    .aspectRatio(0.7, contentMode: .fit)
                    .overlay {
                        if let url = URL(string: course.imageURL), !course.imageURL.isEmpty {
                            CachedAsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                CourseIcon(category: course.category)
                            }
                        } else {
                            CourseIcon(category: course.category)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                
                if progressPercent > 0 {
                    progressIndicator
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                if completedCount > 0 {
                    Text("\(completedCount)/\(course.totalLessons) Lessons")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.appTextSecondary)
                } else {
                    Text("\(course.totalLessons) Lessons")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.appTextSecondary)
                }
                
                Spacer(minLength: 0)
            }
            .frame(height: 60, alignment: .top)
        }
    }
    
    private var progressIndicator: some View {
        ZStack {
            Circle()
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
            
            Circle()
                .stroke(Color.gray.opacity(0.12), lineWidth: 1.8)
            
            Circle()
                .trim(from: 0, to: progressPercent / 100)
                .stroke(
                    progressPercent >= 100 ? Color.green : Color.appBrand,
                    style: StrokeStyle(lineWidth: 1.8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progressPercent))%")
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(Color.appTextPrimary)
        }
        .frame(width: 34, height: 34)
        .padding(11)
    }
}

#Preview {
    MainTabView(selection: .library)
}
