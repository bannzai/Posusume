// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "Account", targets: ["Account"]),
        .library(name: "Application", targets: ["Application"]),
        .library(name: "Auth", targets: ["Auth"]),
        .library(name: "CloudStorage", targets: ["CloudStorage"]),
        .library(name: "Components", targets: ["Components"]),
        .library(name: "Error", targets: ["Error"]),
        .library(name: "GraphQL", targets: ["GraphQL"]),
        .library(name: "Location", targets: ["Location"]),
        .library(name: "Photo", targets: ["Photo"]),
        .library(name: "Resource", targets: ["Resource"]),
        .library(name: "SpotDetail", targets: ["SpotDetail"]),
        .library(name: "SpotMap", targets: ["SpotMap"]),
        .library(name: "SpotPost", targets: ["SpotPost"]),
        .library(name: "SpotPostEditor", targets: ["SpotPostEditor"]),
        .library(name: "StdLib", targets: ["StdLib"]),
        .library(name: "Style", targets: ["Style"]),
    ],
    dependencies: [
        .package(name: "Apollo", url: "https://github.com/apollographql/apollo-ios", .upToNextMinor(from: "0.49.0")),
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMinor(from: "8.10.0")),
    ],
    targets: [
        // MARK: - Main
        .target(name: "Application", dependencies: [
            "Auth",
        ]),

        // MARK: - Domain
        .target(name: "Account", dependencies: [
            "GraphQL",
        ]),
        .target(name: "SpotDetail", dependencies: [
            "GraphQL",
        ]),
        .target(name: "SpotMap", dependencies: [
            "GraphQL",
        ]),
        .target(name: "SpotPost", dependencies: [
            "GraphQL",
        ]),
        .target(name: "SpotPostEditor", dependencies: [
            "GraphQL",
        ]),

        // MARK: - Library
        .target(name: "Auth", dependencies: [
            .product(name: "FirebaseAuth", package: "Firebase"),
        ]),
        .target(name: "CloudStorage", dependencies: [
            .product(name: "FirebaseStorage", package: "Firebase"),
        ]),
        .target(name: "GraphQL", dependencies: [
            .product(name: "Apollo", package: "Apollo"),
            .product(name: "ApolloSQLite", package: "Apollo"),
        ]),
        .target(name: "StdLib", dependencies: []),

        // MARK: - Component
        .target(name: "Components", dependencies: []),
        .target(name: "Error", dependencies: []),
        .target(name: "Location", dependencies: []),
        .target(name: "Photo", dependencies: []),
        .target(name: "Resource", dependencies: []),
        .target(name: "Style", dependencies: []),
    ]
)
