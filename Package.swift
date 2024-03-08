// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TealiumKochava",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "TealiumKochava", targets: ["TealiumKochava"]),
    ],
    dependencies: [
        .package(name: "TealiumSwift", url: "https://github.com/tealium/tealium-swift", .upToNextMajor(from: "2.12.0")),
        .package(name: "KochavaTracker", url: "https://github.com/Kochava/Apple-SwiftPackage-KochavaTracker", .upToNextMajor(from: "5.1.0")),
        .package(name: "KochavaCore", url: "https://github.com/Kochava/Apple-SwiftPackage-KochavaCore", .upToNextMajor(from: "5.1.0"))
    ],
    targets: [
        .target(
            name: "TealiumKochava",
            dependencies: [
                .product(name: "TealiumCore", package: "TealiumSwift"),
                .product(name: "TealiumRemoteCommands", package: "TealiumSwift"),
                .product(name: "KochavaTracker", package: "KochavaTracker", condition: .when(platforms: [.iOS])),
                .product(name: "KochavaCore", package: "KochavaCore", condition: .when(platforms: [.iOS]))
            ],
            path: "Sources",
            exclude: ["Support"]),
        .testTarget(
            name: "TealiumKochavaTests",
            dependencies: ["TealiumKochava"],
            path: "Tests",
            exclude: ["Support"]),
    ]
)
