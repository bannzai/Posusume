// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    products: [
        .library(name: "Account", targets: ["Account"]),
        .library(name: "Location", targets: ["Location"]),
        .library(name: "Photo", targets: ["Photo"]),
        .library(name: "Root", targets: ["Root"]),
        .library(name: "SpotDetail", targets: ["SpotDetail"]),
        .library(name: "SpotMap", targets: ["SpotMap"]),
        .library(name: "SpotPost", targets: ["SpotPost"]),
        .library(name: "SpotPostEditor", targets: ["SpotPostEditor"]),
    ],
    dependencies: [
        .package(name: "GraphQL", path: ".."),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "Account", dependencies: ["GraphQL"]),
        .target(name: "Location", dependencies: ["GraphQL"]),
        .target(name: "Photo", dependencies: ["GraphQL"]),
        .target(name: "Root", dependencies: ["GraphQL"]),
        .target(name: "SpotDetail", dependencies: ["GraphQL"]),
        .target(name: "SpotMap", dependencies: ["GraphQL"]),
        .target(name: "SpotPost", dependencies: ["GraphQL"]),
        .target(name: "SpotPostEditor", dependencies: ["GraphQL"]),

        .testTarget(
            name: "FeaturesTests",
            dependencies: ["Features"]),
    ]
)
