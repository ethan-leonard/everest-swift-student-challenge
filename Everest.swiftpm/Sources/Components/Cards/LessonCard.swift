import SwiftUI

// MARK: - Lesson Card (Floating CTA)
/// Bottom floating card showing current lesson
struct LessonCard: View {
    let title: String
    let lessonNumber: Int
    let duration: Int
    let progress: Int
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Header row
            HStack {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.appBrandLight)
                        .frame(width: 44, height: 44)
                    Image(systemName: "figure.walk")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.appBrand)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.titleMedium)
                        .foregroundStyle(Color.appTextPrimary)
                    
                    Text("Lesson \(lessonNumber) • \(duration) min")
                        .font(.caption)
                        .foregroundStyle(Color.appTextSecondary)
                }
                
                Spacer()
                
                Text("\(progress)%")
                    .font(.titleMedium)
                    .foregroundStyle(Color.appBrand)
            }
            
            // Start button
            Button(action: onStart) {
                HStack {
                    Image(systemName: "play.fill")
                        .font(.system(size: 14))
                    Text("Start Lesson")
                        .font(.titleMedium)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.appBrand)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 20, y: 10)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        
        VStack {
            Spacer()
            LessonCard(
                title: "Ridge Walk",
                lessonNumber: 3,
                duration: 12,
                progress: 65,
                onStart: {}
            )
            .padding()
        }
    }
}
