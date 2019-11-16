// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StatusAlert",
    platforms: [
       .iOS(.v9),
    ],
    products: [
        .library(name: "StatusAlert", targets: ["StatusAlert"]),
    ],
    targets: [
        .target(name: "StatusAlert", dependencies: []),
    ]
)
