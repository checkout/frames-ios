// swift-tools-version:5.6
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
            url: "https://github.com/marmelroy/PhoneNumberKit.git",
            exact: "3.5.9"),
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

