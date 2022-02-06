// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VIPER",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "VIPER",
            targets: ["ViewBuilders"]
        ),
    ],
    dependencies: [
        .package(path: "../APIServices"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "ViewBuilders",
            dependencies: ["Views"]
        ),
        .target(
            name: "Views",
            dependencies: [
                "Presenters",
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
        .target(
            name: "Presenters",
            dependencies: ["Interactors", "Routers"]
        ),
        .target(
            name: "Routers",
            dependencies: ["VIPERKit"]
        ),
        .target(
            name: "Interactors",
            dependencies: ["APIServices", "VIPERKit"]),
        .target(name: "VIPERKit"),
        .testTarget(
            name: "InteractorsTests",
            dependencies: ["Interactors"]),
    ]
)
