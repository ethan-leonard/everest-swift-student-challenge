import SwiftUI

struct JourneyPathView: View {
    let lessons: [JourneyLesson]
    let currentIndex: Int
    let onLessonTap: (JourneyLesson) -> Void
    
    private let nodeSpacing: CGFloat = 120
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            
            ZStack {
                // Draw path lines
                ForEach(0..<max(0, lessons.count - 1), id: \.self) { index in
                    let fromY = CGFloat(lessons.count - index - 1) * nodeSpacing + 120
                    let toY = CGFloat(lessons.count - index - 2) * nodeSpacing + 120
                    let fromX = width * xOffsetForIndex(index)
                    let toX = width * xOffsetForIndex(index + 1)
                    let angle = atan2(toY - fromY, toX - fromX)
                    let offset: CGFloat = 30 // Radius of the node to skip drawing inside
                    
                    let shortenedFrom = CGPoint(
                        x: fromX + cos(angle) * offset,
                        y: fromY + sin(angle) * offset
                    )
                    let shortenedTo = CGPoint(
                        x: toX - cos(angle) * offset,
                        y: toY - sin(angle) * offset
                    )
                    
                    let isTraveled = index < currentIndex

                    PathSegment(from: shortenedFrom, to: shortenedTo, isTraveled: isTraveled)
                }
            }
            
            // Lesson nodes in a VStack for proper ScrollViewReader support
            VStack(spacing: 0) {
                // Lessons are rendered TOP to BOTTOM (reversed order)
                ForEach(lessons.reversed()) { lesson in
                    let index = lessons.firstIndex(where: { $0.id == lesson.id }) ?? 0
                    let xOffset = xOffsetForIndex(index)
                    
                    HStack {
                        Spacer()
                            .frame(width: width * xOffset - 30)
                        
                        LessonNode(lesson: lesson, state: lessonState(for: index), isCurrent: index == currentIndex)
                            .id(lesson.id) // ID for ScrollViewReader
                            .onTapGesture { onLessonTap(lesson) }
                        
                        Spacer()
                    }
                    .frame(height: nodeSpacing)
                }
            }
            .padding(.top, 60) // Match original offset
        }
        .padding(.horizontal, 40)
    }
    
    private func xOffsetForIndex(_ index: Int) -> CGFloat {
        let offsets: [CGFloat] = [0.5, 0.35, 0.65, 0.4, 0.6, 0.3, 0.7, 0.45, 0.55, 0.38, 0.62, 0.5]
        return offsets[index % offsets.count]
    }
    
    private func lessonState(for index: Int) -> LessonState {
        if index < currentIndex { return .completed }
        else if index == currentIndex { return .current }
        else { return .locked }
    }
}

struct PathSegment: View {
    let from: CGPoint
    let to: CGPoint
    let isTraveled: Bool
    
    var body: some View {
        Canvas { context, _ in
            var path = Path()
            path.move(to: from)
            path.addLine(to: to)
            
            if isTraveled {
                context.stroke(path, with: .color(Color.appBrand), style: StrokeStyle(lineWidth: 4, lineCap: .round))
            } else {
                context.stroke(path, with: .color(Color.appTextSecondary.opacity(0.25)), style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [12, 12]))
            }
        }
    }
}
