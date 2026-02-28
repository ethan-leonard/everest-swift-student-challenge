import SwiftUI

// MARK: - Particle System
struct ParticleSystem: View {
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var scale: CGFloat
        var opacity: Double
        var speed: CGFloat
    }
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(Color(hex: "FFD60A"))
                        .frame(width: 4, height: 4)
                        .scaleEffect(particle.scale)
                        .opacity(particle.opacity)
                        .position(x: particle.x, y: particle.y)
                        .blur(radius: 2) // Soft blur
                }
            }
            .onReceive(timer) { _ in
                // Add new particle
                if Double.random(in: 0...1) > 0.7 {
                    let newParticle = Particle(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: geo.size.height, // Start at bottom
                        scale: CGFloat.random(in: 0.5...1.5),
                        opacity: 1.0,
                        speed: CGFloat.random(in: 2...5)
                    )
                    particles.append(newParticle)
                }
                
                // Update particles
                for i in particles.indices {
                    particles[i].y -= particles[i].speed // Move up
                    particles[i].opacity -= 0.02 // Fade out
                }
                
                // Remove dead particles
                particles.removeAll { $0.opacity <= 0 }
            }
        }
        .mask(
            LinearGradient(colors: [.clear, .white, .white, .clear], startPoint: .bottom, endPoint: .top)
        )
    }
}

// MARK: - Grid Pattern
struct GridPattern: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let spacing: CGFloat = 40
                for i in 0...Int(geometry.size.width / spacing) {
                    let x = CGFloat(i) * spacing
                    for j in 0...Int(geometry.size.height / spacing) {
                        let y = CGFloat(j) * spacing
                        path.addEllipse(in: CGRect(x: x, y: y, width: 2, height: 2))
                    }
                }
            }
            .fill(Color.white)
        }
    }
}

// MARK: - Floating Icon for Animations
struct FloatingIcon: View {
    let icon: String
    let color: Color
    let bgMain: Color
    let size: CGFloat
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: size * 0.5, weight: .bold))
            .foregroundStyle(color)
            .frame(width: size, height: size)
            .background(
                Group {
                    if bgMain == .clear {
                        Circle().fill(.ultraThinMaterial) // Glass for standard icons
                    } else {
                        Circle().fill(bgMain) // Solid for Fire
                    }
                }
            )
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .overlay(
                Circle().stroke(Color.white.opacity(0.5), lineWidth: 1)
            )
    }
}

// MARK: - Glass Stat Card for Statistics
struct GlassStatCard<Content: View>: View {
    let title: String
    @ViewBuilder let icon: Content
    
    var body: some View {
        VStack(spacing: 12) {
            icon
            
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .opacity(0.4) // Increased 'glassiness'
        )
        .background(
             RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.1)) // Subtle Tint
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.4), lineWidth: 1.5) // Crisper Border
        )
    }
}
