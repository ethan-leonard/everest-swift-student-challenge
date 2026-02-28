import SwiftUI

enum LessonState { case completed, current, locked }

struct LessonNode: View {
    let lesson: JourneyLesson
    let state: LessonState
    let isCurrent: Bool
    @State private var pingScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            if isCurrent {
                Circle()
                    .stroke(Color.appBrand.opacity(0.3), lineWidth: 2)
                    .frame(width: 80, height: 80)
                    .scaleEffect(pingScale)
                    .opacity(2 - pingScale)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
                            pingScale = 1.8
                        }
                    }
                
                Circle()
                    .fill(Color.appBrandLight.opacity(0.4))
                    .frame(width: 90, height: 90)
                
                Circle()
                    .fill(Color.appBrand)
                    .frame(width: 64, height: 64)
                    .shadow(color: Color.appBrand.opacity(0.3), radius: 12, y: 4)
                    .overlay {
                        Image(systemName: "play.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                    }
                
                Text("Current")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.appTextPrimary)
                    .clipShape(Capsule())
                    .offset(x: 55, y: 0)
            } else {
                Circle()
                    .fill(state == .locked ? Color.appCardBackground : .white)
                    .frame(width: 52, height: 52)
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
                    .overlay { Circle().stroke(Color.appCardBackground.opacity(0.5), lineWidth: 1) }
                    .overlay { iconForState() }
            }
        }
        .frame(width: 60, height: 60, alignment: .center)
    }
    
    @ViewBuilder
    private func iconForState() -> some View {
        switch state {
        case .completed:
            Image(systemName: "checkmark")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.appBrand)
        case .current:
            Image(systemName: "play.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color.appBrand)
        case .locked:
            Image(systemName: lesson.icon)
                .font(.system(size: 16))
                .foregroundStyle(Color.appTextSecondary.opacity(0.4))
        }
    }
}
