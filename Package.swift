// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let cMinizipCSettings: [CSetting] = [
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
                .target(name: "CMinizip-libcomp", condition: .when(platforms: [.iOS, .macOS, .tvOS, .watchOS])),
                .target(name: "CMinizip-posix", condition: .when(platforms: [.iOS, .macOS, .tvOS, .watchOS, .android, .linux])),
                .target(name: "CMinizip-apple", condition: .when(platforms: [.iOS, .macOS, .tvOS, .watchOS])),
                .target(name: "CMinizip-bzip2")
            ],
            sources: [
                "mz_crypt.c",
                "mz_os.c",
                "mz_strm.c",
                "mz_strm_buf.c",
                "mz_strm_mem.c",
                "mz_strm_split.c",
                "mz_zip.c",
                "mz_zip_rw.c",
                "mz_strm_pkcrypt.c",
                "mz_strm_wzaes.c",
            ],
            publicHeadersPath: ".",
            cSettings: cMinizipCSettings),
        .target(
            name: "CMinizip-libcomp",
            path: "Sources/CMinizip",
            sources: [
                "mz_strm_libcomp.c",
            ],
            cSettings: cMinizipCSettings),
        .target(
            name: "CMinizip-posix",
            path: "Sources/CMinizip",
            sources: [
                "mz_os_posix.c",
                "mz_strm_os_posix.c",
            ],
            cSettings: cMinizipCSettings,
            linkerSettings: [
                .linkedLibrary("iconv")
            ]),
        .target(
            name: "CMinizip-apple",
            path: "Sources/CMinizip",
            sources: [
                "mz_crypt_apple.c",
            ],
            cSettings: cMinizipCSettings,
            linkerSettings: [
                .linkedFramework("CoreFoundation"),
                .linkedFramework("Security"),
            ]),
        .target(
            name: "CMinizip-bzip2",
            path: "Sources/CMinizip",
            sources: [
                "mz_strm_bzip.c",
            ],
            cSettings: cMinizipCSettings,
            linkerSettings: [
                .linkedLibrary("bz2")
            ]),
    ]
)
