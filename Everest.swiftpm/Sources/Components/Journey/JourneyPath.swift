import SwiftUI

// MARK: - Journey Path
/// Vertical winding path with mountain background
struct JourneyPath: View {
    let milestones: [JourneyMilestone]
    let onNodeTap: (JourneyMilestone) -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Mountain silhouette background removed (handled by parent view)
                
                // Path and nodes
                ScrollView(showsIndicators: false) {
                    ZStack {
                        // Winding path line
                        PathLine(nodeCount: milestones.count, width: geo.size.width)
                            .stroke(Color.appTextSecondary.opacity(0.2), lineWidth: 2)
                        
                        // Nodes
                        VStack(spacing: 80) {
                            ForEach(Array(milestones.enumerated()), id: \.element.id) { index, milestone in
                                JourneyNode(milestone: milestone)
                                    .offset(x: xOffset(for: index, width: geo.size.width))
                                    .onTapGesture {
                                        if milestone.state != .locked {
                                            onNodeTap(milestone)
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 40)
                    }
                }
            }
        }
    }
    
    private func xOffset(for index: Int, width: CGFloat) -> CGFloat {
        let amplitude = width * 0.2
        let pattern: [CGFloat] = [0, 1, 0.5, -0.5, -1, -0.5, 0.5]
        let normalizedIndex = index % pattern.count
        return pattern[normalizedIndex] * amplitude
    }
}

// MARK: - Path Line Shape
struct PathLine: Shape {
    let nodeCount: Int
    let width: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let nodeSpacing: CGFloat = 80 + 72 // spacing + approx node height
        let amplitude = width * 0.2
        
        guard nodeCount > 0 else { return path }
        
        let centerX = rect.midX
        var currentY: CGFloat = 40 + 28 // padding + half node
        
        path.move(to: CGPoint(x: centerX, y: currentY))
        
        for i in 0..<nodeCount {
            let pattern: [CGFloat] = [0, 1, 0.5, -0.5, -1, -0.5, 0.5]
            let offset = pattern[i % pattern.count] * amplitude
            let nextY = currentY + nodeSpacing
            
            // Bezier curve to next node
            let controlY = currentY + nodeSpacing / 2
            let nextOffset = i + 1 < nodeCount ? pattern[(i + 1) % pattern.count] * amplitude : 0
            
            path.addQuadCurve(
                to: CGPoint(x: centerX + nextOffset, y: nextY),
                control: CGPoint(x: centerX + offset, y: controlY)
            )
            
            currentY = nextY
        }
        
        return path
    }
}


// MARK: - Preview
#Preview {
    JourneyPath(milestones: MockData.milestones) { _ in }
        .frame(height: 600)
        .background(Color.appBackground)
}
