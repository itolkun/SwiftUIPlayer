// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIPlayer",
    platforms: [
        .iOS(.v14)
    ], products: [
        .library(
            name: "SwiftUIPlayer",
            targets: ["SwiftUIPlayer"]),
    ],
    targets: [
        .target(
            name: "SwiftUIPlayer"),
        .testTarget(
            name: "SwiftUIPlayerTests",
            dependencies: ["SwiftUIPlayer"]),
    ]
)
