// swift-tools-version:6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let products: [Product]
let targets: [Target]
#if os(anyAppleOS)
    products = [
        .library(
            name: "LoggingBootstrap",
            targets: ["LoggingBootstrap"]
        ),

        .library(
            name: "LoggingBootstrapUI",
            targets: ["LoggingBootstrapUI"]
        ),
    ]

    targets = [
        .target(
            name: "LoggingBootstrap",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "InMemoryLogging", package: "swift-log"),
            ]

        ),

        .target(
            name: "LoggingBootstrapUI",
            dependencies: [
                "LoggingBootstrap",

                .product(name: "InMemoryLogging", package: "swift-log"),
            ]

        ),

        .testTarget(
            name: "LoggingBootstrapTests",
            dependencies: ["LoggingBootstrap"]
        ),
    ]
#else
    products = [
        .library(
            name: "LoggingBootstrap",
            targets: ["LoggingBootstrap"]
        ),
    ]

    targets = [
        .target(
            name: "LoggingBootstrap",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "InMemoryLogging", package: "swift-log"),
            ]

        ),

        .testTarget(
            name: "LoggingBootstrapTests",
            dependencies: ["LoggingBootstrap"]
        ),
    ]

#endif

let package = Package(
    name: "swift-logging-bootstrap",
    platforms: [
        .macOS(.v14),
        .iOS(.v16),
        .watchOS(.v10),
        .tvOS(.v17),
    ],
    products: products,
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-log", from: "1.15.1"),
    ],
    targets: targets
)
