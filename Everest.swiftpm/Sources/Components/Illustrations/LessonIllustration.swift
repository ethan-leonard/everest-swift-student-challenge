import SwiftUI

struct LessonIllustration: View {
    let imageKey: String?
    var pageIndex: Int = 0
    @State private var animate = false
    
    // Extended illustration types for variety
    private static let allTypes: [IllustrationType] = [
        .insight, .brain, .focus, .growth, .money, .calm, .energy, .time,
        .social, .heart, .book, .mountain, .star, .wave, .habit, .balance,
        .path, .shield, .plant, .puzzle, .abstract,
        // New types
        .rocket, .compass, .calendar, .checklist, .laptop, .coffee,
        .lotus, .breath, .sunset, .moon, .clouds, .rainbow,
        .graduation, .trophy, .medal, .crown, .podium,
        .phone, .battery, .wifi, .cloud_tech, .notification,
        .dumbbell, .running, .water, .apple, .sleep,
        .wallet, .savings, .stocks, .piggy, .vault,
        .chat, .handshake, .team, .thumbs, .celebrate,
        .tree, .leaf, .flower, .butterfly, .earth,
        .rocket_launch, .level_up, .unlock, .streak, .gem,
        .spiral, .hexagon, .diamond_alt, .ring, .mandala
    ]
    
    private var illustrationType: IllustrationType {
        guard let key = imageKey?.lowercased() else {
            // For nil keys, use page index to vary the abstract illustrations
            let abstractTypes: [IllustrationType] = [.abstract, .spiral, .hexagon, .diamond_alt, .ring, .mandala, .clouds, .wave]
            return abstractTypes[pageIndex % abstractTypes.count]
        }
        
        // Primary matching logic
        let matchedType = matchKeyToType(key)
        
        // If matched, use page index to select a variant from similar types
        return selectVariant(for: matchedType, pageIndex: pageIndex)
    }
    
    private func matchKeyToType(_ key: String) -> IllustrationType {
        // Insight/Ideas
        if key.contains("insight") || key.contains("idea") || key.contains("lightbulb") || key.contains("eureka") {
            return .insight
        }
        // Brain/Thinking
        else if key.contains("brain") || key.contains("think") || key.contains("mind") || key.contains("cognitive") {
            return .brain
        }
        // Focus/Target
        else if key.contains("focus") || key.contains("target") || key.contains("goal") || key.contains("aim") {
            return .focus
        }
        // Growth/Progress
        else if key.contains("growth") || key.contains("progress") || key.contains("chart") || key.contains("improve") {
            return .growth
        }
        // Money/Finance
        else if key.contains("money") || key.contains("wealth") || key.contains("coin") || key.contains("finance") || key.contains("invest") {
            return .money
        }
        // Calm/Peace
        else if key.contains("calm") || key.contains("peace") || key.contains("zen") || key.contains("meditation") || key.contains("relax") {
            return .calm
        }
        // Energy/Power
        else if key.contains("energy") || key.contains("power") || key.contains("lightning") || key.contains("boost") {
            return .energy
        }
        // Time/Clock
        else if key.contains("time") || key.contains("clock") || key.contains("schedule") || key.contains("hour") {
            return .time
        }
        // Social
        else if key.contains("social") || key.contains("connect") || key.contains("network") || key.contains("people") || key.contains("friend") {
            return .social
        }
        // Heart/Emotion
        else if key.contains("heart") || key.contains("love") || key.contains("emotion") || key.contains("feel") {
            return .heart
        }
        // Learning
        else if key.contains("book") || key.contains("read") || key.contains("learn") || key.contains("study") {
            return .book
        }
        // Achievement
        else if key.contains("mountain") || key.contains("peak") || key.contains("climb") || key.contains("summit") {
            return .mountain
        }
        // Success
        else if key.contains("star") || key.contains("success") || key.contains("achieve") || key.contains("win") {
            return .star
        }
        // Flow
        else if key.contains("wave") || key.contains("flow") || key.contains("rhythm") || key.contains("motion") {
            return .wave
        }
        // Habits
        else if key.contains("habit") || key.contains("routine") || key.contains("loop") || key.contains("repeat") {
            return .habit
        }
        // Balance
        else if key.contains("balance") || key.contains("scale") || key.contains("harmony") || key.contains("equilibrium") {
            return .balance
        }
        // Journey
        else if key.contains("path") || key.contains("journey") || key.contains("road") || key.contains("way") {
            return .path
        }
        // Protection
        else if key.contains("shield") || key.contains("protect") || key.contains("safe") || key.contains("secure") {
            return .shield
        }
        // Growth organic
        else if key.contains("plant") || key.contains("seed") || key.contains("grow") || key.contains("nature") {
            return .plant
        }
        // Problem solving
        else if key.contains("puzzle") || key.contains("solve") || key.contains("piece") || key.contains("solution") {
            return .puzzle
        }
        // Launch/Start
        else if key.contains("rocket") || key.contains("launch") || key.contains("start") || key.contains("begin") {
            return .rocket
        }
        // Direction
        else if key.contains("compass") || key.contains("direction") || key.contains("navigate") {
            return .compass
        }
        // Planning
        else if key.contains("calendar") || key.contains("plan") || key.contains("date") {
            return .calendar
        }
        // Tasks
        else if key.contains("check") || key.contains("task") || key.contains("todo") || key.contains("list") {
            return .checklist
        }
        // Tech/Digital
        else if key.contains("laptop") || key.contains("computer") || key.contains("digital") || key.contains("tech") || key.contains("screen") {
            return .laptop
        }
        // Morning/Routine
        else if key.contains("coffee") || key.contains("morning") || key.contains("wake") {
            return .coffee
        }
        // Meditation
        else if key.contains("lotus") || key.contains("yoga") || key.contains("meditat") {
            return .lotus
        }
        // Breathing
        else if key.contains("breath") || key.contains("air") || key.contains("inhale") {
            return .breath
        }
        // Evening
        else if key.contains("sunset") || key.contains("evening") || key.contains("dusk") {
            return .sunset
        }
        // Night
        else if key.contains("moon") || key.contains("night") || key.contains("sleep") {
            return .moon
        }
        // Weather/Mood
        else if key.contains("cloud") || key.contains("sky") || key.contains("weather") {
            return .clouds
        }
        // Positivity
        else if key.contains("rainbow") || key.contains("hope") || key.contains("optimis") {
            return .rainbow
        }
        // Education complete
        else if key.contains("graduat") || key.contains("diploma") || key.contains("degree") {
            return .graduation
        }
        // Awards
        else if key.contains("trophy") || key.contains("award") || key.contains("prize") {
            return .trophy
        }
        // Recognition
        else if key.contains("medal") || key.contains("honor") || key.contains("recogn") {
            return .medal
        }
        // Leadership
        else if key.contains("crown") || key.contains("king") || key.contains("lead") {
            return .crown
        }
        // Speaking
        else if key.contains("podium") || key.contains("speak") || key.contains("present") {
            return .podium
        }
        // Mobile
        else if key.contains("phone") || key.contains("mobile") || key.contains("app") {
            return .phone
        }
        // Energy levels
        else if key.contains("battery") || key.contains("charge") || key.contains("recharge") {
            return .battery
        }
        // Connection
        else if key.contains("wifi") || key.contains("signal") || key.contains("connect") {
            return .wifi
        }
        // Cloud tech
        else if key.contains("upload") || key.contains("download") || key.contains("sync") {
            return .cloud_tech
        }
        // Alerts
        else if key.contains("notif") || key.contains("alert") || key.contains("remind") {
            return .notification
        }
        // Fitness
        else if key.contains("dumbbell") || key.contains("weight") || key.contains("gym") || key.contains("workout") {
            return .dumbbell
        }
        // Cardio
        else if key.contains("run") || key.contains("jog") || key.contains("sprint") || key.contains("cardio") {
            return .running
        }
        // Hydration
        else if key.contains("water") || key.contains("drink") || key.contains("hydrat") {
            return .water
        }
        // Nutrition
        else if key.contains("apple") || key.contains("fruit") || key.contains("health") || key.contains("nutrit") {
            return .apple
        }
        // Rest
        else if key.contains("rest") || key.contains("recover") || key.contains("nap") {
            return .sleep
        }
        // Personal finance
        else if key.contains("wallet") || key.contains("spend") || key.contains("budget") {
            return .wallet
        }
        // Saving
        else if key.contains("save") || key.contains("saving") || key.contains("reserve") {
            return .savings
        }
        // Investing
        else if key.contains("stock") || key.contains("market") || key.contains("trade") {
            return .stocks
        }
        // Piggy bank
        else if key.contains("piggy") || key.contains("bank") || key.contains("deposit") {
            return .piggy
        }
        // Security
        else if key.contains("vault") || key.contains("lock") || key.contains("secur") {
            return .vault
        }
        // Communication
        else if key.contains("chat") || key.contains("message") || key.contains("talk") || key.contains("convers") {
            return .chat
        }
        // Agreement
        else if key.contains("handshake") || key.contains("deal") || key.contains("agree") {
            return .handshake
        }
        // Teamwork
        else if key.contains("team") || key.contains("group") || key.contains("collabor") {
            return .team
        }
        // Approval
        else if key.contains("thumb") || key.contains("like") || key.contains("approv") {
            return .thumbs
        }
        // Celebration
        else if key.contains("celebrat") || key.contains("party") || key.contains("cheer") {
            return .celebrate
        }
        // Trees
        else if key.contains("tree") || key.contains("forest") || key.contains("wood") {
            return .tree
        }
        // Nature
        else if key.contains("leaf") || key.contains("green") || key.contains("eco") {
            return .leaf
        }
        // Bloom
        else if key.contains("flower") || key.contains("bloom") || key.contains("blossom") {
            return .flower
        }
        // Transformation
        else if key.contains("butterfly") || key.contains("transform") || key.contains("metamorph") {
            return .butterfly
        }
        // Global
        else if key.contains("earth") || key.contains("global") || key.contains("world") {
            return .earth
        }
        // Takeoff
        else if key.contains("takeoff") || key.contains("liftoff") || key.contains("soar") {
            return .rocket_launch
        }
        // Leveling
        else if key.contains("level") || key.contains("upgrade") || key.contains("advance") {
            return .level_up
        }
        // Access
        else if key.contains("unlock") || key.contains("access") || key.contains("open") {
            return .unlock
        }
        // Streaks
        else if key.contains("streak") || key.contains("consecutive") || key.contains("chain") {
            return .streak
        }
        // Gems
        else if key.contains("gem") || key.contains("jewel") || key.contains("crystal") || key.contains("diamond") {
            return .gem
        }
        
        return .abstract
    }
    
    // Select variant based on page index to create variety
    private func selectVariant(for baseType: IllustrationType, pageIndex: Int) -> IllustrationType {
        let variants: [IllustrationType: [IllustrationType]] = [
            .insight: [.insight, .brain, .focus, .star],
            .brain: [.brain, .insight, .puzzle, .balance],
            .focus: [.focus, .energy, .rocket, .compass],
            .growth: [.growth, .plant, .mountain, .level_up],
            .money: [.money, .wallet, .savings, .piggy, .vault],
            .calm: [.calm, .lotus, .breath, .moon, .clouds],
            .energy: [.energy, .rocket_launch, .battery, .running],
            .time: [.time, .calendar, .checklist, .streak],
            .social: [.social, .team, .handshake, .chat],
            .heart: [.heart, .flower, .rainbow, .celebrate],
            .book: [.book, .graduation, .trophy, .medal],
            .mountain: [.mountain, .path, .unlock, .crown],
            .star: [.star, .gem, .trophy, .crown],
            .wave: [.wave, .clouds, .sunset, .breath],
            .habit: [.habit, .checklist, .streak, .coffee],
            .balance: [.balance, .lotus, .calm, .leaf],
            .path: [.path, .compass, .rocket, .mountain],
            .shield: [.shield, .vault, .unlock, .heart],
            .plant: [.plant, .tree, .leaf, .flower],
            .puzzle: [.puzzle, .brain, .unlock, .gem],
            .abstract: [.abstract, .spiral, .hexagon, .mandala, .diamond_alt]
        ]
        
        guard let typeVariants = variants[baseType], !typeVariants.isEmpty else {
            return baseType
        }
        
        return typeVariants[pageIndex % typeVariants.count]
    }
    
    var body: some View {
        ZStack {
            illustrationView
        }
        .frame(width: 200, height: 200)
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
                animate = true
            }
        }
    }
    
    @ViewBuilder
    private var illustrationView: some View {
        switch illustrationType {
        case .insight: InsightIllustration(animate: animate)
        case .brain: BrainIllustration(animate: animate)
        case .focus: FocusIllustration(animate: animate)
        case .growth: GrowthIllustration(animate: animate)
        case .money: MoneyIllustration(animate: animate)
        case .calm: CalmIllustration(animate: animate)
        case .energy: EnergyIllustration(animate: animate)
        case .time: TimeIllustration(animate: animate)
        case .social: SocialIllustration(animate: animate)
        case .heart: HeartIllustration(animate: animate)
        case .book: BookIllustration(animate: animate)
        case .mountain: MountainIllustration(animate: animate)
        case .star: StarIllustration(animate: animate)
        case .wave: WaveIllustration(animate: animate)
        case .habit: HabitIllustration(animate: animate)
        case .balance: BalanceIllustration(animate: animate)
        case .path: PathIllustration(animate: animate)
        case .shield: ShieldIllustration(animate: animate)
        case .plant: PlantIllustration(animate: animate)
        case .puzzle: PuzzleIllustration(animate: animate)
        case .abstract: AbstractIllustration(animate: animate)
        // New illustrations
        case .rocket: RocketIllustration(animate: animate)
        case .compass: CompassIllustration(animate: animate)
        case .calendar: CalendarIllustration(animate: animate)
        case .checklist: ChecklistIllustration(animate: animate)
        case .laptop: LaptopIllustration(animate: animate)
        case .coffee: CoffeeIllustration(animate: animate)
        case .lotus: LotusIllustration(animate: animate)
        case .breath: BreathIllustration(animate: animate)
        case .sunset: SunsetIllustration(animate: animate)
        case .moon: MoonIllustration(animate: animate)
        case .clouds: CloudsIllustration(animate: animate)
        case .rainbow: RainbowIllustration(animate: animate)
        case .graduation: GraduationIllustration(animate: animate)
        case .trophy: TrophyIllustration(animate: animate)
        case .medal: MedalIllustration(animate: animate)
        case .crown: CrownIllustration(animate: animate)
        case .podium: PodiumIllustration(animate: animate)
        case .phone: PhoneIllustration(animate: animate)
        case .battery: BatteryIllustration(animate: animate)
        case .wifi: WifiIllustration(animate: animate)
        case .cloud_tech: CloudTechIllustration(animate: animate)
        case .notification: NotificationIllustration(animate: animate)
        case .dumbbell: DumbbellIllustration(animate: animate)
        case .running: RunningIllustration(animate: animate)
        case .water: WaterIllustration(animate: animate)
        case .apple: AppleIllustration(animate: animate)
        case .sleep: SleepIllustration(animate: animate)
        case .wallet: WalletIllustration(animate: animate)
        case .savings: SavingsIllustration(animate: animate)
        case .stocks: StocksIllustration(animate: animate)
        case .piggy: PiggyIllustration(animate: animate)
        case .vault: VaultIllustration(animate: animate)
        case .chat: ChatIllustration(animate: animate)
        case .handshake: HandshakeIllustration(animate: animate)
        case .team: TeamIllustration(animate: animate)
        case .thumbs: ThumbsIllustration(animate: animate)
        case .celebrate: CelebrateIllustration(animate: animate)
        case .tree: TreeIllustration(animate: animate)
        case .leaf: LeafIllustration(animate: animate)
        case .flower: FlowerIllustration(animate: animate)
        case .butterfly: ButterflyIllustration(animate: animate)
        case .earth: EarthIllustration(animate: animate)
        case .rocket_launch: RocketLaunchIllustration(animate: animate)
        case .level_up: LevelUpIllustration(animate: animate)
        case .unlock: UnlockIllustration(animate: animate)
        case .streak: StreakIllustration(animate: animate)
        case .gem: GemIllustration(animate: animate)
        case .spiral: SpiralIllustration(animate: animate)
        case .hexagon: HexagonIllustration(animate: animate)
        case .diamond_alt: DiamondAltIllustration(animate: animate)
        case .ring: RingIllustration(animate: animate)
        case .mandala: MandalaIllustration(animate: animate)
        }
    }
}

private enum IllustrationType {
    // Original types
    case insight, brain, focus, growth, money, calm, energy, time
    case social, heart, book, mountain, star, wave, habit, balance
    case path, shield, plant, puzzle, abstract
    // New types
    case rocket, compass, calendar, checklist, laptop, coffee
    case lotus, breath, sunset, moon, clouds, rainbow
    case graduation, trophy, medal, crown, podium
    case phone, battery, wifi, cloud_tech, notification
    case dumbbell, running, water, apple, sleep
    case wallet, savings, stocks, piggy, vault
    case chat, handshake, team, thumbs, celebrate
    case tree, leaf, flower, butterfly, earth
    case rocket_launch, level_up, unlock, streak, gem
    case spiral, hexagon, diamond_alt, ring, mandala
}

// MARK: - Insight (Lightbulb)
private struct InsightIllustration: View {
    let animate: Bool
    @State private var glow = false
    @State private var radiate = false
    
    var body: some View {
        ZStack {
            // Ambient Glow
            Circle()
                .fill(Color(hex: "FEF3C7").opacity(glow ? 0.6 : 0.2))
                .frame(width: 180, height: 180)
                .scaleEffect(glow ? 1.05 : 0.95)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: glow)
            
            // Radiating Light Rays
            ForEach(0..<8) { i in
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(LinearGradient(colors: [Color(hex: "F59E0B"), Color(hex: "FBBF24")], startPoint: .bottom, endPoint: .top))
                    .frame(width: 4, height: animate ? 25 : 0)
                    .offset(y: radiate ? -75 : -65)
                    .opacity(radiate ? 1.0 : 0.4)
                    .rotationEffect(.degrees(Double(i) * 45))
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).repeatForever(autoreverses: true).delay(Double(i) * 0.1), value: radiate)
            }
            
            // Lightbulb Core
            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(LinearGradient(colors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")], startPoint: .top, endPoint: .bottom))
                    .frame(width: 70, height: 90)
                    .shadow(color: Color(hex: "FCD34D").opacity(0.8), radius: glow ? 20 : 5)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glow)
                
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(hex: "92400E").opacity(0.4))
                    .frame(width: 35, height: 15)
                    .offset(y: 45)
            }
            .scaleEffect(animate ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.65), value: animate)
        }
        .onAppear {
            if animate {
                glow = true
                radiate = true
            }
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                glow = true
                radiate = true
            }
        }
    }
}

// MARK: - Brain
private struct BrainIllustration: View {
    let animate: Bool
    @State private var pulse = false
    @State private var float = false
    @State private var rotate = false
    
    var body: some View {
        ZStack {
            // Pulsing Background Glow
            Circle()
                .fill(Color(hex: "EDE9FE").opacity(pulse ? 0.6 : 0.2))
                .frame(width: 170, height: 170)
                .scaleEffect(pulse ? 1.05 : 0.95)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulse)
            
            // Orbiting Data Nodes
            ZStack {
                ForEach(0..<3) { i in
                    Circle()
                        .fill(Color(hex: "C4B5FD"))
                        .frame(width: 8, height: 8)
                        .offset(x: 60)
                        .rotationEffect(.degrees(rotate ? 360 : 0))
                        .rotationEffect(.degrees(Double(i) * 120))
                        .animation(.linear(duration: 8.0).repeatForever(autoreverses: false).delay(Double(i)), value: rotate)
                }
            }
            .opacity(animate ? 1 : 0)
            
            // Core Brain
            ZStack {
                // Left Lobe
                Ellipse()
                    .fill(LinearGradient(colors: [Color(hex: "A78BFA"), Color(hex: "7C3AED")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 55, height: 70)
                    .offset(x: -20, y: float ? -3 : 3)
                    .rotationEffect(.degrees(float ? -2 : 2))
                
                // Right Lobe
                Ellipse()
                    .fill(LinearGradient(colors: [Color(hex: "C4B5FD"), Color(hex: "8B5CF6")], startPoint: .topTrailing, endPoint: .bottomLeading))
                    .frame(width: 55, height: 70)
                    .offset(x: 20, y: float ? 3 : -3)
                    .rotationEffect(.degrees(float ? 2 : -2))
                
                // Neural Synapses (Sparking)
                ForEach(0..<4) { i in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 6, height: 6)
                        .offset(x: CGFloat.random(in: -25...25), y: CGFloat.random(in: -30...30))
                        .opacity(pulse ? 1 : 0.2)
                        .scaleEffect(pulse ? 1.2 : 0.5)
                        .animation(.easeInOut(duration: Double.random(in: 0.5...1.5)).repeatForever(autoreverses: true), value: pulse)
                }
            }
            .scaleEffect(animate ? 1 : 0.3)
            .animation(.spring(response: 0.6, dampingFraction: 0.6), value: animate)
        }
        .onAppear {
            if animate {
                pulse = true
                float = true
                rotate = true
            }
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                pulse = true
                float = true
                rotate = true
            }
        }
    }
}

// MARK: - Focus (Target)
private struct FocusIllustration: View {
    let animate: Bool
    @State private var wave = false
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "3B82F6"), Color(hex: "1D4ED8")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: wave ? 10 : 6
                    )
                    .frame(width: CGFloat(170 - i * 50), height: CGFloat(170 - i * 50))
                    .scaleEffect(animate ? (wave ? 1.05 : 0.95) : 0)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.2),
                        value: wave
                    )
            }
            
            Circle()
                .fill(LinearGradient(colors: [Color(hex: "EF4444"), Color(hex: "DC2626")], startPoint: .top, endPoint: .bottom))
                .frame(width: pulse ? 36 : 28, height: pulse ? 36 : 28)
                .shadow(color: Color(hex: "EF4444").opacity(0.6), radius: pulse ? 12 : 4)
                .scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulse)
        }
        .onAppear {
            if animate {
                wave = true
                pulse = true
            }
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                wave = true
                pulse = true
            }
        }
    }
}

// MARK: - Growth (Bars)
private struct GrowthIllustration: View {
    let animate: Bool
    @State private var pulse: [Bool] = [false, false, false, false]
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "D1FAE5").opacity(0.4))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
            
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(0..<4) { i in
                    let heights: [CGFloat] = [40, 65, 50, 85]
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(LinearGradient(
                            colors: [Color(hex: "34D399"), Color(hex: "10B981")],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(width: 28, height: animate ? heights[i] : 0)
                        .scaleEffect(y: pulse[i] ? 1.05 : 0.95, anchor: .bottom)
                        .shadow(color: Color(hex: "10B981").opacity(pulse[i] ? 0.6 : 0), radius: pulse[i] ? 8 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15 + Double(i) * 0.1), value: animate)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(Double(i) * 0.2), value: pulse[i])
                }
            }
        }
        .onAppear {
            if animate {
                for i in 0..<4 {
                    pulse[i] = true
                }
            }
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                for i in 0..<4 {
                    pulse[i] = true
                }
            }
        }
    }
}

// MARK: - Money
private struct MoneyIllustration: View {
    let animate: Bool
    @State private var float = false
    @State private var spin = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "FEF3C7").opacity(0.3))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
            
            ForEach(0..<3) { i in
                Circle()
                    .fill(LinearGradient(
                        colors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 55, height: 55)
                    .overlay(
                        Text("$")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Color(hex: "92400E"))
                    )
                    .offset(
                        x: CGFloat(i - 1) * 25,
                        y: CGFloat(i - 1) * -15 + (float ? -5 : 5)
                    )
                    .scaleEffect(animate ? 1 : 0)
                    .rotation3DEffect(
                        .degrees(spin ? 20 : -20),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.4),
                        value: float
                    )
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.2),
                        value: spin
                    )
            }
        }
        .onAppear {
            if animate {
                float = true
                spin = true
            }
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                float = true
                spin = true
            }
        }
    }
}

// MARK: - Calm (Ripples)
private struct CalmIllustration: View {
    let animate: Bool
    @State private var ripple = false
    
    var body: some View {
        ZStack {
            ForEach(0..<4) { i in
                Circle()
                    .stroke(
                        Color(hex: "06B6D4").opacity(Double(4 - i) * 0.2),
                        lineWidth: 3
                    )
                    .frame(width: CGFloat(50 + i * 40), height: CGFloat(50 + i * 40))
                    .scaleEffect(animate ? (ripple ? 1.1 : 0.9) : 0)
                    .opacity(ripple ? 0.7 : 1.0)
                    .animation(
                        .easeInOut(duration: 3.0)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.5),
                        value: ripple
                    )
            }
            
            Circle()
                .fill(LinearGradient(colors: [Color(hex: "22D3EE"), Color(hex: "06B6D4")], startPoint: .top, endPoint: .bottom))
                .frame(width: 35, height: 35)
                .scaleEffect(animate ? (ripple ? 1.05 : 0.95) : 0)
                .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: ripple)
                .animation(.spring(response: 0.5, dampingFraction: 0.5).delay(0.45), value: animate)
        }
        .onAppear {
            if animate { ripple = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { ripple = true }
        }
    }
}

// MARK: - Energy (Lightning)
private struct EnergyIllustration: View {
    let animate: Bool
    @State private var flash = false
    @State private var float = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "FEF3C7").opacity(flash ? 0.6 : 0.2))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: flash)
            
            ZStack {
                LightningShape()
                    .fill(LinearGradient(colors: [Color(hex: "FBBF24"), Color(hex: "F59E0B")], startPoint: .top, endPoint: .bottom))
                    .frame(width: 60, height: 100)
                    .shadow(color: Color(hex: "F59E0B").opacity(flash ? 0.8 : 0.3), radius: flash ? 20 : 10)
            }
            .scaleEffect(animate ? 1 : 0)
            .opacity(animate ? 1 : 0)
            .offset(y: float ? -5 : 5)
            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: float)
            .animation(.spring(response: 0.4, dampingFraction: 0.6).delay(0.2), value: animate)
            
            ForEach(0..<6) { i in
                Circle()
                    .fill(Color(hex: "FCD34D"))
                    .frame(width: 8, height: 8)
                    .offset(
                        x: (animate ? CGFloat.random(in: -60...60) : 0) + (float ? 5 : -5),
                        y: (animate ? CGFloat.random(in: -60...60) : 0) + (float ? -5 : 5)
                    )
                    .opacity(animate ? (flash ? 1 : 0.3) : 0)
                    .scaleEffect(flash ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: Double.random(in: 0.5...1.5))
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.2),
                        value: flash
                    )
            }
        }
        .onAppear {
            if animate {
                flash = true
                float = true
            }
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                flash = true
                float = true
            }
        }
    }
}

private struct LightningShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: w * 0.55, y: 0))
        path.addLine(to: CGPoint(x: w * 0.25, y: h * 0.45))
        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.45))
        path.addLine(to: CGPoint(x: w * 0.35, y: h))
        path.addLine(to: CGPoint(x: w * 0.8, y: h * 0.4))
        path.addLine(to: CGPoint(x: w * 0.55, y: h * 0.4))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Time (Clock)
private struct TimeIllustration: View {
    let animate: Bool
    @State private var tick = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "E0E7FF").opacity(0.4))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
            
            Circle()
                .fill(LinearGradient(colors: [Color(hex: "818CF8"), Color(hex: "6366F1")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 100, height: 100)
                .scaleEffect(animate ? 1 : 0)
                .shadow(color: Color(hex: "6366F1").opacity(0.4), radius: 10)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
            
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(Color.white)
                .frame(width: 4, height: 30)
                .offset(y: -12)
                .rotationEffect(.degrees(animate ? (tick ? 360 : 0) : -90))
                .animation(.linear(duration: 12.0).repeatForever(autoreverses: false), value: tick)
            
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(Color.white.opacity(0.8))
                .frame(width: 3, height: 22)
                .offset(y: -8)
                .rotationEffect(.degrees(animate ? (tick ? 360 * 12 : 90) : 0))
                .animation(.linear(duration: 12.0).repeatForever(autoreverses: false), value: tick)
            
            Circle()
                .fill(Color.white)
                .frame(width: 8, height: 8)
        }
        .onAppear {
            if animate { tick = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { tick = true }
        }
    }
}

// MARK: - Social (Network)
private struct SocialIllustration: View {
    let animate: Bool
    @State private var float = false
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "DBEAFE").opacity(0.4))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
            
            let positions: [(CGFloat, CGFloat)] = [(0, -45), (-40, 15), (40, 15), (0, 50)]
            
            ForEach(0..<3) { i in
                Path { path in
                    path.move(to: CGPoint(x: 100 + positions[0].0, y: 100 + positions[0].1 + (float ? -3 : 3)))
                    path.addLine(to: CGPoint(x: 100 + positions[i + 1].0, y: 100 + positions[i + 1].1 + (float ? 3 : -3)))
                }
                .trim(from: 0, to: animate ? 1 : 0)
                .stroke(Color(hex: "93C5FD"), lineWidth: pulse ? 4 : 2)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(Double(i) * 0.2), value: pulse)
                .animation(.easeOut(duration: 0.4).delay(0.3 + Double(i) * 0.1), value: animate)
            }
            
            ForEach(0..<4) { i in
                Circle()
                    .fill(LinearGradient(colors: [Color(hex: "60A5FA"), Color(hex: "3B82F6")], startPoint: .top, endPoint: .bottom))
                    .frame(width: i == 0 ? 35 : 28, height: i == 0 ? 35 : 28)
                    .offset(x: positions[i].0, y: positions[i].1 + (float ? (i == 0 ? -3 : 3) : (i == 0 ? 3 : -3)))
                    .scaleEffect(animate ? 1 : 0)
                    .shadow(color: Color(hex: "3B82F6").opacity(pulse ? 0.6 : 0.2), radius: pulse ? 8 : 2)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(Double(i) * 0.3), value: float)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1 + Double(i) * 0.08), value: animate)
            }
        }
        .onAppear {
            if animate { 
                float = true
                pulse = true 
            }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { 
                float = true
                pulse = true 
            }
        }
    }
}

// MARK: - Heart
private struct HeartIllustration: View {
    let animate: Bool
    @State private var beat = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "FCE7F3").opacity(beat ? 0.6 : 0.2))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: beat)
            
            HeartShape()
                .fill(LinearGradient(colors: [Color(hex: "F472B6"), Color(hex: "EC4899")], startPoint: .top, endPoint: .bottom))
                .frame(width: 80, height: 75)
                .scaleEffect(animate ? (beat ? 1.08 : 0.95) : 0)
                .shadow(color: Color(hex: "EC4899").opacity(beat ? 0.6 : 0.2), radius: beat ? 15 : 5)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: beat)
                .animation(.spring(response: 0.5, dampingFraction: 0.4).delay(0.2), value: animate)
            
            ForEach(0..<3) { i in
                Circle()
                    .fill(Color(hex: "FBCFE8"))
                    .frame(width: 10, height: 10)
                    .offset(x: CGFloat([-35, 35, 0][i]), y: CGFloat([-30, -30, 40][i]))
                    .scaleEffect(animate ? (beat ? 1.2 : 0.8) : 0)
                    .opacity(beat ? 1 : 0.5)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(Double(i) * 0.2), value: beat)
                    .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.4 + Double(i) * 0.08), value: animate)
            }
        }
        .onAppear {
            if animate { beat = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { beat = true }
        }
    }
}

private struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: w / 2, y: h))
        path.addCurve(
            to: CGPoint(x: 0, y: h * 0.35),
            control1: CGPoint(x: w * 0.1, y: h * 0.7),
            control2: CGPoint(x: 0, y: h * 0.55)
        )
        path.addArc(center: CGPoint(x: w * 0.25, y: h * 0.25), radius: w * 0.25, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        path.addArc(center: CGPoint(x: w * 0.75, y: h * 0.25), radius: w * 0.25, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        path.addCurve(
            to: CGPoint(x: w / 2, y: h),
            control1: CGPoint(x: w, y: h * 0.55),
            control2: CGPoint(x: w * 0.9, y: h * 0.7)
        )
        
        return path
    }
}

// MARK: - Book
private struct BookIllustration: View {
    let animate: Bool
    @State private var ripple = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "FEE2E2").opacity(0.4))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
            
            ForEach(0..<3) { i in
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(LinearGradient(
                        colors: [
                            [Color(hex: "FCA5A5"), Color(hex: "EF4444")],
                            [Color(hex: "FCD34D"), Color(hex: "F59E0B")],
                            [Color(hex: "6EE7B7"), Color(hex: "10B981")]
                        ][i],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: animate ? 70 : 0, height: 18)
                    .offset(x: ripple ? (i % 2 == 0 ? 5 : -5) : 0, y: CGFloat(i - 1) * 22)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.3),
                        value: ripple
                    )
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15 + Double(i) * 0.1), value: animate)
            }
        }
        .onAppear {
            if animate { ripple = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { ripple = true }
        }
    }
}

// MARK: - Mountain
private struct MountainIllustration: View {
    let animate: Bool
    @State private var float = false
    @State private var glow = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "DBEAFE").opacity(0.4))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
            
            MountainShape()
                .fill(LinearGradient(colors: [Color(hex: "6366F1"), Color(hex: "4F46E5")], startPoint: .top, endPoint: .bottom))
                .frame(width: 100, height: 70)
                .offset(y: animate ? (float ? 12 : 8) : 60)
                .opacity(animate ? 1 : 0)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: float)
                .animation(.spring(response: 0.6, dampingFraction: 0.65).delay(0.15), value: animate)
            
            MountainShape()
                .fill(LinearGradient(colors: [Color(hex: "818CF8"), Color(hex: "6366F1")], startPoint: .top, endPoint: .bottom))
                .frame(width: 70, height: 55)
                .offset(x: -30, y: animate ? (float ? 24 : 20) : 60)
                .opacity(animate ? 1 : 0)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true).delay(0.2), value: float)
                .animation(.spring(response: 0.6, dampingFraction: 0.65).delay(0.25), value: animate)
            
            Circle()
                .fill(Color(hex: "FCD34D"))
                .frame(width: 25, height: 25)
                .shadow(color: Color(hex: "F59E0B").opacity(glow ? 0.8 : 0.2), radius: glow ? 15 : 5)
                .offset(x: 40, y: animate ? (float ? -45 : -35) : -40)
                .scaleEffect(animate ? (glow ? 1.1 : 0.9) : 0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glow)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: float)
                .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.45), value: animate)
        }
    }
}

private struct MountainShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width / 2, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        return path
    }
}

// MARK: - Star
private struct StarIllustration: View {
    let animate: Bool
    @State private var twinkle = false
    @State private var spin = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "FEF3C7").opacity(twinkle ? 0.6 : 0.2))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: twinkle)
            
            StarShape()
                .fill(LinearGradient(colors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")], startPoint: .top, endPoint: .bottom))
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(animate ? (spin ? 10 : -10) : -72))
                .scaleEffect(animate ? (twinkle ? 1.05 : 0.95) : 0)
                .shadow(color: Color(hex: "F59E0B").opacity(twinkle ? 0.6 : 0), radius: twinkle ? 15 : 5)
                .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: spin)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: twinkle)
                .animation(.spring(response: 0.6, dampingFraction: 0.5).delay(0.15), value: animate)
            
            ForEach(0..<5) { i in
                Circle()
                    .fill(Color(hex: "FDE68A"))
                    .frame(width: 6, height: 6)
                    .offset(x: CGFloat.random(in: -50...50), y: CGFloat.random(in: -50...50))
                    .scaleEffect(animate ? (twinkle ? 1.2 : 0.5) : 0)
                    .opacity(twinkle ? 1 : 0.2)
                    .animation(
                        .easeInOut(duration: Double.random(in: 0.8...2.0))
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.3),
                        value: twinkle
                    )
                    .animation(.spring(response: 0.4, dampingFraction: 0.4).delay(0.4 + Double(i) * 0.05), value: animate)
            }
        }
        .onAppear {
            if animate {
                twinkle = true
                spin = true
            }
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                twinkle = true
                spin = true
            }
        }
    }
}

private struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        var path = Path()
        
        for i in 0..<10 {
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = Double(i) * .pi / 5 - .pi / 2
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Wave
private struct WaveIllustration: View {
    let animate: Bool
    @State private var flow = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "CFFAFE").opacity(0.4))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
            
            ForEach(0..<3) { i in
                WaveShape()
                    .stroke(
                        LinearGradient(colors: [Color(hex: "22D3EE"), Color(hex: "06B6D4")], startPoint: .leading, endPoint: .trailing),
                        lineWidth: 6
                    )
                    .frame(width: 140, height: 30) // increased width for flow movement
                    .offset(x: flow ? (i % 2 == 0 ? -15 : 15) : (i % 2 == 0 ? 15 : -15), y: CGFloat(i - 1) * 25)
                    .opacity(animate ? (flow ? Double(3 - i) / 3 : Double(3 - i) / 4) : 0)
                    .scaleEffect(x: animate ? 1 : 0)
                    .animation(
                        .easeInOut(duration: 3.0)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.4),
                        value: flow
                    )
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15 + Double(i) * 0.1), value: animate)
            }
        }
        .onAppear {
            if animate { flow = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { flow = true }
        }
    }
}

private struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addCurve(
            to: CGPoint(x: rect.width, y: rect.midY),
            control1: CGPoint(x: rect.width * 0.25, y: 0),
            control2: CGPoint(x: rect.width * 0.75, y: rect.height)
        )
        return path
    }
}

// MARK: - Habit (Loop)
private struct HabitIllustration: View {
    let animate: Bool
    @State private var spin = false
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "E0E7FF").opacity(pulse ? 0.6 : 0.3))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulse)
            
            Circle()
                .trim(from: 0, to: animate ? 0.75 : 0)
                .stroke(
                    LinearGradient(colors: [Color(hex: "818CF8"), Color(hex: "6366F1")], startPoint: .topLeading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(animate ? (spin ? 270 : -90) : -90))
                .animation(.linear(duration: 3.0).repeatForever(autoreverses: false), value: spin)
                .animation(.easeOut(duration: 0.6).delay(0.2), value: animate)
            
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(hex: "6366F1"))
                .rotationEffect(.degrees(animate ? (spin ? 360 : 0) : 0))
                .scaleEffect(animate ? (pulse ? 1.1 : 0.9) : 0)
                .animation(.linear(duration: 3.0).repeatForever(autoreverses: false), value: spin)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulse)
                .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.5), value: animate)
        }
        .onAppear {
            if animate { 
                spin = true
                pulse = true
            }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { 
                spin = true
                pulse = true
            }
        }
    }
}

// MARK: - Balance
private struct BalanceIllustration: View {
    let animate: Bool
    @State private var tilt = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "D1FAE5").opacity(0.4))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
            
            // Seesaws rotating together
            ZStack {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(Color(hex: "6B7280"))
                    .frame(width: 100, height: 6)
                
                Circle()
                    .fill(LinearGradient(colors: [Color(hex: "34D399"), Color(hex: "10B981")], startPoint: .top, endPoint: .bottom))
                    .frame(width: 35, height: 35)
                    .offset(x: -40, y: -20)
                
                Circle()
                    .fill(LinearGradient(colors: [Color(hex: "60A5FA"), Color(hex: "3B82F6")], startPoint: .top, endPoint: .bottom))
                    .frame(width: 35, height: 35)
                    .offset(x: 40, y: -20)
            }
            .rotationEffect(.degrees(animate ? (tilt ? 12 : -12) : 15))
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: tilt)
            .animation(.spring(response: 0.8, dampingFraction: 0.5).delay(0.15), value: animate)
            
            MountainShape()
                .fill(Color(hex: "9CA3AF"))
                .frame(width: 20, height: 40)
                .offset(y: 20)
                .scaleEffect(y: animate ? 1 : 0, anchor: .bottom)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: animate)
        }
        .onAppear {
            if animate { tilt = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { tilt = true }
        }
    }
}

// MARK: - Path
private struct PathIllustration: View {
    let animate: Bool
    @State private var phase: CGFloat = 0
    @State private var bounce = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "FEE2E2").opacity(0.4))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
            
            PathShape()
                .trim(from: 0, to: animate ? 1 : 0)
                .stroke(
                    LinearGradient(colors: [Color(hex: "F87171"), Color(hex: "EF4444")], startPoint: .leading, endPoint: .trailing),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round, dash: [1, 15], dashPhase: phase)
                )
                .frame(width: 120, height: 80)
                .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: phase)
                .animation(.easeOut(duration: 0.8).delay(0.15), value: animate)
            
            Circle()
                .fill(LinearGradient(colors: [Color(hex: "34D399"), Color(hex: "10B981")], startPoint: .top, endPoint: .bottom))
                .frame(width: 20, height: 20)
                .offset(x: -50, y: 30 + (bounce ? -3 : 3))
                .scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: bounce)
                .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.1), value: animate)
            
            Image(systemName: "flag.fill")
                .font(.system(size: 20))
                .foregroundStyle(Color(hex: "EF4444"))
                .offset(x: 50, y: -30 + (bounce ? 3 : -3))
                .scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: bounce)
                .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.7), value: animate)
        }
        .onAppear {
            if animate {
                phase = -32 // 2 * dash pattern length
                bounce = true
            }
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                phase = -32
                bounce = true
            }
        }
    }
}

private struct PathShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addCurve(
            to: CGPoint(x: rect.width, y: 0),
            control1: CGPoint(x: rect.width * 0.3, y: rect.height * 0.2),
            control2: CGPoint(x: rect.width * 0.7, y: rect.height * 0.8)
        )
        return path
    }
}

// MARK: - Shield
private struct ShieldIllustration: View {
    let animate: Bool
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "DBEAFE").opacity(0.4))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
            
            ShieldShape()
                .fill(LinearGradient(colors: [Color(hex: "60A5FA"), Color(hex: "3B82F6")], startPoint: .top, endPoint: .bottom))
                .frame(width: 70, height: 85)
                .scaleEffect(animate ? (pulse ? 1.05 : 0.95) : 0)
                .shadow(color: Color(hex: "3B82F6").opacity(pulse ? 0.6 : 0.2), radius: pulse ? 12 : 4)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulse)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.15), value: animate)
            
            Image(systemName: "checkmark")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.white)
                .scaleEffect(animate ? (pulse ? 1.1 : 0.9) : 0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(0.5), value: pulse)
                .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.4), value: animate)
        }
        .onAppear {
            if animate { pulse = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { pulse = true }
        }
    }
}

private struct ShieldShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.55))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.height), control: CGPoint(x: rect.width, y: rect.height * 0.85))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.height * 0.55), control: CGPoint(x: 0, y: rect.height * 0.85))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.15))
        path.closeSubpath()
        return path
    }
}

// MARK: - Plant
private struct PlantIllustration: View {
    let animate: Bool
    @State private var sway = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "D1FAE5").opacity(0.4))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
            
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(LinearGradient(colors: [Color(hex: "A78BFA"), Color(hex: "7C3AED")], startPoint: .top, endPoint: .bottom))
                .frame(width: 50, height: 45)
                .offset(y: 35)
                .scaleEffect(animate ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: animate)
            
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(Color(hex: "10B981"))
                .frame(width: 6, height: animate ? 50 : 0)
                .offset(y: 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.25), value: animate)
            
            ForEach(0..<3) { i in
                Ellipse()
                    .fill(LinearGradient(colors: [Color(hex: "34D399"), Color(hex: "10B981")], startPoint: .top, endPoint: .bottom))
                    .frame(width: 25, height: 35)
                    .offset(x: CGFloat([20, -20, 0][i]), y: CGFloat([-35, -25, -55][i]))
                    .rotationEffect(.degrees(Double([25, -25, 0][i]) + (sway ? 5 : -5)))
                    .scaleEffect(animate ? 1 : 0)
                    .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true).delay(Double(i) * 0.4), value: sway)
                    .animation(.spring(response: 0.5, dampingFraction: 0.5).delay(0.4 + Double(i) * 0.1), value: animate)
            }
        }
        .onAppear {
            if animate { sway = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { sway = true }
        }
    }
}

// MARK: - Puzzle
private struct PuzzleIllustration: View {
    let animate: Bool
    @State private var float = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "FEF3C7").opacity(0.4))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
            
            let colors = [Color(hex: "F59E0B"), Color(hex: "EF4444"), Color(hex: "3B82F6"), Color(hex: "10B981")]
            let offsets: [(CGFloat, CGFloat)] = [(-22, -22), (22, -22), (-22, 22), (22, 22)]
            
            ForEach(0..<4) { i in
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(LinearGradient(colors: [colors[i], colors[i].opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 40, height: 40)
                    .offset(x: animate ? offsets[i].0 + (float ? (i % 2 == 0 ? -2 : 2) : 0) : 0, y: animate ? offsets[i].1 + (float ? (i < 2 ? -2 : 2) : 0) : 0)
                    .rotationEffect(.degrees(animate ? (float ? 2 : -2) : 45))
                    .animation(
                        .easeInOut(duration: 2.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.2),
                        value: float
                    )
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15 + Double(i) * 0.1), value: animate)
            }
        }
        .onAppear {
            if animate { float = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { float = true }
        }
    }
}

// MARK: - Abstract (Default)
private struct AbstractIllustration: View {
    let animate: Bool
    @State private var float = false
    @State private var spin = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "E0E7FF").opacity(0.3))
                .frame(width: 180, height: 180)
                .scaleEffect(animate ? 1 : 0.3)
            
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "6366F1"), Color(hex: "4F46E5")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .scaleEffect(animate ? (float ? 1.05 : 0.95) : 0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: float)
                .animation(.spring(response: 0.6, dampingFraction: 0.65).delay(0.1), value: animate)
            
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(hex: "F59E0B"))
                .frame(width: 45, height: 45)
                .offset(x: 35 + (float ? -5 : 5), y: -10 + (float ? -5 : 5))
                .scaleEffect(animate ? 1 : 0)
                .rotationEffect(.degrees(animate ? (spin ? 360 : 0) : 45))
                .animation(.linear(duration: 8.0).repeatForever(autoreverses: false), value: spin)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: float)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.25), value: animate)
            
            Circle()
                .fill(Color(hex: "10B981"))
                .frame(width: 30, height: 30)
                .offset(x: -25 + (float ? 5 : -5), y: 30 + (float ? 5 : -5))
                .scaleEffect(animate ? (float ? 1.1 : 0.9) : 0)
                .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true).delay(0.5), value: float)
                .animation(.spring(response: 0.5, dampingFraction: 0.55).delay(0.35), value: animate)
        }
        .onAppear {
            if animate {
                float = true
                spin = true
            }
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                float = true
                spin = true
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        LessonIllustration(imageKey: "lesson_insight")
        LessonIllustration(imageKey: "lesson_brain")
        LessonIllustration(imageKey: nil)
    }
    .padding()
    .background(Color.black)
}


// MARK: - Rocket
// MARK: - Rocket
struct RocketIllustration: View {
    let animate: Bool
    @State private var shake = false
    @State private var thrust = false
    @State private var soar = false
    
    var body: some View {
        ZStack {
            // Space Background
            Circle()
                .fill(Color(hex: "1E3A8A").opacity(0.8))
                .frame(width: 170, height: 170)
                .scaleEffect(animate ? 1 : 0.3)
            
            // Shooting Stars
            ForEach(0..<4) { i in
                Capsule()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 2, height: CGFloat.random(in: 10...30))
                    .offset(x: CGFloat.random(in: -50...50), y: soar ? 100 : -100)
                    .animation(
                        .linear(duration: Double.random(in: 0.5...1.5))
                        .repeatForever(autoreverses: false)
                        .delay(Double(i) * 0.3),
                        value: soar
                    )
            }
            .opacity(animate ? 1 : 0)
            
            // Rocket Body
            ZStack {
                // Main Chassis
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(LinearGradient(colors: [Color.white, Color(hex: "E2E8F0")], startPoint: .top, endPoint: .bottom))
                    .frame(width: 40, height: 80)
                
                // Nose Cone
                Path { path in
                    path.move(to: CGPoint(x: 20, y: -20))
                    path.addLine(to: CGPoint(x: 40, y: 15))
                    path.addLine(to: CGPoint(x: 0, y: 15))
                    path.closeSubpath()
                }
                .fill(Color(hex: "EF4444"))
                .frame(width: 40, height: 35)
                .offset(y: -45)
                
                // Window
                Circle()
                    .fill(Color(hex: "3B82F6"))
                    .frame(width: 16, height: 16)
                    .overlay(Circle().stroke(Color(hex: "94A3B8"), lineWidth: 2))
                    .offset(y: -10)
                
                // Exhaust Flames
                ForEach(0..<3) { i in
                    Capsule()
                        .fill(LinearGradient(colors: [Color(hex: "FCD34D"), Color(hex: "EF4444")], startPoint: .top, endPoint: .bottom))
                        .frame(width: CGFloat([12, 16, 12][i]), height: thrust ? CGFloat([25, 35, 25][i]) : 10)
                        .offset(x: CGFloat([-10, 0, 10][i]), y: 45 + (thrust ? 10 : 0))
                        .animation(
                            .easeInOut(duration: 0.15)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.05),
                            value: thrust
                        )
                }
            }
            .offset(x: shake ? -1 : 1, y: animate ? -10 : 30) // Flight position + vibration
            .animation(.easeInOut(duration: 0.05).repeatForever(autoreverses: true), value: shake)
            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2), value: animate)
        }
        .onAppear {
            if animate {
                shake = true
                thrust = true
                soar = true
            }
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                shake = true
                thrust = true
                soar = true
            }
        }
    }
}

// MARK: - Compass
struct CompassIllustration: View {
    let animate: Bool
    @State private var hover = false
    @State private var sway = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FEF3C7").opacity(hover ? 0.6 : 0.2)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: hover)
            Circle().stroke(Color(hex: "D97706"), lineWidth: hover ? 8 : 4).frame(width: 80, height: 80).scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: hover)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
            RoundedRectangle(cornerRadius: 2).fill(Color(hex: "EF4444")).frame(width: 6, height: 35).offset(y: -10)
                .rotationEffect(.degrees(animate ? (sway ? 10 : -10) : 180))
                .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: sway)
                .animation(.spring(response: 0.6, dampingFraction: 0.5).delay(0.3), value: animate)
            Circle().fill(Color(hex: "1F2937")).frame(width: 10, height: 10)
        }
        .onAppear {
            if animate { hover = true; sway = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { hover = true; sway = true }
        }
    }
}

// MARK: - Calendar
struct CalendarIllustration: View {
    let animate: Bool
    @State private var float = false
    @State private var pulse = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "E0E7FF").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white).frame(width: 80, height: 90)
                    .shadow(color: Color(hex: "6366F1").opacity(float ? 0.3 : 0.1), radius: float ? 12 : 5)
                RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color(hex: "EF4444")).frame(width: 80, height: 25).offset(y: -32)
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(12)), count: 4), spacing: 6) {
                    ForEach(0..<8) { i in 
                        Circle()
                            .fill(Color(hex: "6B7280"))
                            .frame(width: 8, height: 8)
                            .opacity(pulse ? 1 : 0.4)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(Double(i) * 0.1), value: pulse)
                    }
                }.offset(y: 15).opacity(animate ? 1 : 0).animation(.easeOut(duration: 0.3).delay(0.4), value: animate)
            }
            .offset(y: float ? -5 : 5)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: float)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: animate)
        }
        .onAppear {
            if animate { float = true; pulse = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { float = true; pulse = true }
        }
    }
}

// MARK: - Checklist
struct ChecklistIllustration: View {
    let animate: Bool
    @State private var ripple = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "D1FAE5").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            VStack(spacing: 12) {
                ForEach(0..<3) { i in
                    HStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(hex: "10B981"), lineWidth: 2)
                            .frame(width: 18, height: 18)
                            .scaleEffect(ripple ? 1.1 : 0.95)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(Double(i) * 0.3), value: ripple)
                            .overlay(i < 2 ? Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)).foregroundStyle(Color(hex: "10B981")) : nil)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(hex: "9CA3AF"))
                            .frame(width: ripple ? 55 : 45, height: 8)
                            .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true).delay(Double(i) * 0.2), value: ripple)
                    }
                    .scaleEffect(animate ? 1 : 0, anchor: .leading)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6).delay(0.15 + Double(i) * 0.1), value: animate)
                }
            }
        }
        .onAppear {
            if animate { ripple = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { ripple = true }
        }
    }
}

// MARK: - Laptop
struct LaptopIllustration: View {
    let animate: Bool
    @State private var glow = false
    @State private var float = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "E0E7FF").opacity(glow ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glow)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous).fill(LinearGradient(colors: [Color(hex: "4B5563"), Color(hex: "374151")], startPoint: .top, endPoint: .bottom)).frame(width: 90, height: 60).offset(y: -10)
                RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Color(hex: "3B82F6"))
                    .frame(width: 70, height: 40).offset(y: -10)
                    .shadow(color: Color(hex: "3B82F6").opacity(glow ? 0.8 : 0.2), radius: glow ? 8 : 2)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: glow)
                RoundedRectangle(cornerRadius: 3, style: .continuous).fill(Color(hex: "6B7280")).frame(width: 110, height: 8).offset(y: 30)
            }
            .offset(y: float ? -4 : 4)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: float)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { glow = true; float = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { glow = true; float = true }
        }
    }
}

// MARK: - Coffee
struct CoffeeIllustration: View {
    let animate: Bool
    @State private var steam = false
    @State private var float = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FEF3C7").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(LinearGradient(colors: [Color(hex: "78350F"), Color(hex: "92400E")], startPoint: .top, endPoint: .bottom))
                .frame(width: 60, height: 70)
                .offset(y: animate ? (float ? 8 : 12) : 10)
                .scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: float)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
            
            ForEach(0..<3) { i in
                WaveShape().stroke(Color(hex: "D1D5DB"), lineWidth: 3)
                    .frame(width: 15, height: 10)
                    .offset(x: CGFloat(i - 1) * 15 + (steam ? -3 : 3), y: (steam ? -45 : -35) - CGFloat(i) * 5)
                    .opacity(animate ? (steam ? 0.8 : 0.3) : 0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(Double(i) * 0.3), value: steam)
            }
        }
        .onAppear {
            if animate { steam = true; float = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { steam = true; float = true }
        }
    }
}

// MARK: - Lotus
struct LotusIllustration: View {
    let animate: Bool
    @State private var bloom = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FCE7F3").opacity(bloom ? 0.5 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: bloom)
            ForEach(0..<5) { i in
                Ellipse()
                    .fill(LinearGradient(colors: [Color(hex: "F472B6"), Color(hex: "EC4899")], startPoint: .top, endPoint: .bottom))
                    .frame(width: 25, height: 45)
                    .offset(y: bloom ? -20 : -15)
                    .rotationEffect(.degrees(Double(i - 2) * (bloom ? 30 : 20)))
                    .scaleEffect(animate ? 1 : 0)
                    .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true).delay(Double(i) * 0.2), value: bloom)
                    .animation(.spring(response: 0.5, dampingFraction: 0.5).delay(0.1 + Double(i) * 0.08), value: animate)
            }
            Circle().fill(Color(hex: "FCD34D")).frame(width: 20, height: 20)
                .scaleEffect(animate ? (bloom ? 1.2 : 0.8) : 0)
                .shadow(color: Color(hex: "FCD34D").opacity(bloom ? 0.8 : 0.2), radius: bloom ? 10 : 2)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: bloom)
                .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.5), value: animate)
        }
        .onAppear {
            if animate { bloom = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { bloom = true }
        }
    }
}

// MARK: - Breath
struct BreathIllustration: View {
    let animate: Bool
    @State private var breathe = false
    var body: some View {
        ZStack {
            ForEach(0..<4) { i in
                Circle()
                    .stroke(Color(hex: "06B6D4").opacity(Double(4 - i) * 0.25), lineWidth: 2)
                    .frame(width: CGFloat(40 + i * 35), height: CGFloat(40 + i * 35))
                    .scaleEffect(animate ? (breathe ? 1.1 : 0.9) : 0.5)
                    .opacity(animate ? (breathe ? 0.8 : 0.4) : 0)
                    .animation(
                        .easeInOut(duration: 3.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.2),
                        value: breathe
                    )
                    .animation(.easeOut(duration: 0.8).delay(Double(i) * 0.15), value: animate)
            }
        }
        .onAppear {
            if animate { breathe = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { breathe = true }
        }
    }
}

// MARK: - Sunset
struct SunsetIllustration: View {
    let animate: Bool
    @State private var float = false
    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [Color(hex: "FCD34D"), Color(hex: "F97316")], startPoint: .top, endPoint: .bottom))
                .frame(width: 70, height: 70)
                .offset(y: animate ? (float ? -4 : 4) : 30)
                .opacity(animate ? 1 : 0)
                .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: float)
                .animation(.spring(response: 0.6, dampingFraction: 0.65).delay(0.1), value: animate)
            
            Rectangle()
                .fill(LinearGradient(colors: [Color(hex: "7C3AED").opacity(0.3), Color(hex: "EC4899").opacity(0.2)], startPoint: .top, endPoint: .bottom))
                .frame(width: 170, height: 50)
                .offset(y: 40 + (float ? -2 : 2))
                .opacity(animate ? 1 : 0)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true).delay(0.5), value: float)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: animate)
        }
        .onAppear {
            if animate { float = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { float = true }
        }
    }
}

// MARK: - Moon
struct MoonIllustration: View {
    let animate: Bool
    @State private var twinkle = false
    @State private var glow = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "1E3A5F").opacity(0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            Circle().fill(LinearGradient(colors: [Color(hex: "FEF3C7"), Color(hex: "FDE68A")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 70, height: 70)
                .scaleEffect(animate ? 1 : 0)
                .shadow(color: Color(hex: "FDE68A").opacity(glow ? 0.6 : 0.1), radius: glow ? 12 : 4)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glow)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
            
            Circle().fill(Color(hex: "1E3A5F").opacity(0.3))
                .frame(width: 50, height: 50)
                .offset(x: 15, y: -10)
                .scaleEffect(animate ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.25), value: animate)
            
            ForEach(0..<5) { i in
                Circle().fill(Color.white)
                    .frame(width: 4, height: 4)
                    .offset(x: CGFloat.random(in: -60...60), y: CGFloat.random(in: -60...60))
                    .opacity(animate ? (twinkle ? 1 : 0.2) : 0)
                    .scaleEffect(animate ? (twinkle ? 1.5 : 0.5) : 0)
                    .animation(
                        .easeInOut(duration: Double.random(in: 1.0...2.5))
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.4),
                        value: twinkle
                    )
                    .animation(.easeOut(duration: 0.3).delay(0.4 + Double(i) * 0.05), value: animate)
            }
        }
        .onAppear {
            if animate { twinkle = true; glow = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { twinkle = true; glow = true }
        }
    }
}

// MARK: - Clouds
struct CloudsIllustration: View {
    let animate: Bool
    @State private var drift = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "DBEAFE").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            HStack(spacing: -15) {
                Circle().fill(Color.white).frame(width: 40, height: 40)
                Circle().fill(Color.white).frame(width: 55, height: 55)
                Circle().fill(Color.white).frame(width: 45, height: 45)
            }
            .offset(x: drift ? 5 : -5, y: -10)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true), value: drift)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
            
            HStack(spacing: -10) {
                Circle().fill(Color(hex: "E5E7EB")).frame(width: 30, height: 30)
                Circle().fill(Color(hex: "E5E7EB")).frame(width: 40, height: 40)
            }
            .offset(x: 30 + (drift ? -3 : 3), y: 25)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true).delay(0.5), value: drift)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.3), value: animate)
        }
        .onAppear {
            if animate { drift = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { drift = true }
        }
    }
}

// MARK: - Rainbow
struct RainbowIllustration: View {
    let animate: Bool
    @State private var wave = false
    private let colors: [Color] = [Color(hex: "EF4444"), Color(hex: "F97316"), Color(hex: "FCD34D"), Color(hex: "22C55E"), Color(hex: "3B82F6"), Color(hex: "8B5CF6")]
    var body: some View {
        ZStack {
            ForEach(0..<6) { i in
                Circle().trim(from: 0, to: 0.5)
                    .stroke(colors[i], style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: CGFloat(120 - i * 16), height: CGFloat(120 - i * 16))
                    .rotationEffect(.degrees(180))
                    .offset(y: 20 + (wave ? (i % 2 == 0 ? -2 : 2) : (i % 2 == 0 ? 2 : -2)))
                    .scaleEffect(animate ? 1 : 0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(Double(i) * 0.2), value: wave)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(Double(i) * 0.08), value: animate)
            }
        }
        .onAppear {
            if animate { wave = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { wave = true }
        }
    }
}

// MARK: - Graduation
struct GraduationIllustration: View {
    let animate: Bool
    @State private var float = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "1F2937").opacity(0.1)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            ZStack {
                RoundedRectangle(cornerRadius: 2).fill(Color(hex: "1F2937")).frame(width: 80, height: 8).offset(y: -25)
                Rectangle().fill(Color(hex: "1F2937")).frame(width: 60, height: 40).offset(y: 0)
                Circle().fill(Color(hex: "FCD34D")).frame(width: 12, height: 12).offset(x: 50, y: -20)
            }
            .offset(y: float ? -5 : 5)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: float)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { float = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { float = true }
        }
    }
}

// MARK: - Trophy
struct TrophyIllustration: View {
    let animate: Bool
    @State private var shine = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FEF3C7").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient(colors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")], startPoint: shine ? .topLeading : .bottomTrailing, endPoint: shine ? .bottomTrailing : .topLeading))
                .frame(width: 50, height: 60)
                .offset(y: -5)
                .scaleEffect(animate ? 1 : 0)
                .shadow(color: Color(hex: "F59E0B").opacity(shine ? 0.6 : 0.2), radius: shine ? 12 : 4)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: shine)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
            RoundedRectangle(cornerRadius: 4).fill(Color(hex: "92400E")).frame(width: 60, height: 15).offset(y: 40).scaleEffect(animate ? 1 : 0).animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.25), value: animate)
            ForEach(0..<2) { i in
                Circle().trim(from: 0.25, to: 0.75).stroke(Color(hex: "F59E0B"), lineWidth: 5).frame(width: 25, height: 25).offset(x: CGFloat(i == 0 ? -35 : 35), y: -10).rotationEffect(.degrees(i == 0 ? 90 : -90)).scaleEffect(animate ? 1 : 0).animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.35), value: animate)
            }
        }
        .onAppear {
            if animate { shine = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { shine = true }
        }
    }
}

// MARK: - Medal
struct MedalIllustration: View {
    let animate: Bool
    @State private var swing = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "DBEAFE").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            ZStack {
                RoundedRectangle(cornerRadius: 2).fill(Color(hex: "3B82F6")).frame(width: 40, height: 50).offset(y: -40)
                Circle().fill(LinearGradient(colors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")], startPoint: .top, endPoint: .bottom)).frame(width: 60, height: 60).offset(y: 15)
                Image(systemName: "star.fill").font(.system(size: 20)).foregroundStyle(Color(hex: "92400E")).offset(y: 15)
            }
            .rotationEffect(.degrees(swing ? 10 : -10), anchor: .top)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: swing)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: animate)
        }
        .onAppear {
            if animate { swing = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { swing = true }
        }
    }
}

// MARK: - Crown
struct CrownIllustration: View {
    let animate: Bool
    @State private var hover = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FEF3C7").opacity(hover ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: hover)
            
            ZStack {
                CrownShape().fill(LinearGradient(colors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")], startPoint: .top, endPoint: .bottom)).frame(width: 80, height: 55)
                    .shadow(color: Color(hex: "F59E0B").opacity(hover ? 0.5 : 0.1), radius: hover ? 15 : 5)
                ForEach(0..<3) { i in
                    Circle().fill(Color(hex: "EF4444")).frame(width: 10, height: 10).offset(x: CGFloat(i - 1) * 25, y: -15)
                        .scaleEffect(hover ? 1.2 : 0.8)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(Double(i) * 0.3), value: hover)
                }
            }
            .offset(y: hover ? -5 : 5)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: hover)
            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { hover = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { hover = true }
        }
    }
}

private struct CrownShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width * 0.1, y: rect.height * 0.3))
        path.addLine(to: CGPoint(x: rect.width * 0.25, y: rect.height * 0.6))
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: 0))
        path.addLine(to: CGPoint(x: rect.width * 0.75, y: rect.height * 0.6))
        path.addLine(to: CGPoint(x: rect.width * 0.9, y: rect.height * 0.3))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        return path
    }
}

// MARK: - Podium
struct PodiumIllustration: View {
    let animate: Bool
    @State private var glow = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "D1FAE5").opacity(glow ? 0.6 : 0.2)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glow)
            
            HStack(alignment: .bottom, spacing: 6) {
                RoundedRectangle(cornerRadius: 4).fill(Color(hex: "9CA3AF")).frame(width: 35, height: animate ? 50 : 0)
                    .shadow(color: Color(hex: "9CA3AF").opacity(glow ? 0.6 : 0), radius: glow ? 8 : 2)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2), value: animate)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.4), value: glow)
                
                RoundedRectangle(cornerRadius: 4).fill(Color(hex: "FCD34D")).frame(width: 35, height: animate ? 70 : 0)
                    .shadow(color: Color(hex: "FCD34D").opacity(glow ? 0.8 : 0), radius: glow ? 12 : 4)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: animate)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: glow)
                
                RoundedRectangle(cornerRadius: 4).fill(Color(hex: "CD7F32")).frame(width: 35, height: animate ? 40 : 0)
                    .shadow(color: Color(hex: "CD7F32").opacity(glow ? 0.6 : 0), radius: glow ? 8 : 2)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.3), value: animate)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.2), value: glow)
            }.offset(y: 20)
        }
        .onAppear {
            if animate { glow = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { glow = true }
        }
    }
}

// MARK: - Phone
struct PhoneIllustration: View {
    let animate: Bool
    @State private var hover = false
    @State private var screenPulse = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "E0E7FF").opacity(hover ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: hover)
            
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(hex: "1F2937")).frame(width: 55, height: 100)
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(hex: "3B82F6")).frame(width: 45, height: 80)
                    .opacity(screenPulse ? 1 : 0.7)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: screenPulse)
            }
            .offset(y: hover ? -5 : 5)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: hover)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { hover = true; screenPulse = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { hover = true; screenPulse = true }
        }
    }
}

// MARK: - Battery
struct BatteryIllustration: View {
    let animate: Bool
    @State private var charge = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "D1FAE5").opacity(charge ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: charge)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "10B981"), lineWidth: 4).frame(width: 80, height: 40)
                RoundedRectangle(cornerRadius: 2).fill(Color(hex: "10B981")).frame(width: 8, height: 20).offset(x: 48)
                HStack(spacing: 4) {
                    ForEach(0..<3) { i in
                        RoundedRectangle(cornerRadius: 2).fill(Color(hex: "10B981"))
                            .frame(width: 18, height: 28)
                            .opacity(charge ? 1 : 0.3)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(Double(i) * 0.3), value: charge)
                    }
                }.offset(x: -6)
            }
            .scaleEffect(animate ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: animate)
        }
        .onAppear {
            if animate { charge = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { charge = true }
        }
    }
}

// MARK: - Wifi
struct WifiIllustration: View {
    let animate: Bool
    @State private var signal = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "DBEAFE").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            ForEach(0..<3) { i in
                Circle().trim(from: 0.55, to: 0.95)
                    .stroke(Color(hex: "3B82F6"), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: CGFloat(40 + i * 30), height: CGFloat(40 + i * 30))
                    .rotationEffect(.degrees(135))
                    .opacity(signal ? 1 : 0.2)
                    .scaleEffect(animate ? 1 : 0)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(Double(2 - i) * 0.2), value: signal)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1 + Double(2 - i) * 0.1), value: animate)
            }
            Circle().fill(Color(hex: "3B82F6")).frame(width: 15, height: 15).offset(y: 25)
                .scaleEffect(animate ? 1 : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.4), value: animate)
        }
        .onAppear {
            if animate { signal = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { signal = true }
        }
    }
}

// MARK: - CloudTech
struct CloudTechIllustration: View {
    let animate: Bool
    @State private var drift = false
    @State private var transfer = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "DBEAFE").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            HStack(spacing: -15) {
                Circle().fill(Color(hex: "60A5FA")).frame(width: 45, height: 45)
                Circle().fill(Color(hex: "3B82F6")).frame(width: 60, height: 60)
                    .shadow(color: Color(hex: "3B82F6").opacity(0.5), radius: drift ? 10 : 2)
                Circle().fill(Color(hex: "60A5FA")).frame(width: 50, height: 50)
            }
            .offset(y: drift ? -15 : -10)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: drift)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
            
            Image(systemName: "arrow.up.arrow.down").font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .offset(y: drift ? -15 : -10)
                .opacity(transfer ? 1 : 0.4)
                .scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: transfer)
                .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.35), value: animate)
        }
        .onAppear {
            if animate { drift = true; transfer = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { drift = true; transfer = true }
        }
    }
}

// MARK: - Notification
struct NotificationIllustration: View {
    let animate: Bool
    @State private var ring = false
    @State private var pulse = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FEE2E2").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            Image(systemName: "bell.fill").font(.system(size: 50))
                .foregroundStyle(LinearGradient(colors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")], startPoint: .top, endPoint: .bottom))
                .scaleEffect(animate ? 1 : 0)
                .rotationEffect(.degrees(animate ? (ring ? 15 : -15) : -15), anchor: .top)
                .animation(.easeInOut(duration: 0.2).repeatForever(autoreverses: true), value: ring)
                .animation(.spring(response: 0.6, dampingFraction: 0.5).delay(0.15), value: animate)
            
            Circle().fill(Color(hex: "EF4444")).frame(width: 18, height: 18)
                .offset(x: 20, y: -25)
                .scaleEffect(animate ? (pulse ? 1.2 : 0.9) : 0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: pulse)
                .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.35), value: animate)
        }
        .onAppear {
            if animate { ring = true; pulse = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { ring = true; pulse = true }
        }
    }
}

// MARK: - Dumbbell
struct DumbbellIllustration: View {
    let animate: Bool
    @State private var lift = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "E0E7FF").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            ZStack {
                RoundedRectangle(cornerRadius: 4).fill(Color(hex: "6B7280")).frame(width: 80, height: 12)
                ForEach(0..<2) { i in
                    RoundedRectangle(cornerRadius: 6).fill(Color(hex: "4F46E5")).frame(width: 20, height: 45).offset(x: CGFloat(i == 0 ? -45 : 45))
                }
            }
            .offset(y: lift ? -10 : 10)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: lift)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: animate)
        }
        .onAppear {
            if animate { lift = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { lift = true }
        }
    }
}

// MARK: - Running
struct RunningIllustration: View {
    let animate: Bool
    @State private var run = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "D1FAE5").opacity(run ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: run)
            
            Image(systemName: "figure.run").font(.system(size: 60, weight: .medium))
                .foregroundStyle(Color(hex: "10B981"))
                .offset(x: animate ? (run ? -5 : 5) : -20, y: run ? -2 : 2)
                .opacity(animate ? 1 : 0)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: run)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
            
            ForEach(0..<3) { i in
                Circle().fill(Color(hex: "34D399").opacity(0.5))
                    .frame(width: 8, height: 8)
                    .offset(x: CGFloat(-30 - i * 12) + (run ? -10 : 0), y: CGFloat(i * 5) + (run ? -5 : 5))
                    .opacity(animate ? (run ? 0 : 1) : 0)
                    .animation(
                        .easeOut(duration: 0.8)
                        .repeatForever(autoreverses: false)
                        .delay(Double(i) * 0.2),
                        value: run
                    )
            }
        }
        .onAppear {
            if animate { run = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { run = true }
        }
    }
}


// MARK: - Water
struct WaterIllustration: View {
    let animate: Bool
    @State private var float = false
    @State private var drops = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "DBEAFE").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(hex: "93C5FD")).frame(width: 50, height: 80).offset(y: 10)
                Ellipse().fill(Color(hex: "3B82F6")).frame(width: 55, height: 25).offset(y: -20)
            }
            .offset(y: float ? -5 : 5)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: float)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
            
            ForEach(0..<3) { i in
                Circle().fill(Color(hex: "60A5FA").opacity(0.6))
                    .frame(width: 6, height: 6)
                    .offset(x: CGFloat(i - 1) * 10, y: (drops ? -60 : -45) + CGFloat(i) * 5)
                    .opacity(animate ? (drops ? 0 : 1) : 0)
                    .animation(
                        .easeOut(duration: 1.2)
                        .repeatForever(autoreverses: false)
                        .delay(Double(i) * 0.3),
                        value: drops
                    )
            }
        }
        .onAppear {
            if animate { float = true; drops = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { float = true; drops = true }
        }
    }
}

// MARK: - Apple
struct AppleIllustration: View {
    let animate: Bool
    @State private var hover = false
    @State private var rustle = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FEE2E2").opacity(hover ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: hover)
            
            ZStack {
                Circle().fill(LinearGradient(colors: [Color(hex: "EF4444"), Color(hex: "DC2626")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 70, height: 70)
                    .shadow(color: Color(hex: "EF4444").opacity(hover ? 0.6 : 0.2), radius: hover ? 10 : 3)
                
                Ellipse().fill(Color(hex: "22C55E")).frame(width: 15, height: 25)
                    .offset(x: 5, y: -40)
                    .rotationEffect(.degrees(rustle ? 25 : 5), anchor: .bottomLeading)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: rustle)
                
                RoundedRectangle(cornerRadius: 2).fill(Color(hex: "78350F")).frame(width: 4, height: 12)
                    .offset(y: -35)
            }
            .offset(y: hover ? -5 : 5)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: hover)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { hover = true; rustle = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { hover = true; rustle = true }
        }
    }
}

// MARK: - Sleep
struct SleepIllustration: View {
    let animate: Bool
    @State private var floatZ = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "E0E7FF").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            ForEach(0..<3) { i in
                Text("Z").font(.system(size: CGFloat(20 + i * 8), weight: .bold))
                    .foregroundStyle(Color(hex: "6366F1").opacity(Double(3 - i) / 3))
                    .offset(x: CGFloat(i * 15) + (floatZ ? 5 : -5), y: CGFloat(-i * 20) + (floatZ ? -10 : 10))
                    .scaleEffect(animate ? 1 : 0)
                    .animation(
                        .easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(Double(i) * 0.4),
                        value: floatZ
                    )
                    .animation(.spring(response: 0.5, dampingFraction: 0.5).delay(0.15 + Double(i) * 0.12), value: animate)
            }
        }
        .onAppear {
            if animate { floatZ = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { floatZ = true }
        }
    }
}

// MARK: - Wallet
struct WalletIllustration: View {
    let animate: Bool
    @State private var float = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FEF3C7").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(LinearGradient(colors: [Color(hex: "78350F"), Color(hex: "92400E")], startPoint: .top, endPoint: .bottom))
                .frame(width: 80, height: 55)
                .offset(y: float ? -3 : 3)
                .scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: float)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
            
            Circle().fill(Color(hex: "FCD34D"))
                .frame(width: 20, height: 20)
                .offset(x: 30, y: float ? 6 : -6)
                .scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: float)
                .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.3), value: animate)
        }
        .onAppear {
            if animate { float = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { float = true }
        }
    }
}

// MARK: - Savings
struct SavingsIllustration: View {
    let animate: Bool
    @State private var float = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "D1FAE5").opacity(float ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: float)
            
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(hex: "10B981"))
                .frame(width: 70, height: 50)
                .offset(y: 10 + (float ? -3 : 3))
                .scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: float)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
            
            ForEach(0..<3) { i in
                Circle().fill(Color(hex: "FCD34D"))
                    .frame(width: 20, height: 20)
                    .offset(x: CGFloat(i - 1) * 12, y: -20 + CGFloat(i) * 5 + (float ? -5 : 5))
                    .scaleEffect(animate ? 1 : 0)
                    .animation(
                        .easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(Double(i) * 0.2),
                        value: float
                    )
                    .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.3 + Double(i) * 0.08), value: animate)
            }
        }
        .onAppear {
            if animate { float = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { float = true }
        }
    }
}

// MARK: - Stocks
struct StocksIllustration: View {
    let animate: Bool
    @State private var draw = false
    @State private var float = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "D1FAE5").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            StockChartShape()
                .trim(from: 0, to: draw ? 1 : 0)
                .stroke(Color(hex: "10B981"), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .frame(width: 100, height: 60)
                .scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 1.5).delay(0.3), value: draw)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.15), value: animate)
            
            Image(systemName: "arrow.up.right").font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(hex: "10B981"))
                .offset(x: 40 + (float ? 3 : -3), y: -25 + (float ? -3 : 3))
                .scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: float)
                .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.35), value: animate)
        }
        .onAppear {
            if animate { draw = true; float = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { draw = true; float = true }
        }
    }
}

private struct StockChartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height * 0.8))
        path.addLine(to: CGPoint(x: rect.width * 0.25, y: rect.height * 0.5))
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.7))
        path.addLine(to: CGPoint(x: rect.width * 0.75, y: rect.height * 0.3))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.1))
        return path
    }
}

// MARK: - Piggy
struct PiggyIllustration: View {
    let animate: Bool
    @State private var drop = false
    @State private var bounce = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FCE7F3").opacity(bounce ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: bounce)
            
            ZStack {
                Ellipse().fill(LinearGradient(colors: [Color(hex: "F472B6"), Color(hex: "EC4899")], startPoint: .top, endPoint: .bottom))
                    .frame(width: 80, height: 60)
                    .scaleEffect(bounce ? 1.05 : 0.95)
                    .animation(.spring(response: 0.3, dampingFraction: 0.4).repeatForever(autoreverses: true).delay(0.5), value: bounce)
                
                Circle().fill(Color(hex: "F9A8D4")).frame(width: 25, height: 25).offset(x: 35)
                    .scaleEffect(bounce ? 1.05 : 0.95)
                    .animation(.spring(response: 0.3, dampingFraction: 0.4).repeatForever(autoreverses: true).delay(0.5), value: bounce)
                
                RoundedRectangle(cornerRadius: 2).fill(Color(hex: "FCD34D")).frame(width: 20, height: 4)
                    .offset(y: drop ? 0 : -35)
                    .opacity(drop ? 0 : 1)
                    .animation(.easeIn(duration: 0.8).repeatForever(autoreverses: false), value: drop)
            }
            .scaleEffect(animate ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { drop = true; bounce = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { drop = true; bounce = true }
        }
    }
}

// MARK: - Vault
struct VaultIllustration: View {
    let animate: Bool
    @State private var spin = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "E5E7EB").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(hex: "4B5563")).frame(width: 80, height: 90)
                
                ZStack {
                    Circle().stroke(Color(hex: "9CA3AF"), lineWidth: 4).frame(width: 40, height: 40)
                    Circle().fill(Color(hex: "F59E0B")).frame(width: 12, height: 12).offset(y: -14)
                }
                .rotationEffect(.degrees(spin ? 360 : 0))
                .animation(.linear(duration: 4.0).repeatForever(autoreverses: false), value: spin)
            }
            .scaleEffect(animate ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { spin = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { spin = true }
        }
    }
}

// MARK: - Chat
struct ChatIllustration: View {
    let animate: Bool
    @State private var float = false
    @State private var type = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "DBEAFE").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(hex: "93C5FD")).frame(width: 60, height: 40).offset(x: 15, y: 20)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(hex: "3B82F6")).frame(width: 70, height: 50)
                    HStack(spacing: 4) {
                        ForEach(0..<3) { i in
                            Circle().fill(Color.white).frame(width: 6, height: 6)
                                .offset(y: type ? -3 : 3)
                                .animation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true).delay(Double(i) * 0.15), value: type)
                        }
                    }
                }
                .offset(x: -10, y: -10)
                .offset(y: float ? -3 : 3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: float)
            }
            .scaleEffect(animate ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { float = true; type = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { float = true; type = true }
        }
    }
}

// MARK: - Handshake
struct HandshakeIllustration: View {
    let animate: Bool
    @State private var shake = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "D1FAE5").opacity(shake ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: shake)
            
            Image(systemName: "hands.clap.fill").font(.system(size: 50))
                .foregroundStyle(LinearGradient(colors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")], startPoint: .top, endPoint: .bottom))
                .rotationEffect(.degrees(shake ? 10 : -10))
                .offset(y: shake ? -2 : 2)
                .scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: shake)
                .animation(.spring(response: 0.5, dampingFraction: 0.5).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { shake = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { shake = true }
        }
    }
}

// MARK: - Team
struct TeamIllustration: View {
    let animate: Bool
    @State private var bounce = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "DBEAFE").opacity(bounce ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: bounce)
            
            ForEach(0..<3) { i in
                Circle().fill(LinearGradient(colors: [Color(hex: "60A5FA"), Color(hex: "3B82F6")], startPoint: .top, endPoint: .bottom))
                    .frame(width: CGFloat(i == 1 ? 45 : 35), height: CGFloat(i == 1 ? 45 : 35))
                    .offset(x: CGFloat([-30, 0, 30][i]), y: CGFloat(i == 1 ? -10 : 10) + (bounce ? -5 : 5))
                    .scaleEffect(animate ? 1 : 0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(Double(i) * 0.2), value: bounce)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1 + Double(i) * 0.1), value: animate)
            }
        }
        .onAppear {
            if animate { bounce = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { bounce = true }
        }
    }
}

// MARK: - Thumbs
struct ThumbsIllustration: View {
    let animate: Bool
    @State private var wave = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "D1FAE5").opacity(wave ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: wave)
            
            Image(systemName: "hand.thumbsup.fill").font(.system(size: 55))
                .foregroundStyle(LinearGradient(colors: [Color(hex: "34D399"), Color(hex: "10B981")], startPoint: .top, endPoint: .bottom))
                .rotationEffect(.degrees(wave ? 5 : -10), anchor: .bottomTrailing)
                .scaleEffect(animate ? (wave ? 1.05 : 0.95) : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.4).repeatForever(autoreverses: true), value: wave)
                .animation(.spring(response: 0.5, dampingFraction: 0.5).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { wave = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { wave = true }
        }
    }
}

// MARK: - Celebrate
struct CelebrateIllustration: View {
    let animate: Bool
    @State private var pop = false
    @State private var spin = false
    private let confettiColors: [Color] = [Color(hex: "EF4444"), Color(hex: "F59E0B"), Color(hex: "10B981"), Color(hex: "3B82F6"), Color(hex: "8B5CF6")]
    
    var body: some View {
        ZStack {
            ForEach(0..<12) { i in
                RoundedRectangle(cornerRadius: 2).fill(confettiColors[i % 5])
                    .frame(width: 8, height: 16)
                    .offset(x: CGFloat.random(in: -60...60), y: (pop ? CGFloat.random(in: 30...80) : CGFloat.random(in: -80...(-30))))
                    .rotationEffect(.degrees(spin ? Double.random(in: 180...360) : 0))
                    .opacity(pop ? 0 : 1)
                    .scaleEffect(animate ? 1 : 0)
                    .animation(.linear(duration: Double.random(in: 2.0...3.0)).repeatForever(autoreverses: false).delay(Double(i) * 0.1), value: pop)
                    .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: spin)
            }
            Text("🎉").font(.system(size: 50))
                .scaleEffect(animate ? (pop ? 1.2 : 0.8) : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.4).repeatForever(autoreverses: true), value: pop)
                .animation(.spring(response: 0.6, dampingFraction: 0.5).delay(0.2), value: animate)
        }
        .onAppear {
            if animate { pop = true; spin = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { pop = true; spin = true }
        }
    }
}

// MARK: - Tree
struct TreeIllustration: View {
    let animate: Bool
    @State private var sway = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "D1FAE5").opacity(sway ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: sway)
            
            ZStack {
                RoundedRectangle(cornerRadius: 4).fill(Color(hex: "78350F")).frame(width: 15, height: 50).offset(y: 30)
                ForEach(0..<3) { i in
                    MountainShape()
                        .fill(Color(hex: i == 0 ? "10B981" : i == 1 ? "22C55E" : "34D399"))
                        .frame(width: CGFloat(80 - i * 20), height: CGFloat(45 - i * 10))
                        .offset(y: CGFloat(-20 - i * 25))
                        .rotationEffect(.degrees(sway ? Double(i + 1) * 2 : Double(i + 1) * -2), anchor: .bottom)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(Double(i) * 0.2), value: sway)
                }
            }
            .scaleEffect(animate ? 1 : 0, anchor: .bottom)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { sway = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { sway = true }
        }
    }
}

// MARK: - Leaf
struct LeafIllustration: View {
    let animate: Bool
    @State private var drift = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "D1FAE5").opacity(drift ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: drift)
            
            ZStack {
                Ellipse().fill(LinearGradient(colors: [Color(hex: "34D399"), Color(hex: "10B981")], startPoint: .top, endPoint: .bottom)).frame(width: 50, height: 80)
                RoundedRectangle(cornerRadius: 1).fill(Color(hex: "065F46")).frame(width: 2, height: 60)
            }
            .rotationEffect(.degrees(drift ? -15 : -45))
            .offset(x: drift ? -10 : 10, y: drift ? -5 : 5)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: drift)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { drift = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { drift = true }
        }
    }
}

// MARK: - Flower
struct FlowerIllustration: View {
    let animate: Bool
    @State private var bloom = false
    @State private var spin = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FCE7F3").opacity(bloom ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: bloom)
            
            ZStack {
                ForEach(0..<6) { i in
                    Ellipse().fill(Color(hex: "F472B6"))
                        .frame(width: bloom ? 30 : 20, height: bloom ? 50 : 35)
                        .offset(y: bloom ? -35 : -25)
                        .rotationEffect(.degrees(Double(i) * 60))
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: bloom)
                }
                Circle().fill(Color(hex: "FCD34D")).frame(width: 30, height: 30)
            }
            .rotationEffect(.degrees(spin ? 360 : 0))
            .scaleEffect(animate ? 1 : 0)
            .animation(.linear(duration: 8.0).repeatForever(autoreverses: false), value: spin)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { bloom = true; spin = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { bloom = true; spin = true }
        }
    }
}

// MARK: - Butterfly
struct ButterflyIllustration: View {
    let animate: Bool
    @State private var flap = false
    @State private var hover = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "E0E7FF").opacity(hover ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: hover)
            
            ZStack {
                ForEach(0..<2) { i in
                    Ellipse().fill(LinearGradient(colors: [Color(hex: "A78BFA"), Color(hex: "7C3AED")], startPoint: .top, endPoint: .bottom))
                        .frame(width: 40, height: 55)
                        .offset(x: CGFloat(i == 0 ? -25 : 25), y: -10)
                        .rotationEffect(.degrees(Double(i == 0 ? -20 : 20)))
                        .rotation3DEffect(.degrees(flap ? (i == 0 ? 60 : -60) : 0), axis: (x: 0, y: 1, z: 0), anchor: i == 0 ? .trailing : .leading)
                        .animation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true), value: flap)
                }
                Ellipse().fill(Color(hex: "4B5563")).frame(width: 8, height: 40)
            }
            .offset(y: hover ? -8 : 8)
            .scaleEffect(animate ? 1 : 0)
            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: hover)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { flap = true; hover = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { flap = true; hover = true }
        }
    }
}

// MARK: - Earth
struct EarthIllustration: View {
    let animate: Bool
    @State private var spin = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "DBEAFE").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            ZStack {
                Circle().fill(LinearGradient(colors: [Color(hex: "3B82F6"), Color(hex: "1D4ED8")], startPoint: .topLeading, endPoint: .bottomTrailing)).frame(width: 80, height: 80)
                Group {
                    Ellipse().fill(Color(hex: "22C55E")).frame(width: 30, height: 20).offset(x: -10, y: -15)
                    Ellipse().fill(Color(hex: "22C55E")).frame(width: 25, height: 15).offset(x: 15, y: 10)
                }
                .rotationEffect(.degrees(spin ? 360 : 0))
                .animation(.linear(duration: 8.0).repeatForever(autoreverses: false), value: spin)
            }
            .scaleEffect(animate ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { spin = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { spin = true }
        }
    }
}

// MARK: - RocketLaunch
struct RocketLaunchIllustration: View {
    let animate: Bool
    @State private var fire = false
    @State private var shake = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FEF3C7").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            ZStack {
                ForEach(0..<5) { i in
                    Circle().fill(Color(hex: "F59E0B").opacity(Double(5 - i) / 5))
                        .frame(width: CGFloat(15 + i * 8), height: CGFloat(15 + i * 8))
                        .offset(y: CGFloat(30 + i * 10) + (fire ? 5 : -5))
                        .scaleEffect(fire ? 1.1 : 0.9)
                        .animation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true).delay(Double(i) * 0.1), value: fire)
                }
                RoundedRectangle(cornerRadius: 20, style: .continuous).fill(LinearGradient(colors: [Color(hex: "6366F1"), Color(hex: "4F46E5")], startPoint: .top, endPoint: .bottom))
                    .frame(width: 35, height: 70)
                    .offset(x: shake ? -1 : 1, y: -20)
                    .animation(.easeInOut(duration: 0.1).repeatForever(autoreverses: true), value: shake)
            }
            .scaleEffect(animate ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { fire = true; shake = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { fire = true; shake = true }
        }
    }
}

// MARK: - LevelUp
struct LevelUpIllustration: View {
    let animate: Bool
    @State private var bounce = false
    @State private var twinkle = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "D1FAE5").opacity(bounce ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: bounce)
            
            Image(systemName: "arrow.up.circle.fill").font(.system(size: 60))
                .foregroundStyle(LinearGradient(colors: [Color(hex: "34D399"), Color(hex: "10B981")], startPoint: .top, endPoint: .bottom))
                .offset(y: bounce ? -10 : 0)
                .scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: bounce)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
            
            ForEach(0..<3) { i in
                Image(systemName: "sparkle").font(.system(size: 12))
                    .foregroundStyle(Color(hex: "FCD34D"))
                    .offset(x: CGFloat([-35, 0, 35][i]), y: CGFloat([-30, -50, -25][i]))
                    .scaleEffect(twinkle ? 1.2 : 0)
                    .opacity(twinkle ? 1 : 0)
                    .animation(
                        .easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(Double(i) * 0.3),
                        value: twinkle
                    )
            }
        }
        .onAppear {
            if animate { bounce = true; twinkle = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { bounce = true; twinkle = true }
        }
    }
}

// MARK: - Unlock
struct UnlockIllustration: View {
    let animate: Bool
    @State private var rotateShackle = false
    @State private var glow = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FEF3C7").opacity(glow ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glow)
            
            ZStack {
                RoundedRectangle(cornerRadius: 15).stroke(Color(hex: "F59E0B"), lineWidth: 6)
                    .frame(width: 35, height: 35)
                    .offset(x: rotateShackle ? 12 : 0, y: -20)
                    .rotationEffect(.degrees(rotateShackle ? 30 : 0), anchor: .bottomTrailing)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.5), value: rotateShackle)
                
                RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(hex: "F59E0B")).frame(width: 60, height: 50).offset(y: 10)
            }
            .scaleEffect(animate ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { rotateShackle = true; glow = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { rotateShackle = true; glow = true }
        }
    }
}

// MARK: - Streak
struct StreakIllustration: View {
    let animate: Bool
    @State private var flicker = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FEF3C7").opacity(flicker ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: flicker)
            
            ZStack {
                Image(systemName: "flame.fill").font(.system(size: 60))
                    .foregroundStyle(LinearGradient(colors: [Color(hex: "FCD34D"), Color(hex: "F97316"), Color(hex: "EF4444")], startPoint: .top, endPoint: .bottom))
                    .scaleEffect(flicker ? 1.05 : 0.95)
                    .rotationEffect(.degrees(flicker ? 5 : -5))
                    .animation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true), value: flicker)
                
                Text("7").font(.system(size: 20, weight: .bold)).foregroundStyle(.white).offset(y: 5)
            }
            .scaleEffect(animate ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { flicker = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { flicker = true }
        }
    }
}

// MARK: - Gem
struct GemIllustration: View {
    let animate: Bool
    @State private var hover = false
    @State private var twinkle = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "E0E7FF").opacity(hover ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: hover)
            
            GemShape().fill(LinearGradient(colors: [Color(hex: "A78BFA"), Color(hex: "7C3AED"), Color(hex: "5B21B6")], startPoint: .top, endPoint: .bottom))
                .frame(width: 70, height: 80)
                .offset(y: hover ? -5 : 5)
                .scaleEffect(animate ? 1 : 0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: hover)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.15), value: animate)
            
            ForEach(0..<4) { i in
                Circle().fill(Color.white.opacity(0.8)).frame(width: 6, height: 6)
                    .offset(x: CGFloat.random(in: -20...20), y: CGFloat.random(in: -25...15) + (hover ? -5 : 5))
                    .scaleEffect(twinkle ? 1.5 : 0.5)
                    .opacity(twinkle ? 1 : 0)
                    .animation(
                        .easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(Double(i) * 0.25),
                        value: twinkle
                    )
            }
        }
        .onAppear {
            if animate { hover = true; twinkle = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { hover = true; twinkle = true }
        }
    }
}

private struct GemShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.35))
        path.closeSubpath()
        return path
    }
}

// MARK: - Spiral
struct SpiralIllustration: View {
    let animate: Bool
    @State private var spin = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "E0E7FF").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            ZStack {
                ForEach(0..<4) { i in
                    Circle().trim(from: 0, to: 0.6)
                        .stroke(Color(hex: "6366F1").opacity(Double(4 - i) / 4), lineWidth: 4)
                        .frame(width: CGFloat(30 + i * 25), height: CGFloat(30 + i * 25))
                        .rotationEffect(.degrees(Double(i) * 45))
                }
            }
            .rotationEffect(.degrees(spin ? 360 : 0))
            .scaleEffect(animate ? 1 : 0)
            .animation(.linear(duration: 4.0).repeatForever(autoreverses: false), value: spin)
            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { spin = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { spin = true }
        }
    }
}

// MARK: - Hexagon
struct HexagonIllustration: View {
    let animate: Bool
    @State private var spin = false
    @State private var pulse = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "D1FAE5").opacity(pulse ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulse)
            
            HexagonShape().fill(LinearGradient(colors: [Color(hex: "34D399"), Color(hex: "10B981")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 80, height: 90)
                .rotationEffect(.degrees(spin ? 360 : 0))
                .scaleEffect(animate ? 1 : 0)
                .animation(.linear(duration: 10.0).repeatForever(autoreverses: false), value: spin)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { spin = true; pulse = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { spin = true; pulse = true }
        }
    }
}

private struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        path.move(to: CGPoint(x: w * 0.5, y: 0))
        path.addLine(to: CGPoint(x: w, y: h * 0.25))
        path.addLine(to: CGPoint(x: w, y: h * 0.75))
        path.addLine(to: CGPoint(x: w * 0.5, y: h))
        path.addLine(to: CGPoint(x: 0, y: h * 0.75))
        path.addLine(to: CGPoint(x: 0, y: h * 0.25))
        path.closeSubpath()
        return path
    }
}

// MARK: - DiamondAlt
struct DiamondAltIllustration: View {
    let animate: Bool
    @State private var spin = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "DBEAFE").opacity(0.4)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
            
            Rectangle().fill(LinearGradient(colors: [Color(hex: "60A5FA"), Color(hex: "3B82F6")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(spin ? 405 : 45)) // 45 + 360
                .scaleEffect(animate ? 1 : 0)
                .animation(.linear(duration: 6.0).repeatForever(autoreverses: false), value: spin)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.15), value: animate)
        }
        .onAppear {
            if animate { spin = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { spin = true }
        }
    }
}

// MARK: - Ring
struct RingIllustration: View {
    let animate: Bool
    @State private var spin = false
    @State private var pulse = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FEF3C7").opacity(pulse ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulse)
            
            Circle().trim(from: 0.1, to: 0.9)
                .stroke(LinearGradient(colors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")], startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .frame(width: 70, height: 70)
                .rotationEffect(.degrees(spin ? 360 : 0))
                .scaleEffect(animate ? 1 : 0)
                .animation(.linear(duration: 3.0).repeatForever(autoreverses: false), value: spin)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.15), value: animate)
            
            Circle().fill(Color(hex: "A78BFA")).frame(width: 18, height: 18)
                .scaleEffect(animate ? (pulse ? 1.2 : 0.8) : 0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulse)
        }
        .onAppear {
            if animate { spin = true; pulse = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { spin = true; pulse = true }
        }
    }
}

// MARK: - Mandala
struct MandalaIllustration: View {
    let animate: Bool
    @State private var spin = false
    @State private var pulse = false
    var body: some View {
        ZStack {
            Circle().fill(Color(hex: "FCE7F3").opacity(pulse ? 0.6 : 0.3)).frame(width: 170, height: 170).scaleEffect(animate ? 1 : 0.3)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulse)
            
            ZStack {
                ForEach(0..<8) { i in
                    Ellipse().stroke(Color(hex: "EC4899"), lineWidth: 2)
                        .frame(width: 20, height: pulse ? 60 : 40)
                        .offset(y: pulse ? -45 : -35)
                        .rotationEffect(.degrees(Double(i) * 45))
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulse)
                }
            }
            .rotationEffect(.degrees(spin ? 360 : 0))
            .scaleEffect(animate ? 1 : 0)
            .animation(.linear(duration: 12.0).repeatForever(autoreverses: false), value: spin)
            .animation(.spring(response: 0.5, dampingFraction: 0.5).delay(0.15), value: animate)
            
            Circle().fill(Color(hex: "F472B6")).frame(width: 25, height: 25)
                .scaleEffect(pulse ? 1.2 : 0.8)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulse)
        }
        .onAppear {
            if animate { spin = true; pulse = true }
        }
        .onChange(of: animate) { _, newValue in
            if newValue { spin = true; pulse = true }
        }
    }
}
