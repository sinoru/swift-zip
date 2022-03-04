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
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ZIP",
            dependencies: ["CMinizip"]),
        .testTarget(
            name: "ZIPTests",
            dependencies: ["ZIP"],
            resources: [
                .copy("Resources/sample-zip-file.zip")
            ]),
        .target(
            name: "CMinizip",
            cSettings: [
                .define("HAVE_PKCRYPT"),
                .define("HAVE_WZAES"),
                .define("HAVE_LIBCOMP", .when(platforms: [.iOS, .macOS, .tvOS, .watchOS])),
                .define("HAVE_ICONV", .when(platforms: [.iOS, .macOS, .tvOS, .watchOS, .android, .linux])),
                .define("HAVE_BZIP2"),
            ],
            linkerSettings: [
                .linkedLibrary("iconv", .when(platforms: [.iOS, .macOS, .tvOS, .watchOS, .android, .linux])),
                .linkedFramework("CoreFoundation", .when(platforms: [.iOS, .macOS, .tvOS, .watchOS])),
                .linkedFramework("Security", .when(platforms: [.iOS, .macOS, .tvOS, .watchOS])),
                .linkedLibrary("bz2")
            ]),
    ]
)

#if swift(>=5.5)
package.platforms = [
    .macOS(.v11),
    .iOS(.v14),
    .watchOS(.v7),
    .tvOS(.v14)
]
#endif
