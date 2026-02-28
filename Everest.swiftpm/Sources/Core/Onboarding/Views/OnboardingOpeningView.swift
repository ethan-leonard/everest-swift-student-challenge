import SwiftUI

struct OnboardingOpeningView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    var body: some View {
        ZStack {
            // MARK: - Animated Mesh Background (like Blocker)
            OpeningMeshBackground()
                .ignoresSafeArea()
            
            // Floating Particles
            OpeningParticles()
            
            // Large Mountain Silhouettes
            GeometryReader { geo in
                ZStack(alignment: .bottom) {
                    // Back mountain layer
                    OpeningMountainShape(variant: .back)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "2D4A6F").opacity(0.6), Color(hex: "1E3A5F").opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: geo.size.height * 0.55)
                        .offset(y: 20)
                    
                    // Front mountain layer (main)
                    OpeningMountainShape(variant: .front)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "1E3A5F"), Color(hex: "0F2744")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: geo.size.height * 0.48)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .ignoresSafeArea()
            
            // Shooting Stars (near mountain tops)
            OpeningShootingStars()
            
            // MARK: - Content
            VStack(spacing: 0) {
                // Glass Header
                OnboardingHeader(showBackButton: false, isHighContrast: true)
                
                Spacer()
                
                // Title Section
                VStack(spacing: 16) {
                    Text("Everest")
                        .font(.system(size: 52, weight: .black))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.4), radius: 20, y: 8)
                    
                    Text("Stop Doom Scrolling")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.85))
                }
                
                Spacer()
                
                // Glass Button
                Button {
                    Haptics.shared.play(.medium)
                    viewModel.nextStep()
                } label: {
                    HStack(spacing: 10) {
                        Text("Start Climbing")
                            .font(.system(size: 17, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(.ultraThinMaterial)
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [.white.opacity(0.25), .clear],
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
                    .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

// MARK: - Animated Mesh Background
struct OpeningMeshBackground: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1/30)) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                // Base gradient
                let baseGradient = Gradient(colors: [
                    Color(hex: "1E3A5F"),
                    Color(hex: "2D4A6F"),
                    Color(hex: "3D5A80")
                ])
                context.fill(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .linearGradient(
                        baseGradient,
                        startPoint: .zero,
                        endPoint: CGPoint(x: 0, y: size.height)
                    )
                )
                
                // Animated aurora blobs
                let colors: [Color] = [
                    Color(hex: "4A7C59").opacity(0.4), // Brand green
                    Color(hex: "6B8F71").opacity(0.3),
                    Color(hex: "3D5A80").opacity(0.5),
                    Color(hex: "5C7A99").opacity(0.3)
                ]
                
                for i in 0..<4 {
                    let phase = time * 0.2 + Double(i) * 1.2
                    let x = size.width * (0.2 + 0.6 * sin(phase + Double(i)))
                    let y = size.height * (0.15 + 0.3 * cos(phase * 0.8))
                    let radius = size.width * (0.5 + 0.2 * sin(phase * 0.4))
                    
                    let gradient = Gradient(colors: [
                        colors[i % colors.count],
                        Color.clear
                    ])
                    
                    context.drawLayer { ctx in
                        ctx.addFilter(.blur(radius: 80))
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

// MARK: - Mountain Shapes
struct OpeningMountainShape: Shape {
    enum Variant { case back, front }
    let variant: Variant
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: 0, y: h))
        
        if variant == .back {
            path.addLine(to: CGPoint(x: 0, y: h * 0.7))
            path.addLine(to: CGPoint(x: w * 0.15, y: h * 0.4))
            path.addLine(to: CGPoint(x: w * 0.3, y: h * 0.55))
            path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.2))
            path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.5))
            path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.35))
            path.addLine(to: CGPoint(x: w, y: h * 0.5))
        } else {
            path.addLine(to: CGPoint(x: 0, y: h * 0.8))
            path.addLine(to: CGPoint(x: w * 0.1, y: h * 0.6))
            path.addLine(to: CGPoint(x: w * 0.25, y: h * 0.75))
            path.addLine(to: CGPoint(x: w * 0.4, y: h * 0.35))
            path.addLine(to: CGPoint(x: w * 0.55, y: h * 0.5))
            path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.15)) // Main summit
            path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.55))
            path.addLine(to: CGPoint(x: w, y: h * 0.4))
        }
        
        path.addLine(to: CGPoint(x: w, y: h))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Floating Particles
struct OpeningParticles: View {
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<15, id: \.self) { i in
                OpeningParticle(
                    size: CGFloat.random(in: 2...6),
                    x: CGFloat.random(in: 0...geo.size.width),
                    y: CGFloat.random(in: 0...geo.size.height * 0.6),
                    opacity: Double.random(in: 0.2...0.5),
                    duration: Double.random(in: 4...8)
                )
            }
        }
        .allowsHitTesting(false)
    }
}

struct OpeningParticle: View {
    let size: CGFloat
    let x: CGFloat
    let y: CGFloat
    let opacity: Double
    let duration: Double
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        Circle()
            .fill(Color.white.opacity(opacity))
            .frame(width: size, height: size)
            .position(x: x, y: y)
            .offset(offset)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: duration)
                    .repeatForever(autoreverses: true)
                ) {
                    offset = CGSize(
                        width: CGFloat.random(in: -30...30),
                        height: CGFloat.random(in: -40...40)
                    )
                }
            }
    }
}

// MARK: - Shooting Stars
struct OpeningShootingStars: View {
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<4, id: \.self) { i in
                OpeningStar(
                    idx: i,
                    bounds: geo.size
                )
            }
        }
        .allowsHitTesting(false)
    }
}

struct OpeningStar: View {
    let idx: Int
    let bounds: CGSize
    
    @State private var isAnimating = false
    @State private var position: CGPoint = .zero
    
    var body: some View {
        Rectangle()
            .fill(Color.white)
            .mask(
                LinearGradient(
                    colors: [.clear, .white, .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: 80, height: 2)
            .shadow(color: .white, radius: 4)
            .rotationEffect(.degrees(35))
            .position(position)
            .opacity(isAnimating ? 1 : 0)
            .onAppear {
                // Start in upper portion near mountain peaks
                position = CGPoint(
                    x: CGFloat.random(in: 0...(bounds.width * 0.5)),
                    y: CGFloat.random(in: bounds.height * 0.2...bounds.height * 0.45)
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(idx) * 2.5 + 1.0) {
                    animate()
                }
            }
    }
    
    private func animate() {
        position = CGPoint(
            x: CGFloat.random(in: 0...(bounds.width * 0.5)),
            y: CGFloat.random(in: bounds.height * 0.2...bounds.height * 0.45)
        )
        
        withAnimation(.easeOut(duration: 1.2)) {
            isAnimating = true
            position.x += 180
            position.y += 100
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isAnimating = false
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 4...9)) {
                animate()
            }
        }
    }
}

#Preview {
    OnboardingOpeningView(viewModel: OnboardingViewModel())
}
