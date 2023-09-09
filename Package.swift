// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "linear_regression",
    platforms: [
        .macOS("12.0")
    ],
    dependencies: [
    ],
    targets: [
        .executableTarget(
            name: "linear_regression",
            dependencies: []
        ),
        .testTarget(
            name: "linear_regressionTests",
            dependencies: ["linear_regression"]
        ),
    ]
)
