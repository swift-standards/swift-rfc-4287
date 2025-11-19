// swift-tools-version: 6.0

import PackageDescription

extension String {
    static let rfc4287: Self = "RFC 4287"
}

extension Target.Dependency {
    static var rfc4287: Self { .target(name: .rfc4287) }
    static var rfc2822: Self { .product(name: "RFC 2822", package: "swift-rfc-2822") }
    static var rfc3987: Self { .product(name: "RFC 3987", package: "swift-rfc-3987") }
}

let package = Package(
    name: "swift-rfc-4287",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        .library(
            name: .rfc4287,
            targets: [.rfc4287]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-rfc-2822.git", from: "0.1.0"),
        .package(url: "https://github.com/swift-standards/swift-rfc-3987.git", from: "0.1.0")
    ],
    targets: [
        .target(
            name: .rfc4287,
            dependencies: [.rfc2822, .rfc3987],
            swiftSettings: [
                .swiftLanguageMode(.v6),
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "\(String.rfc4287) Tests",
            dependencies: [.rfc4287],
            swiftSettings: [
                .swiftLanguageMode(.v6),
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
    ]
)
