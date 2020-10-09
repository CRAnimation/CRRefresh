// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CRRefresh",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "CRRefresh",
            targets: ["CRRefresh"]),
    ],
    targets: [
        .target(
            name: "CRRefresh",
            resources: [
                .copy("Assets/"),
                //                .process("Resources/config.json"),
                //                .copy("Resources/HTML")
            ]),
    ]
)
