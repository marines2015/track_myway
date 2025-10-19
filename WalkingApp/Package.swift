// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "WalkingApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(
            name: "WalkingApp",
            targets: ["WalkingApp"])
    ],
    targets: [
        .executableTarget(
            name: "WalkingApp",
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
