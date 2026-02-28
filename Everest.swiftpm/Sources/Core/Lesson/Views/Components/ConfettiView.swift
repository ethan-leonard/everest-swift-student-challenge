import SwiftUI

struct ConfettiView: View {
    @State private var particles: [Particle] = []
    @State private var lastUpdate = Date()
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for particle in particles {
                    let rect = CGRect(
                        x: particle.x,
                        y: particle.y,
                        width: particle.size,
                        height: particle.size
                    )
                    context.opacity = particle.opacity
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(particle.color)
                    )
                }
            }
            .onChange(of: timeline.date) { oldValue, newDate in
                let delta = newDate.timeIntervalSince(lastUpdate)
                lastUpdate = newDate
                updateParticles(delta: delta)
            }
        }
        .onAppear {
            createParticles()
            lastUpdate = Date()
        }
    }
    
    private func createParticles() {
        // Create 60 particles for a nice burst
        // "Everest" Palette: Brand Green, Slate, Gold, muted accents
        let palette: [Color] = [
            .appBrand,
            .appBrand.opacity(0.8),
            .appTextPrimary,
            .yellow, // Gold-ish
            .cyan.opacity(0.8) // Fresh accent
        ]
        
        for _ in 0..<60 {
            let angle = Double.random(in: 0...(2 * .pi))
            let speed = Double.random(in: 200...800)
            
            let particle = Particle(
                x: UIScreen.main.bounds.midX,
                y: UIScreen.main.bounds.midY,
                vx: cos(angle) * speed,
                vy: sin(angle) * speed - 500, // Initial upward burst
                color: palette.randomElement() ?? .appBrand,
                size: Double.random(in: 6...12),
                opacity: 1.0
            )
            particles.append(particle)
        }
    }
    
    private func updateParticles(delta: TimeInterval) {
        for i in particles.indices {
            // Apply Gravity
            particles[i].vy += 1500 * delta
            
            // Position
            particles[i].x += particles[i].vx * delta
            particles[i].y += particles[i].vy * delta
            
            // Fade out
            particles[i].opacity -= 0.8 * delta
            
            // Shrink
            particles[i].size *= 0.98
        }
        
        // Remove invisible particles to keep performance high
        particles.removeAll { $0.opacity <= 0 }
    }
    
    struct Particle {
        var x: Double
        var y: Double
        var vx: Double
        var vy: Double
        var color: Color
        var size: Double
        var opacity: Double
    }
}
