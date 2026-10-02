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
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ]

        ),

        .target(
            name: "LoggingBootstrapUI",
            dependencies: [
                "LoggingBootstrap",

                .product(name: "InMemoryLogging", package: "swift-log"),
            ]

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
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ]

        ),
    ]

#endif

let package = Package(
    name: "swift-logging-bootstrap",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .watchOS(.v11),
        .tvOS(.v18),
    ],
    products: products,
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.15.1"),
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0"),
    ],
    targets: targets
)
