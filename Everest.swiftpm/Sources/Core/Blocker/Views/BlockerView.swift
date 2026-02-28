import SwiftUI

// MARK: - Blocker Variant
enum BlockerVariant: CaseIterable {
    case cosmic   // Purple/Violet
    case aurora   // Teal/Cyan
    case sunset   // Rose/Mauve
    
    var meshColors: [Color] {
        switch self {
        case .cosmic:
            return [
                Color(hex: "1a1a2e"), // Deep dark
                Color(hex: "6B21A8"), // Purple
                Color(hex: "7C3AED"), // Violet
                Color(hex: "4C1D95"), // Deep purple
                Color(hex: "1a1a2e")  // Dark
            ]
        case .aurora:
            return [
                Color(hex: "0a1a1f"), // Deep teal-black
                Color(hex: "0D9488"), // Teal
                Color(hex: "14B8A6"), // Cyan
                Color(hex: "065F5B"), // Dark teal
                Color(hex: "0a1a1f")  // Dark
            ]
        case .sunset:
            return [
                Color(hex: "2a1a1a"), // Deep brown-black
                Color(hex: "C08080"), // Rose
                Color(hex: "8B5A5A"), // Mauve
                Color(hex: "5C3A3A"), // Deep rose
                Color(hex: "2a1a1a")  // Dark
            ]
        }
    }
    
    var headline: String {
        switch self {
        case .cosmic: return "PAUSE"
        case .aurora: return "BREATHE"
        case .sunset: return "REFLECT"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .cosmic: return Color(hex: "4C1D95")
        case .aurora: return Color(hex: "065F5B")
        case .sunset: return Color(hex: "5C3A3A")
        }
    }
}

// MARK: - Blocker View
struct BlockerView: View {
    let variant: BlockerVariant
    let onEarnTime: () -> Void
    let onExit: () -> Void
    
    init(
        variant: BlockerVariant = .cosmic,
        onEarnTime: @escaping () -> Void,
        onExit: @escaping () -> Void
    ) {
        self.variant = variant
        self.onEarnTime = onEarnTime
        self.onExit = onExit
    }
    
    var body: some View {
        ZStack {
            // Animated mesh gradient background
            AnimatedMeshBackground(colors: variant.meshColors)
                .ignoresSafeArea()
            
            // Animated floating particles
            AnimatedParticles()
            
            VStack(spacing: 0) {
                Spacer()
                
                // 3D Glassmorphic mountain icon
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.white.opacity(0.2), Color.clear],
                                center: .center,
                                startRadius: 60,
                                endRadius: 100
                            )
                        )
                        .frame(width: 180, height: 180)
                        .blur(radius: 20)
                    
                    // Glass circle with 3D effect
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 130, height: 130)
                        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.6), .white.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                    
                    // Inner highlight for 3D depth
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.15), .clear],
                                startPoint: .topLeading,
                                endPoint: .center
                            )
                        )
                        .frame(width: 130, height: 130)
                    
                    MountainLogo(fillColor: variant.iconColor)
                        .frame(width: 60, height: 60)
                }
                
                Spacer().frame(height: 40)
                
                // Headline only (no subtitle)
                Text(variant.headline)
                    .font(.system(size: 52, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 10, y: 4)
                
                Spacer()
                
                // 3D Glassmorphic CTA Button
                Button(action: onEarnTime) {
                    HStack(spacing: 10) {
                        Text("Complete Lesson")
                            .font(.system(size: 17, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        ZStack {
                            // Glass base
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(.ultraThinMaterial)
                            
                            // 3D highlight
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [.white.opacity(0.2), .clear],
                                        startPoint: .top,
                                        endPoint: .center
                                    )
                                )
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.25), radius: 15, y: 8)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50) // Increased bottom padding since Skip is gone
                
                // Skip button REMOVED as per Simplify Break Flow
            }
        }
    }
}

// MARK: - Animated Mesh Background (Restored OG)
struct AnimatedMeshBackground: View {
    let colors: [Color]
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1/30)) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                // Base dark color
                context.fill(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .color(colors[0])
                )
                
                // Animated color blobs
                for i in 0..<4 {
                    let phase = time * 0.3 + Double(i) * 1.5
                    let x = size.width * (0.3 + 0.4 * sin(phase + Double(i)))
                    let y = size.height * (0.3 + 0.4 * cos(phase * 0.7 + Double(i) * 0.5))
                    let radius = size.width * (0.4 + 0.1 * sin(phase * 0.5))
                    
                    let gradient = Gradient(colors: [
                        colors[i % colors.count].opacity(0.8),
                        colors[(i + 1) % colors.count].opacity(0.4),
                        Color.clear
                    ])
                    
                    context.drawLayer { ctx in
                        ctx.addFilter(.blur(radius: 60))
                        ctx.fill(
                            Circle().path(in: CGRect(
                                x: x - radius/2,
                                y: y - radius/2,
                                width: radius,
                                height: radius
                            )),
                            with: .radialGradient(
                                gradient,
                                center: CGPoint(x: x, y: y),
                                startRadius: 0,
                                endRadius: radius
                            )
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Mountain Logo
struct MountainLogo: View {
    var fillColor: Color = .white
    
    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            
            var path = Path()
            path.move(to: CGPoint(x: w * 0.1, y: h * 0.85))
            path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.15))
            path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.85))
            path.closeSubpath()
            
            context.fill(path, with: .color(.white))
            
            var notch = Path()
            notch.move(to: CGPoint(x: w * 0.35, y: h * 0.85))
            notch.addLine(to: CGPoint(x: w * 0.5, y: h * 0.5))
            notch.addLine(to: CGPoint(x: w * 0.65, y: h * 0.85))
            notch.closeSubpath()
            
            context.fill(notch, with: .color(fillColor))
        }
    }
}

// MARK: - Animated Floating Particles (Restored OG + Safety Guard)
struct AnimatedParticles: View {
    var body: some View {
        GeometryReader { geo in
            // Guard against zero size to prevent NaN errors (CRITICAL FIX)
            if geo.size.width > 0 && geo.size.height > 0 {
                ForEach(0..<18, id: \.self) { i in
                    AnimatedParticle(
                        size: CGFloat.random(in: 3...10),
                        initialX: CGFloat.random(in: 0...geo.size.width),
                        initialY: CGFloat.random(in: 0...geo.size.height),
                        opacity: Double.random(in: 0.2...0.5),
                        duration: Double.random(in: 5...10)
                    )
                }
            }
        }
    }
}

struct AnimatedParticle: View {
    let size: CGFloat
    let initialX: CGFloat
    let initialY: CGFloat
    let opacity: Double
    let duration: Double
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        Circle()
            .fill(Color.white.opacity(opacity))
            .frame(width: size, height: size)
            .position(x: initialX, y: initialY)
            .offset(offset)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: duration)
                    .repeatForever(autoreverses: true)
                ) {
                    offset = CGSize(
                        width: CGFloat.random(in: -40...40),
                        height: CGFloat.random(in: -50...50)
                    )
                }
            }
    }
}

// MARK: - Previews
#Preview("Cosmic") {
    BlockerView(variant: .cosmic, onEarnTime: {}, onExit: {})
}

#Preview("Aurora") {
    BlockerView(variant: .aurora, onEarnTime: {}, onExit: {})
}

#Preview("Sunset") {
    BlockerView(variant: .sunset, onEarnTime: {}, onExit: {})
}
