import SwiftUI

// MARK: - Course Card
/// Thumbnail card for course grid
struct CourseCard: View {
    let title: String
    let category: String
    let imageURL: String
    let progress: Int? // nil = not started
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image with category badge and progress
            ZStack(alignment: .topLeading) {
                // Background with category-themed gradient
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.appCardBackground)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        // Category-themed visual since we don't have local image assets
                        CourseIcon(category: category)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                
                // Category badge
                CategoryBadge(text: category)
                    .padding(12)
                
                // Progress badge (top right)
                if let progress {
                    ProgressBadge(percent: progress)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(12)
                }
            }
            
            // Title
            Text(title)
                .font(.titleMedium)
                .foregroundStyle(Color.appTextPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Subtitle if has progress
            if let progress {
                Text("\(progress)% complete")
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
    }
}

// MARK: - Category Badge
struct CategoryBadge: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.captionSmall)
            .foregroundStyle(Color.appTextPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
    }
}

// MARK: - Progress Badge
struct ProgressBadge: View {
    let percent: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.appBrand)
                .frame(width: 40, height: 40)
            
            Text("\(percent)%")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Preview
#Preview {
    LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 16) {
        CourseCard(
            title: "Deep Work Mastery",
            category: "Focus",
            imageURL: "deep_work",
            progress: 75
        )
        CourseCard(
            title: "ADHD Superpowers",
            category: "Focus",
            imageURL: "adhd",
            progress: nil
        )
    }
    .padding()
}
