// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Frames",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "Frames",
            targets: ["Frames"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/marmelroy/PhoneNumberKit.git", from: "3.3.0"),
        .package(name: "CheckoutEventLoggerKit", url: "https://github.com/checkout/checkout-event-logger-ios-framework.git", from: "1.0.3")
    ],
    targets: [
        .target(
            name: "Frames",
            dependencies: ["PhoneNumberKit", "CheckoutEventLoggerKit"],
            path: "Source",
            exclude: ["Suppporting Files/Info.plist"],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "FramesTests",
            dependencies: ["Frames"],
            path: "Tests",
            exclude: ["Info.plist"],
            resources: [
                .process("Fixtures")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)

