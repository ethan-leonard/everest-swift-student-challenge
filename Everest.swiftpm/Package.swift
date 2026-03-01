// swift-tools-version: 5.9

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Everest",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "Everest",
            targets: ["AppModule"],
            bundleIdentifier: "com.everest.playground",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.green),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .localNetwork(purposeString: "Local Network Not Used By Everest Challenge App", bonjourServiceTypes: [])
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "Sources",
            resources: [
                .process("Resources/adhd_superpowers.json"),
                .process("Resources/anxiety_antidote.json"),
                .process("Resources/art_of_happiness.json"),
                .process("Resources/atomic_habits_screen_time.json"),
                .process("Resources/attachment_theory.json"),
                .process("Resources/body_language_decoder.json"),
                .process("Resources/breathwork_basics.json"),
                .process("Resources/crypto_for_normies.json"),
                .process("Resources/deep_work_mastery.json"),
                .process("Resources/digital_minimalism.json"),
                .process("Resources/dopamine_detox.json"),
                .process("Resources/emotional_intelligence.json"),
                .process("Resources/essentialism.json"),
                .process("Resources/feminism_decoded.json"),
                .process("Resources/five_second_rule.json"),
                .process("Resources/flow_state_science.json"),
                .process("Resources/four_hour_workweek.json"),
                .process("Resources/gut_health_101.json"),
                .process("Resources/ikigai_your_purpose.json"),
                .process("Resources/influence.json"),
                .process("Resources/mindfulness_for_beginners.json"),
                .process("Resources/morning_miracle.json"),
                .process("Resources/negotiation_ninja.json"),
                .process("Resources/pomodoro_power.json"),
                .process("Resources/psychology_of_money.json"),
                .process("Resources/rich_dad_mindset.json"),
                .process("Resources/sleep_smarter.json"),
                .process("Resources/start_with_why.json"),
                .process("Resources/stoicism_for_leaders.json"),
                .process("Resources/thinking_fast_slow.json"),
                .process("Resources/zero_to_one.json")
            ]
        )
    ]
)
