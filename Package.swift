// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-zip",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ZIP",
            targets: ["ZIP"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/sinoru/swift-cminizip-ng.git", from: "0.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ZIP",
            dependencies: [
                .product(name: "Cminizip-ng", package: "swift-cminizip-ng")
            ]),
        .testTarget(
            name: "ZIPTests",
            dependencies: ["ZIP"],
            resources: [
                .copy("Resources/sample-zip-file.zip")
            ]),
    ]
)

#if swift(>=5.5)
package.platforms = [
    .macOS("12"),
    .iOS("15"),
    .watchOS("8"),
    .tvOS("15"),
]
#endif
