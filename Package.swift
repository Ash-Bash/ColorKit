// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ColorKit",
    platforms: [
        SupportedPlatform.macOS(SupportedPlatform.MacOSVersion.v10_16),
        SupportedPlatform.iOS(SupportedPlatform.IOSVersion.v14),
        SupportedPlatform.watchOS(SupportedPlatform.WatchOSVersion.v7),
        SupportedPlatform.tvOS(SupportedPlatform.TVOSVersion.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ColorKit",
            targets: ["ColorKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        //.package(url: "https://github.com/Ash-Bash/Sliders-SwiftUI", from: "1.0.11"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ColorKit",
            dependencies: []),
        .testTarget(
            name: "ColorKitTests",
            dependencies: ["ColorKit"]),
    ]
)
