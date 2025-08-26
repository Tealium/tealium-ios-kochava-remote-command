// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TealiumKochava",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "TealiumKochava", targets: ["TealiumKochava"]),
    ],
    dependencies: [
        .package(name: "TealiumSwift", url: "https://github.com/tealium/tealium-swift", .upToNextMajor(from: "2.18.0")),
        .package(name: "KochavaNetworking", url: "https://github.com/Kochava/Apple-SwiftPackage-KochavaNetworking-XCFramework", .upToNextMajor(from: "9.1.0")),
        .package(name: "KochavaMeasurement", url: "https://github.com/Kochava/Apple-SwiftPackage-KochavaMeasurement-XCFramework", .upToNextMajor(from: "9.1.0")),
        .package(name: "KochavaTracking", url: "https://github.com/Kochava/Apple-SwiftPackage-KochavaTracking-XCFramework", .upToNextMajor(from: "9.1.0"))
    ],
    targets: [
        .target(
            name: "TealiumKochava",
            dependencies: [
                .product(name: "TealiumCore", package: "TealiumSwift"),
                .product(name: "TealiumRemoteCommands", package: "TealiumSwift"),
                .product(name: "KochavaNetworking", package: "KochavaNetworking"),
                .product(name: "KochavaMeasurement", package: "KochavaMeasurement"),
                .product(name: "KochavaTracking", package: "KochavaTracking")
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