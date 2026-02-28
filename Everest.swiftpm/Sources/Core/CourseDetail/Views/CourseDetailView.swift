import SwiftUI

// MARK: - Course Detail View
struct CourseDetailView: View {
    let course: Course
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorited = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                NavBar(isFavorited: $isFavorited, courseId: course.id, courseTitle: course.title, courseImageURL: course.imageURL, dismiss: dismiss)
                    .padding(.bottom, 16)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        HeroSection(course: course)
                        
                        StatsRow(course: course)
                        
                        VStack(alignment: .leading, spacing: 32) {
                            WhatsInsideSection(course: course)
                            ExpertReviewSection(course: course)
                            CommunityReviewsSection(course: course)
                        }
                        
                        Spacer(minLength: 140)
                    }
                }
            }
            
            StartCourseButton(course: course, dismiss: dismiss)
        }
        .background(Color.appBackground)
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .hideTabBar()
        // Absorb horizontal drags that the vertical ScrollView ignores, preventing the whole screen from floating
        .gesture(DragGesture())
    }
}

// MARK: - Nav Bar
private struct NavBar: View {
    @Binding var isFavorited: Bool
    let courseId: String
    let courseTitle: String
    let courseImageURL: String
    let dismiss: DismissAction
    @State private var showShareSheet = false
    @State private var shareImage: UIImage? = nil
    
    private var shareItems: [Any] {
        var items: [Any] = []
        
        if let image = shareImage {
            items.append(image)
        }
        
        items.append("I'm learning \(courseTitle) on Everest! 🏔️\n\nDownload Everest to start your learning journey.")
        
        return items
    }
    
    var body: some View {
        HStack {
            navButton(icon: "arrow.left", label: "Back") { dismiss() }
            Spacer()
            HStack(spacing: 12) {
                navButton(icon: isFavorited ? "heart.fill" : "heart", label: isFavorited ? "Remove from favorites" : "Add to favorites") {
                    Task {
                        await UserProgressService.shared.toggleCourseSaved(courseId: courseId)
                        isFavorited = UserProgressService.shared.isCourseSaved(courseId: courseId)
                    }
                }
                navButton(icon: "square.and.arrow.up", label: "Share") {
                    showShareSheet = true
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .onAppear {
            isFavorited = UserProgressService.shared.isCourseSaved(courseId: courseId)
            loadShareImage()
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: shareItems)
        }
    }
    
    private func loadShareImage() {
        guard let url = URL(string: courseImageURL), !courseImageURL.isEmpty else { return }
        
        Task {
            if let cached = await ImageCacheService.shared.get(forKey: courseImageURL) {
                shareImage = cached
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await ImageCacheService.shared.set(image, forKey: courseImageURL)
                    await MainActor.run {
                        shareImage = image
                    }
                }
            } catch {
                #if DEBUG
                print("[CourseDetail] Share image load failed: \(error.localizedDescription)")
                #endif
            }
        }
    }
    
    private func navButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.appTextSecondary)
                .frame(width: 44, height: 44)
                .glassCircleStyle()
        }
        .accessibilityLabel(label)
    }
}

private struct HeroSection: View {
    let course: Course
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.appCardBackground)
                .frame(height: 460)
                .overlay {
                    if let url = URL(string: course.imageURL), !course.imageURL.isEmpty {
                        CachedAsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            gradientFallback
                        }
                    } else {
                        gradientFallback
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            
            LinearGradient(
                colors: [.clear, .clear, .black.opacity(0.3), .black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            
            VStack(alignment: .leading, spacing: 12) {
                if let tag = course.tag {
                    Text(tag.uppercased())
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "C6E8D3"))
                        .clipShape(Capsule())
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mastering")
                        .font(.system(size: 32, weight: .regular))
                        .foregroundStyle(.white.opacity(0.9))
                    
                    Text(course.title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                }
                .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 2)
            }
            .padding(32)
        }
        .padding(.horizontal, 24)
    }
    
    private var gradientFallback: some View {
        LinearGradient(
            colors: [Color(hex: "2D3748"), Color(hex: "4A5568")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Stats Row
private struct StatsRow: View {
    let course: Course
    
    var body: some View {
        HStack(spacing: 0) {
            StatPill(icon: "lightbulb.fill", value: "\(course.totalLessons)", label: "Lessons")
            Divider().frame(height: 40)
            StatPill(icon: "clock.fill", value: "\(course.durationMinutes)", label: "Min")
            Divider().frame(height: 40)
            StatPill(icon: "star.fill", value: String(format: "%.1f", course.rating), label: "Rating")
        }
        .padding(.horizontal, 24)
    }
}

private struct StatPill: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.appBrand.opacity(0.3), lineWidth: 1.5)
                    .frame(width: 52, height: 52)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.appBrand)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.appTextPrimary)
                Text(label)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - What's Inside Section
private struct WhatsInsideSection: View {
    let course: Course
    
    private let bulletPoints: [String]
    
    init(course: Course) {
        self.course = course
        self.bulletPoints = course.whatsInside
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What's Inside")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.appTextPrimary)
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(bulletPoints, id: \.self) { point in
                    HStack(alignment: .top, spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.appBrand)
                            .padding(.top, 2)
                        
                        Text(point)
                            .font(.system(size: 16))
                            .foregroundStyle(Color.appTextSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(4)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Expert Review Section
private struct ExpertReviewSection: View {
    let course: Course
    
    var body: some View {
        if let review = course.expertReview {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "quote.opening")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.appBrand.opacity(0.3))
                    
                    Text("Expert Review")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                }
                
                Text(review.quote)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineSpacing(6)
                
                HStack(spacing: 16) {
                    ReviewAvatarView(name: review.name, size: 48)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(review.name)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.appTextPrimary)
                        
                        Text(review.title.uppercased())
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(Color.appBrand)
                            .tracking(0.5)
                    }
                }
                .padding(.top, 8)
            }
            .padding(24)
            .glassCardStyle()
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Community Reviews Section
private struct CommunityReviewsSection: View {
    let course: Course
    
    var body: some View {
        if let reviews = course.reviews, !reviews.isEmpty {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Community Reviews")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.orange)
                        Text(String(format: "%.1f", course.rating))
                            .fontWeight(.semibold)
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color.appTextPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.appCardBackground)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 24)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(reviews) { review in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    ReviewAvatarView(name: review.name, size: 40)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(review.name)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(Color.appTextPrimary)
                                        
                                        HStack(spacing: 4) {
                                            ForEach(0..<5) { index in
                                                Image(systemName: index < review.rating ? "star.fill" : "star")
                                                    .font(.system(size: 10))
                                                    .foregroundStyle(index < review.rating ? Color.orange : Color.appTextSecondary.opacity(0.3))
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Text(review.timeAgo)
                                        .font(.system(size: 11))
                                        .foregroundStyle(Color.appTextSecondary)
                                }
                                
                                Text(review.text)
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.appTextPrimary.opacity(0.9))
                                    .lineLimit(4)
                                    .lineSpacing(2)
                            }
                            .padding(16)
                            .frame(width: 280)
                            .glassCardStyle()
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24) // Space for shadow
                }
            }
        }
    }
}

// MARK: - Start Course Button
private struct StartCourseButton: View {
    let course: Course
    let dismiss: DismissAction
    
    var body: some View {
        Button {
            Task {
                await UserProgressService.shared.startCourse(courseId: course.id)
                AppState.shared.selectCourseAndNavigate(course)
                dismiss()
            }
        } label: {
            HStack(spacing: 8) {
                Text("Start Course")
                    .font(.system(size: 17, weight: .bold))
                
                Image(systemName: "play.fill")
                    .font(.system(size: 14))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.appBrand)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.appBrand.opacity(0.3), radius: 10, y: 5)
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 34)
        .background(
            LinearGradient(
                colors: [.clear, Color.appBackground, Color.appBackground],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 140) // Taller gradient for better fade
        )
    }
}

// MARK: - Review Avatar View
struct ReviewAvatarView: View {
    let name: String
    var size: CGFloat = 48
    
    // Curated diverse set of face emojis (professional/neutral)
    private let avatars = [
        "👨🏻", "👩🏼", "👨🏽", "👩🏾", "👨🏿", "👩🏻",
        "👱🏼‍♂️", "👩🏽‍🦱", "👨🏾‍🦱", "👩🏿‍🦰", "🧔🏻", "🧕🏼",
        "👲🏽", "👴🏾", "👵🏿", "👱🏻‍♀️", "👳🏾‍♂️", "👩🏼‍💼",
        "👨🏽‍💼", "🧑🏻‍🏫", "👩🏾‍💻", "👨🏿‍🔬", "🧑🏼‍🎨", "👨🏻‍⚕️"
    ]
    
    // Muted, premium pastel backgrounds
    private let backgroundColors = [
        Color(hex: "E2E8F0"), // Slate 200
        Color(hex: "FED7D7"), // Red 200
        Color(hex: "FEEBC8"), // Orange 200
        Color(hex: "FEFCBF"), // Yellow 200
        Color(hex: "C6F6D5"), // Green 200
        Color(hex: "B2F5EA"), // Teal 200
        Color(hex: "BEE3F8"), // Blue 200
        Color(hex: "E9D8FD"), // Purple 200
        Color(hex: "FED7E2")  // Pink 200
    ]
    
    private var avatarIndex: Int {
        abs(name.hashValue) % avatars.count
    }
    
    private var colorIndex: Int {
        abs(name.hashValue) % backgroundColors.count
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColors[colorIndex])
                .frame(width: size, height: size)
            
            Text(avatars[avatarIndex])
                .font(.system(size: size * 0.55))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .overlay(
            Circle()
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
    }
}


