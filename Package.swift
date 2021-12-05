// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CSV",
    products: [
        .library(
            name: "CSV",
            targets: ["CSV"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "3.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.1.2"),
    ],
    targets: [
        .target(
            name: "CSV",
            dependencies: []
        ),
        .testTarget(
            name: "CSVTests",
            dependencies: [
                "CSV", "Quick", "Nimble"
            ],
            resources: [
                .copy("Resources/BTCEUR-1m-2021-11.csv"),
            ]
        ),
    ]
)
