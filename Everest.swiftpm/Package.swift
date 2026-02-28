// swift-tools-version: 5.9
import PackageDescription

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
            appIcon: .placeholder(icon: .mountain),
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
                .process("Resources")
            ]
        )
    ]
)
