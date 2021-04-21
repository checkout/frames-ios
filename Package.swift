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
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.4.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit.git", from: "3.3.0"),
        .package(name: "CheckoutEventLoggerKit", url: "https://github.com/checkout/checkout-event-logger-ios-framework.git", from: "1.0.1")
    ],
    targets: [
        .target(
            name: "Frames",
            dependencies: ["Alamofire", "PhoneNumberKit", "CheckoutEventLoggerKit"],
            path: "Source",
            exclude: ["Suppporting Files/Info.plist"],
            resources: [
                .process("Resources")
            ]
        ),
// Tests are currently broken as Mockingjay doesn't support SPM
//
//        .testTarget(
//            name: "Frames-Tests",
//            dependencies: ["Frames"],
//            path: "Tests",
//            exclude: ["Info.plist"],
//            resources: [
//                .process("Fixtures/applePayTokenInvalid.json"),
//                .process("Fixtures/cardTokenInvalidNumber.json"),
//                .process("Fixtures/applePayToken.json"),
//                .process("Fixtures/ckoCardToken.json"),
//                .process("Fixtures/cardProviders.json")
//            ]
//        )
    ],
    swiftLanguageVersions: [.v5]
)

