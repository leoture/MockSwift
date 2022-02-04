// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MockSwift",
    products: [
        .library(
            name: "MockSwift",
            targets: ["MockSwift"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MockSwift",
            dependencies: []),
        .testTarget(
            name: "MockSwiftTests",
            dependencies: ["MockSwift"]),
        .testTarget(
            name: "MockSwiftIntegrationTests",
            dependencies: ["MockSwift"])
    ]
)
