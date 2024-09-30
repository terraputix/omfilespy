// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

#if arch(x86_64)
    // Docker and Ubuntu release system uses `march=skylake`
    let mArch =
        ProcessInfo.processInfo.environment["MARCH_SKYLAKE"] == "TRUE"
        ? ["-march=skylake"] : ["-march=native"]
#else
    let mArch: [String] = []
#endif

let cFlags = [
    PackageDescription.CSetting.unsafeFlags(
        ["-O3", "-fno-math-errno", "-fno-trapping-math", "-freciprocal-math", "-ffp-contract=fast"]
            + mArch)
]
// Note: Fast math flags reduce performance for compression
let cFlagsPFor2D = [PackageDescription.CSetting.unsafeFlags(["-O3"] + mArch)]
let cFlagsPFor = [PackageDescription.CSetting.unsafeFlags(["-O3", "-w"] + mArch)]

let package = Package(
    name: "om-files",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftPFor2D",
            type: .static,
            targets: ["SwiftPFor2D"]
        ),
        .library(
            name: "OmFileInterface",
            type: .static,
            targets: ["OmFileInterface"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OmFileInterface",
            dependencies: ["SwiftPFor2D"]
            // swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
        .target(
            name: "SwiftPFor2D", dependencies: ["CTurboPFor", "CHelper"], cSettings: cFlagsPFor2D),
        .target(name: "CTurboPFor", cSettings: cFlagsPFor),
        .target(name: "CHelper"),
        .testTarget(
            name: "SwiftPFor2DTests",
            dependencies: ["SwiftPFor2D"]),
    ]
)
