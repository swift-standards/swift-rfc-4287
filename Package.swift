// swift-tools-version: 6.2

import PackageDescription

extension String {
    static let rfc4287: Self = "RFC 4287"
}

extension Target.Dependency {
    static var rfc4287: Self { .target(name: .rfc4287) }
    static var rfc2822: Self { .product(name: "RFC 2822", package: "swift-rfc-2822") }
    static var rfc3339: Self { .product(name: "RFC 3339", package: "swift-rfc-3339") }
    static var rfc3987: Self { .product(name: "RFC 3987", package: "swift-rfc-3987") }
    static var rfc4648: Self { .product(name: "RFC 4648", package: "swift-rfc-4648") }
}

let package = Package(
    name: "swift-rfc-4287",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26)
    ],
    products: [
        .library(
            name: .rfc4287,
            targets: [.rfc4287]
        ),
    ],
    dependencies: [
        .package(path: "../swift-rfc-2822"),
        .package(path: "../swift-rfc-3339"),
        .package(path: "../swift-rfc-3987"),
        .package(path: "../swift-rfc-4648")
    ],
    targets: [
        .target(
            name: .rfc4287,
            dependencies: [.rfc2822, .rfc3339, .rfc3987, .rfc4648]
        ),
        .testTarget(
            name: "\(String.rfc4287)".tests,
            dependencies: [.rfc4287]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
    var foundation: Self { self + " Foundation" }
}

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let existing = target.swiftSettings ?? []
    target.swiftSettings = existing + [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility")
    ]
}
