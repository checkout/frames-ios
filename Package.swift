// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Frames",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v10)
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
            from: "3.3.3"
        ),
        .package(
            name: "CheckoutEventLoggerKit",
            url: "https://github.com/checkout/checkout-event-logger-ios-framework.git",
            from: "1.2.0"
        ),
        .package(
            name: "Checkout",
            path: "./Checkout"
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

