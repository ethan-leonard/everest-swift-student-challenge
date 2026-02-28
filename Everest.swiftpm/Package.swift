// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Everest",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Everest",
            targets: ["AppModule"]
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
