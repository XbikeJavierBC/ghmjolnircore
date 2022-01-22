// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ghmjolnircore",
    products: [
        .library(
            name: "ghmjolnircore",
            targets: [
                "ghmjolnircore"
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ghmjolnircore",
            dependencies: []
        ),
        .testTarget(
            name: "ghmjolnircoreTests",
            dependencies: [
                "ghmjolnircore"
            ]
        ),
    ]
)
