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
                .process("Resources/deep_work_mastery.json"),
                .process("Resources/morning_miracle.json"),
                .process("Resources/digital_minimalism.json"),
                .process("Resources/dopamine_detox.json"),
                .process("Resources/atomic_habits_screen_time.json"),
                .process("Resources/flow_state_science.json"),
                .process("Resources/psychology_of_money.json")
            ]
        )
    ]
)
