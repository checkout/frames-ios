// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Frames",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Frames",
            targets: ["Frames"]
        )
    ],
    dependencies: [
        .package(
            name: "PhoneNumberKit",
            url: "https://github.com/marmelroy/PhoneNumberKit.git",
            from: "3.5.9"
        ),
        .package(
            name: "CheckoutEventLoggerKit",
            url: "https://github.com/checkout/checkout-event-logger-ios-framework.git",
            from: "1.2.4"
        )
    ],
    targets: [
        .target(
            name: "Frames",
            dependencies: [
                "PhoneNumberKit",
                "CheckoutEventLoggerKit",
                "Checkout"
            ],
            path: "Source",
            exclude: ["Suppporting Files/Info.plist"],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "Checkout",
            dependencies: [
                "CheckoutEventLoggerKit",
            ],
            path: "Checkout/Checkout/Source"
        ),
        .testTarget(
            name: "CheckoutTests",
            dependencies: [
                "Checkout"
            ],
            path: "CheckoutTests"
        ),
        .testTarget(
            name: "FramesTests",
            dependencies: [
              "Frames",
              "Checkout"
            ],
            path: "Tests",
            exclude: ["Info.plist"],
            resources: [
                .process("Fixtures")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)

