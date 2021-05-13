// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "PerfectPCRE2",
    products: [
        .library(
            name: "PerfectPCRE2",
            targets: ["PerfectPCRE2"]),
    ],
    dependencies: [
    ],
    targets: [
        .systemLibrary(name: "pcre2api",
            pkgConfig: "libpcre2-8",
            providers: [
                .apt(["libpcre2-dev"]),
                .brew(["pcre2"])
            ]
        ),
        .target(
            name: "PerfectPCRE2",
            dependencies: ["pcre2api"]),
        .testTarget(
            name: "PerfectPCRE2Tests",
            dependencies: ["PerfectPCRE2"]),
    ]
)
