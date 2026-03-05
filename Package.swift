// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Frames",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Frames",
            targets: ["Frames"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/marmelroy/PhoneNumberKit.git",
            from: "4.0.0"),
        .package(
            url: "https://github.com/checkout/checkout-risk-sdk-ios.git",
            from: "4.0.2"),
        .package(
            url: "https://github.com/checkout/checkout-event-logger-ios-framework.git",
            from: "1.2.4"
        )
    ],
    targets: [
        .target(
            name: "Frames",
            dependencies: [
                .product(name: "CheckoutEventLoggerKit",
                         package: "checkout-event-logger-ios-framework"),
                .product(name: "Risk", package: "checkout-risk-sdk-ios"),
                "PhoneNumberKit",
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
                .product(name: "CheckoutEventLoggerKit",
                         package: "checkout-event-logger-ios-framework"),
                .product(name: "Risk", package: "checkout-risk-sdk-ios"),
            ],
            path: "Checkout/Source"
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

