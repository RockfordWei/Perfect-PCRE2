// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "PerfectPCRE2",
    products: [
        .library(
            name: "PerfectPCRE2",
            targets: ["PerfectPCRE2"]),
    ],
    dependencies: [
      .package(url: "https://github.com/RockfordWei/pcre2api.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "PerfectPCRE2",
            dependencies: []),
        .testTarget(
            name: "PerfectPCRE2Tests",
            dependencies: ["PerfectPCRE2"]),
    ]
)
