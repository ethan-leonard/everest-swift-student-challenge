import SwiftUI

// MARK: - Chapter Card
/// Row for course detail chapter list
struct ChapterCard: View {
    let number: Int
    let title: String
    let duration: Int
    let isCompleted: Bool
    let isLocked: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Number circle
            ZStack {
                Circle()
                    .fill(isCompleted ? Color.appBrand : Color.appCardBackground)
                    .frame(width: 40, height: 40)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                } else if isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.appTextSecondary)
                } else {
                    Text("\(number)")
                        .font(.titleMedium)
                        .foregroundStyle(Color.appTextPrimary)
                }
            }
            
            // Title
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.titleMedium)
                    .foregroundStyle(isLocked ? Color.appTextSecondary : Color.appTextPrimary)
                
                Text("\(duration) min")
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
            }
            
            Spacer()
            
            // Chevron
            if !isLocked {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        .padding(16)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .opacity(isLocked ? 0.6 : 1)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 12) {
        ChapterCard(number: 1, title: "The Deep Work Hypothesis", duration: 9, isCompleted: true, isLocked: false)
        ChapterCard(number: 2, title: "Rules for Focus", duration: 10, isCompleted: false, isLocked: false)
        ChapterCard(number: 3, title: "Embrace Boredom", duration: 8, isCompleted: false, isLocked: true)
    }
    .padding()
}
