import SwiftUI

struct JourneyEmptyView: View {
    @State private var animate = false
    @State private var motionManager = MotionManager()
    
    var body: some View {
        ZStack {
            // 1. Ambient Background
            Color.white.ignoresSafeArea()
            
            // Subtle animated blobs
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Color.appBrand.opacity(0.1))
                        .frame(width: 250, height: 250) // Smaller blob
                        .blur(radius: 60)
                        .offset(x: animate ? -50 : 50, y: -100)
                        .offset(x: motionManager.roll * 20, y: motionManager.pitch * 20) // Parallax Depth 1
                    
                    Circle()
                        .fill(Color.blue.opacity(0.05))
                        .frame(width: 250, height: 250)
                        .blur(radius: 50)
                        .offset(x: animate ? 100 : -100, y: 100)
                        .offset(x: motionManager.roll * -30, y: motionManager.pitch * -30) // Parallax Depth 2
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                // 2. Hero Illustration
                ZStack {
                    // Background Ring
                    Circle()
                        .stroke(Color.appBrand.opacity(0.1), lineWidth: 1)
                        .frame(width: 280, height: 280)
                        .offset(x: motionManager.roll * 5, y: motionManager.pitch * 5)
                    
                    Circle()
                        .stroke(Color.appBrand.opacity(0.05), lineWidth: 20)
                        .frame(width: 280, height: 280)
                        .offset(x: motionManager.roll * 8, y: motionManager.pitch * 8)
                    
                    // Layered Mountains
                    ZStack(alignment: .bottom) {
                        // Back Mountain
                        Triangle()
                            .fill(Color.appBrand.opacity(0.2))
                            .frame(width: 160, height: 120)
                            .offset(x: -40, y: 10)
                            .offset(x: motionManager.roll * 10, y: motionManager.pitch * 10)
                        
                        // Middle Mountain
                        Triangle()
                            .fill(Color.appBrand.opacity(0.4))
                            .frame(width: 140, height: 100)
                            .offset(x: 40, y: 20)
                            .offset(x: motionManager.roll * 20, y: motionManager.pitch * 20)
                        
                        // Front Mountain
                        Triangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.appBrand, Color.appBrand.opacity(0.8)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 180, height: 140)
                            .overlay(
                                // Snow Cap
                                Path { path in
                                    path.move(to: CGPoint(x: 90, y: 0))
                                    path.addLine(to: CGPoint(x: 120, y: 40))
                                    path.addLine(to: CGPoint(x: 105, y: 30))
                                    path.addLine(to: CGPoint(x: 90, y: 50))
                                    path.addLine(to: CGPoint(x: 75, y: 30))
                                    path.addLine(to: CGPoint(x: 60, y: 40))
                                    path.closeSubpath()
                                }
                                .fill(Color.white.opacity(0.9))
                            )
                            .shadow(color: Color.appBrand.opacity(0.3), radius: 20, y: 10)
                            .offset(x: motionManager.roll * 40, y: motionManager.pitch * 40) // Most movement
                        
                        // Flag
                        Image(systemName: "flag.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.orange) // Use orange for contrast
                            .foregroundStyle(.white)
                            .offset(x: 0, y: -140)
                            .rotationEffect(.degrees(10))
                            .offset(x: motionManager.roll * 40, y: motionManager.pitch * 40) // Sync with front mountain
                    }
                    .offset(y: 20)
                }
                .scaleEffect(animate ? 0.7 : 0.65) // Significantly smaller mountain
                .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: animate)
                .padding(.bottom, 20)
                
                // Helper Text
                Text("Select a course to start your journey")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .offset(x: motionManager.roll * 5, y: motionManager.pitch * 5)
                
                // 4. Call to Action
                VStack(spacing: 24) {
                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            AppState.shared.selectedTab = .courses
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text("Explore Courses")
                                .font(.system(size: 16, weight: .bold))
                            
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .frame(height: 50)
                        .background(Color.appBrand)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .shadow(color: Color.appBrand.opacity(0.4), radius: 15, x: 0, y: 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .offset(x: motionManager.roll * 10, y: motionManager.pitch * 10)
                    }
                    .accessibilityLabel("Explore Courses")
                    .accessibilityHint("Navigate to the courses tab")
                    .padding(.top, 40)
                }
                Spacer()
            }
        }
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            motionManager.start()
            withAnimation(.easeOut(duration: 1.0)) {
                animate = true
            }
        }
        .onDisappear {
            motionManager.stop()
        }
    }
}

// Custom Triangle Shape
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    JourneyEmptyView()
}
