// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "TealiumKochava",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "TealiumKochava", targets: ["TealiumKochava", "KochavaTracker", "KochavaCore", "TealiumCore", "TealiumRemoteCommands", "TealiumTagManagement"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TealiumKochava",
            path: "./Sources"),
        .binaryTarget(
            name: "KochavaTracker",
            path: "./Frameworks/KochavaTracker.xcframework"
        )
        .binaryTarget(
            name: "KochavaCore",
            path: "./Frameworks/KochavaCore.xcframework"
        )
        .binaryTarget(
            name: "TealiumCore",
            path: "./Frameworks/TealiumCore.xcframework"
        )
        .binaryTarget(
            name: "TealiumRemoteCommands",
            path: "./Frameworks/TealiumRemoteCommands.xcframework"
        )
        .binaryTarget(
            name: "TealiumTagManagement",
            path: "./Frameworks/TealiumTagManagement.xcframework"
        )
    ]
)
