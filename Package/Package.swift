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
        .library(name: "Root", targets: ["Root"]),
        .library(name: "SpotDetail", targets: ["SpotDetail"]),
        .library(name: "SpotMap", targets: ["SpotMap"]),
        .library(name: "SpotPost", targets: ["SpotPost"]),
        .library(name: "SpotPostEditor", targets: ["SpotPostEditor"]),
        .library(name: "StdLib", targets: ["StdLib"]),
        .library(name: "Style", targets: ["Style"]),
    ],
    dependencies: [
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk", from: "8.10.0"),
        .package(name: "Apollo", url: "https://github.com/apollographql/apollo-ios", from: "0.50.0")
    ],
    targets: [
        .target(name: "Account", dependencies: []),
        .target(name: "Application", dependencies: []),
        .target(name: "Auth", dependencies: []),
        .target(name: "CloudStorage", dependencies: []),
        .target(name: "Components", dependencies: []),
        .target(name: "Error", dependencies: []),
        .target(name: "GraphQL", dependencies: []),
        .target(name: "Location", dependencies: []),
        .target(name: "Photo", dependencies: []),
        .target(name: "Resource", dependencies: []),
        .target(name: "Root", dependencies: []),
        .target(name: "SpotDetail", dependencies: []),
        .target(name: "SpotMap", dependencies: []),
        .target(name: "SpotPost", dependencies: []),
        .target(name: "SpotPostEditor", dependencies: []),
        .target(name: "StdLib", dependencies: []),
        .target(name: "Style", dependencies: []),


        .testTarget(
            name: "PackageTests",
            dependencies: ["Package"]),
    ]
)
