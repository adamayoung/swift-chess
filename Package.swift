// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-chess",

    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .watchOS(.v11),
        .tvOS(.v18),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "SwiftChess", targets: ["SwiftChess"])
    ],

    targets: [
        .target(name: "SwiftChess"),
        .testTarget(name: "SwiftChessTests", dependencies: ["SwiftChess"])
    ]
)
