// swift-tools-version:5.2.0

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
            dependencies: ["MockSwift"])
    ]
)
