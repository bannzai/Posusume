// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "Application", targets: ["Application"]),
        .library(name: "Auth", targets: ["Auth"]),
        .library(name: "CloudStorage", targets: ["CloudStorage"]),
        .library(name: "Components", targets: ["Components"]),
        .library(name: "Error", targets: ["Error"]),
        .library(name: "Features", targets: ["Features"]),
        .library(name: "GraphQL", targets: ["GraphQL"]),
        .library(name: "Resource", targets: ["Resource"]),
        .library(name: "StdLib", targets: ["StdLib"]),
        .library(name: "Style", targets: ["Style"])
    ],
    dependencies: [
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk", from: "8.10.0"),
        .package(name: "Apollo", url: "https://github.com/apollographql/apollo-ios", from: "0.50.0")
    ],
    targets: [
        .target(
            name: "Package",
            dependencies: []),
        .testTarget(
            name: "PackageTests",
            dependencies: ["Package"]),
    ]
)
