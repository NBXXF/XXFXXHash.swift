// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XXFXXHash",
    platforms: [.macOS(.v10_13), .iOS(.v11), .tvOS(.v11), .watchOS(.v6)],
    products: [
        .library(
            name: "xxHash",
            targets: ["xxHash"])
    ],
    dependencies: [],
    targets: [
        .target(name: "xxHash",
                dependencies: ["CxxHash"]),
        .systemLibrary(name: "CxxHash"),
        .testTarget(name: "xxHashTests",
                    dependencies: ["xxHash"])
    ]
)
