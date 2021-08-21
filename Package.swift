// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let cMinizipCSettings: [CSetting] = [
    .headerSearchPath("../CMinizip/include"),
    .define("HAVE_PKCRYPT"),
    .define("HAVE_WZAES"),
    .define("HAVE_LIBCOMP", .when(platforms: [.iOS, .macOS, .tvOS, .watchOS])),
    .define("HAVE_ICONV"),
    .define("HAVE_BZIP2"),
]

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
            dependencies: [
                .target(name: "CMinizipLibComp", condition: .when(platforms: [.iOS, .macOS, .tvOS, .watchOS])),
                .target(name: "CMinizipPOSIX", condition: .when(platforms: [.iOS, .macOS, .tvOS, .watchOS, .android, .linux])),
                .target(name: "CMinizipApple", condition: .when(platforms: [.iOS, .macOS, .tvOS, .watchOS])),
                .target(name: "CMinizipBzip2")
            ],
            cSettings: cMinizipCSettings),
        .target(
            name: "CMinizipLibComp",
            cSettings: cMinizipCSettings),
        .target(
            name: "CMinizipPOSIX",
            cSettings: cMinizipCSettings,
            linkerSettings: [
                .linkedLibrary("iconv")
            ]),
        .target(
            name: "CMinizipApple",
            cSettings: cMinizipCSettings,
            linkerSettings: [
                .linkedFramework("CoreFoundation"),
                .linkedFramework("Security"),
            ]),
        .target(
            name: "CMinizipBzip2",
            cSettings: cMinizipCSettings,
            linkerSettings: [
                .linkedLibrary("bz2")
            ]),
    ]
)
