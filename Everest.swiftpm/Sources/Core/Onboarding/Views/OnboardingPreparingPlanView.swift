import SwiftUI

struct OnboardingPreparingPlanView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    // Animation States
    @State private var progress: CGFloat = 0.0
    @State private var checklistItems: [ChecklistItem] = [
        ChecklistItem(text: "Analyzing interests", state: .waiting),
        ChecklistItem(text: "Selecting micro-habits", state: .waiting),
        ChecklistItem(text: "Calculating milestones...", state: .waiting)
    ]
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                OnboardingHeader(showBackButton: false)
                
                // MARK: - Title Section
                VStack(spacing: 8) {
                    Text("MAPPING YOUR JOURNEY")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color.appBrand)
                        .tracking(1)
                        .padding(.top, 20)
                    
                    OnboardingTitle(
                        text: "Preparing your\nsummit plan, \(viewModel.firstName)",
                        alignment: .center
                    )
                    
                    OnboardingSubtitle(
                        text: "Charting a personalized route\nto your goals.",
                        alignment: .center
                    )
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                // MARK: - Graph Animation
                ZStack {
                    // Gray dashed outline (Full Path)
                    MountainPathShape()
                        .stroke(
                            Color.black.opacity(0.1),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [6, 6])
                        )
                        .frame(width: 240, height: 120) // Smaller graph
                    
                    // Green solid filling path
                    MountainPathShape()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color.appBrand,
                            style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                        )
                        .shadow(color: Color.appBrand.opacity(0.3), radius: 8, y: 4) // Glow effect
                        .frame(width: 240, height: 120)
                    
                    // Hiker Icon using AnimatableModifier to follow path exactly
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .shadow(color: .black.opacity(0.12), radius: 6, y: 3)
                        
                        Image(systemName: "figure.hiking")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.appBrand)
                    }
                    .modifier(HikerPathModifier(progress: progress, bounds: CGRect(x: 0, y: 0, width: 240, height: 120)))
                    .frame(width: 240, height: 120)
                }
                .padding(.vertical, 40)
                
                Spacer()
                
                // MARK: - Checklist
                VStack(spacing: 12) {
                    ForEach(0..<checklistItems.count, id: \.self) { index in
                        if currentStep >= index {
                            ChecklistRow(item: checklistItems[index])
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity).combined(with: .scale(scale: 0.9)),
                                    removal: .opacity
                                ))
                        }
                    }
                }
                .frame(height: 220, alignment: .top)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Footer
                Text("ALMOST AT THE BASE CAMP")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.appTextSecondary.opacity(0.6))
                    .tracking(2)
                    .padding(.bottom, 50)
            }
        }
        .onAppear {
            startAnimationSequence()
        }
        .navigationBarHidden(true)
    }
    
    @State private var currentStep = -1 // Start with nothing visible
    
    private func startAnimationSequence() {
        // Step 1: Start (T=0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                currentStep = 0
            }
            withAnimation(.easeInOut(duration: 0.5)) {
                checklistItems[0].state = .loading
            }
        }
        
        // Graph Move 1 (Duration 2.0, Ends T=2.5)
        // Haptic loop - using Task for concurrency safety
        Task { @MainActor in
            for _ in 0..<20 {
                Haptics.shared.play(.light)
                try? await Task.sleep(nanoseconds: 100_000_000)
            }
        }
        
        withAnimation(.easeInOut(duration: 2.0).delay(0.5)) {
            progress = 0.35
        }
        
        // Step 2: Milestone 1 (T=2.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            // Complete Item 1
            withAnimation { checklistItems[0].state = .completed }
            Haptics.shared.play(.light)
            
            // Show Item 2
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                currentStep = 1
            }
            // Load Item 2
            withAnimation(.easeInOut(duration: 0.5).delay(0.4)) {
                checklistItems[1].state = .loading
            }
            
            // Graph Move 2 (Duration 2.0, Ends T=4.5)
            // Haptic loop - using Task for concurrency safety
            Task { @MainActor in
                for _ in 0..<20 {
                    Haptics.shared.play(.light)
                    try? await Task.sleep(nanoseconds: 100_000_000)
                }
            }
            
            withAnimation(.easeInOut(duration: 2.0)) {
                progress = 0.7
            }
        }
        
        // Step 3: Milestone 2 (T=4.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            // Complete Item 2
            withAnimation { checklistItems[1].state = .completed }
            Haptics.shared.play(.success) // Stronger completion
            
            // Show Item 3
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                currentStep = 2
            }
            // Load Item 3
            withAnimation(.easeInOut(duration: 0.5).delay(0.4)) {
                checklistItems[2].state = .loading
            }
            
            // Graph Move 3 (Duration 2.0, Ends T=6.5)
            // Haptic loop - using Task for concurrency safety
            Task { @MainActor in
                for _ in 0..<20 {
                    Haptics.shared.play(.light)
                    try? await Task.sleep(nanoseconds: 100_000_000)
                }
            }
            
            withAnimation(.easeInOut(duration: 2.0)) {
                progress = 1.0
            }
        }
        
        // Step 4: Finish (T=6.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
            // Complete Item 3
            withAnimation { checklistItems[2].state = .completed }
            Haptics.shared.play(.success)
            
            // Navigate away
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                Haptics.shared.play(.heavy)
                viewModel.nextStep()
            }
        }
    }
}

// MARK: - Components

struct ChecklistItem {
    let text: String
    var state: LoadingState
    
    enum LoadingState {
        case waiting
        case loading
        case completed
    }
}

struct ChecklistRow: View {
    let item: ChecklistItem
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(item.state == .completed ? Color.appBrand : Color.clear)
                    .frame(width: 32, height: 32)
                
                if item.state == .completed {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                } else if item.state == .loading {
                    ProgressView()
                        .tint(Color.appBrand)
                } else {
                    Circle()
                        .stroke(Color.appTextSecondary.opacity(0.3), lineWidth: 2)
                        .frame(width: 12, height: 12) // Small dot for waiting
                }
            }
            .frame(width: 32, height: 32)
            
            Text(item.text)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.appTextPrimary)
            
            Spacer()
        }
        .padding(16)
        .background(Color.appCardBackground) // Consistent card bg
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

// MARK: - Shape Logic
struct MountainPathShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start bottom left
        path.move(to: CGPoint(x: 0, y: rect.height))
        
        // Peak 1
        path.addLine(to: CGPoint(x: rect.width * 0.3, y: rect.height * 0.6))
        
        // Dip
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.7))
        
        // Peak 2 (Summit)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        
        return path
    }
    
    // Helper to get point at percentage (based on actual path length)
    func point(at percentage: CGFloat, in rect: CGRect) -> CGPoint {
        let p1 = CGPoint(x: 0, y: rect.height)
        let p2 = CGPoint(x: rect.width * 0.3, y: rect.height * 0.6)
        let p3 = CGPoint(x: rect.width * 0.5, y: rect.height * 0.7)
        let p4 = CGPoint(x: rect.width, y: 0)
        
        // Calculate actual segment lengths
        let seg1Length = distance(p1, p2)
        let seg2Length = distance(p2, p3)
        let seg3Length = distance(p3, p4)
        let totalLength = seg1Length + seg2Length + seg3Length
        
        // Convert to percentage breakpoints
        let seg1Pct = seg1Length / totalLength
        let seg2Pct = seg2Length / totalLength
        
        if percentage <= seg1Pct {
            let progress = percentage / seg1Pct
            return lerp(start: p1, end: p2, t: progress)
        } else if percentage <= seg1Pct + seg2Pct {
            let progress = (percentage - seg1Pct) / seg2Pct
            return lerp(start: p2, end: p3, t: progress)
        } else {
            let progress = (percentage - seg1Pct - seg2Pct) / (1 - seg1Pct - seg2Pct)
            return lerp(start: p3, end: p4, t: progress)
        }
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        return sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2))
    }
    
    func lerp(start: CGPoint, end: CGPoint, t: CGFloat) -> CGPoint {
        return CGPoint(
            x: start.x + (end.x - start.x) * t,
            y: start.y + (end.y - start.y) * t
        )
    }
}

// MARK: - Animation Modifiers

@MainActor
struct HikerPathModifier: @preconcurrency AnimatableModifier {
    var progress: CGFloat
    let bounds: CGRect
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func body(content: Content) -> some View {
        let point = MountainPathShape().point(at: progress, in: bounds)
        content
            .position(x: point.x, y: point.y)
    }
}

#Preview {
    OnboardingPreparingPlanView(viewModel: OnboardingViewModel())
}
