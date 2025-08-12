// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyLogger",
    platforms: [
        .iOS(.v12),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftyLogger",
            targets: ["SwiftyLogger"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftyLogger"
        ),
        .testTarget(
            name: "SwiftyLoggerTests",
            dependencies: ["SwiftyLogger"]
        ),
    ]
)
