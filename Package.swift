// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PopTimer",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "PopTimer",
            targets: ["PopTimer"]
        )
    ],
    targets: [
        .target(
            name: "PopTimer"),
        .testTarget(
            name: "PopTimerTests",
            dependencies: ["PopTimer"]
        )
    ]
)
