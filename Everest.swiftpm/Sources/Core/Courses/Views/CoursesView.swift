import SwiftUI

// MARK: - Courses View
struct CoursesView: View {
    @State private var selectedCategory = "All Courses"
    @State private var showSearch = false
    @State private var searchText = ""
    
    private var courseService = CourseService.shared
    
    let categories = ["All Courses", "Focus", "Wealth", "Wellness"]
    
    private var courses: [Course] {
        courseService.courses
    }
    
    private var filteredCourses: [Course] {
        var result = courses
        
        if selectedCategory != "All Courses" {
            result = result.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                
                if showSearch {
                    SearchBar("Search courses...", text: $searchText)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.bottom, 8)
                }
                
                categoryPills
                
                if courseService.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else if filteredCourses.isEmpty {
                    ContentUnavailableView(
                        "No Courses",
                        systemImage: "book.closed",
                        description: Text("Check back soon for new content")
                    )
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
            if courses.isEmpty {
                await courseService.fetchAllCourses()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Explore")
                    .font(.system(size: 34, weight: .regular))
                    .foregroundStyle(Color.appTextPrimary)
                
                Text("Expand your horizons")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.appTextSecondary)
            }
            
            Spacer()
            
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    showSearch.toggle()
                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.appTextPrimary)
                    .frame(width: 44, height: 44)
                    .glassCircleStyle()
            }
            
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.appTextSecondary)
                    .frame(width: 44, height: 44)
                    .glassCircleStyle()
            }
        }
    }
    
    private var categoryPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    CategoryPill(
                        title: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedCategory = category
                        }
                    }
                }
            }
        }
    }
    
    private var courseGrid: some View {
        LazyVGrid(columns: [.init(.flexible(), spacing: 16), .init(.flexible())], spacing: 24) {
            ForEach(filteredCourses) { course in
                NavigationLink(value: course) {
                    ExploreCourseCard(course: course)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Explore Course Card
struct ExploreCourseCard: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
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
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true) // Ensure text wraps properly
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.appTextSecondary)
                    
                    Text("\(course.totalLessons) Lessons • \(course.durationMinutes / 60)h")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.appTextSecondary)
                }
                
                Spacer(minLength: 0) // Push content up
            }
            .frame(height: 60, alignment: .top) // Fixed height for text area to align cards
        }
    }
}

// MARK: - Course Icon
struct CourseIcon: View {
    let category: String
    
    var iconName: String {
        switch category {
        case "Philosophy": return "globe.europe.africa.fill"
        case "Psychology": return "circle.hexagongrid.fill"
        case "Stoicism": return "crown.fill"
        case "Habits": return "leaf.fill"
        default: return "book.fill"
    }
    }
    
    var iconColor: Color {
        switch category {
        case "Philosophy": return Color.appBrand
        case "Psychology": return Color(hex: "E07D5A")
        case "Stoicism": return Color(hex: "1A202C")
        case "Habits": return Color.appBrand.opacity(0.8)
        default: return Color.appBrand
        }
    }
    
    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: 44))
            .foregroundStyle(iconColor)
    }
}

#Preview {
    MainTabView()
}
