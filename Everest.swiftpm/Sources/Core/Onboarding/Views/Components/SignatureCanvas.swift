import SwiftUI

struct Line: Identifiable {
    let id = UUID()
    var points: [CGPoint] = []
    
    var path: Path {
        var path = Path()
        guard let firstPoint = points.first else { return path }
        
        path.move(to: firstPoint)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        return path
    }
}

struct Sparkle: Identifiable {
    let id: UUID
    var position: CGPoint
    var color: Color
    var size: CGFloat
    var opacity: Double
    var velocity: CGPoint
}

struct SignatureCanvas: View {
    @Binding var lines: [Line]
    @Binding var isLocked: Bool
    @State private var currentLine = Line()
    @State private var sparkles: [Sparkle] = []
    @State private var lastUpdate = Date()
    
    var onDrawingChanged: () -> Void
    
    var body: some View {
        TimelineView(.animation) { timeline in
            ZStack {
                ForEach(sparkles) { sparkle in
                    Circle()
                        .fill(sparkle.color)
                        .frame(width: sparkle.size, height: sparkle.size)
                        .position(sparkle.position)
                        .opacity(sparkle.opacity)
                }
                
                ForEach(lines) { line in
                    line.path.stroke(
                        LinearGradient(
                            colors: [Color.appBrand, Color.appBrand.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                    )
                }
                
                if !currentLine.points.isEmpty {
                    currentLine.path.stroke(
                        LinearGradient(
                            colors: [Color.appBrand, Color.appBrand.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                    )
                }
                
                Color.white.opacity(0.001)
            }
            .drawingGroup()
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        guard !isLocked else { return }
                        
                        let newPoint = value.location
                        currentLine.points.append(newPoint)
                        
                        addSparkle(at: newPoint)
                        
                        if currentLine.points.count % 2 == 0 {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.5)
                        }
                    }
                    .onEnded { value in
                        guard !isLocked else { return }
                        
                        lines.append(currentLine)
                        currentLine = Line()
                        onDrawingChanged()
                        
                        isLocked = true
                    }
            )
            .onChange(of: timeline.date) { oldValue, newDate in
                updateSparkles(delta: 1/60.0)
            }
        }
    }
    
    private func addSparkle(at position: CGPoint) {
        let randomX = CGFloat.random(in: -10...10)
        let randomY = CGFloat.random(in: -10...10)
        let sparklePos = CGPoint(x: position.x + randomX, y: position.y + randomY)
        
        let sparkle = Sparkle(
            id: UUID(),
            position: sparklePos,
            color: Color.appBrand.opacity(Double.random(in: 0.5...1.0)),
            size: CGFloat.random(in: 2...6),
            opacity: 1.0,
            velocity: CGPoint(x: CGFloat.random(in: -2...2), y: CGFloat.random(in: -2...2))
        )
        sparkles.append(sparkle)
    }
    
    private func updateSparkles(delta: TimeInterval) {
        let timeScale = CGFloat(delta * 60)
        
        for i in sparkles.indices.reversed() {
            sparkles[i].position.x += sparkles[i].velocity.x * timeScale
            sparkles[i].position.y += sparkles[i].velocity.y * timeScale
            sparkles[i].opacity -= 0.05 * Double(timeScale)
            sparkles[i].size *= (1.0 - (0.05 * Double(timeScale)))
        }
        
        sparkles.removeAll { $0.opacity <= 0 || $0.size <= 0.5 }
    }
}
