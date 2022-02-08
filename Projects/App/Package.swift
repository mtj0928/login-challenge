// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "App",
            targets: ["ViewBuilders", "App"]
        ),
    ],
    dependencies: [
        .package(path: "../APIServices"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: ["ViewBuilders", "APIServices"]
        ),
        .target(
            name: "ViewBuilders",
            dependencies: ["Views"]
        ),
        .target(
            name: "Views",
            dependencies: [
                "Presenters",
                "Supports",
            ]
        ),
        .target(
            name: "Presenters",
            dependencies: [
                "Interactors",
                "Routers",
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
        .target(
            name: "Routers",
            dependencies: ["VIPERKit", "Supports"]
        ),
        .target(
            name: "Interactors",
            dependencies: ["VIPERKit"]),
        .target(name: "Supports"),
        .target(name: "VIPERKit"),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"]),
    ]
)