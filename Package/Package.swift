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
        .library(name: "Core", targets: ["Core"]),
        .library(name: "Error", targets: ["Error"]),
        .library(name: "Features", targets: ["Features"]),
        .library(name: "GraphQL", targets: ["GraphQL"]),
        .library(name: "Resource", targets: ["Resource"]),
        .library(name: "StdLib", targets: ["StdLib"]),
        .library(name: "Style", targets: ["Style"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Package",
            dependencies: []),
        .testTarget(
            name: "PackageTests",
            dependencies: ["Package"]),
    ]
)
