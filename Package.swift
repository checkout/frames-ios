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
        .package(url: "https://github.com/marmelroy/PhoneNumberKit.git", from: "3.3.3")
    ],
    targets: [
        .target(
            name: "Frames",
            dependencies: ["Alamofire", "PhoneNumberKit"],
            path: "Source",
            exclude: ["Suppporting Files/Info.plist"],
            resources: [
                .process("Resources/schemes/icon-dinersclub.png"),
                .process("Resources/schemes/icon-jcb.png"),
                .process("Resources/schemes/icon-dinersclub@3x.png"),
                .process("Resources/arrows/keyboard-previous.png"),
                .process("Resources/checkmarks/checkmark@2x.png"),
                .process("Resources/checkmarks/checkmark.png"),
                .process("Resources/arrows/keyboard-next@2x.png"),
                .process("Resources/schemes/icon-discover@3x.png"),
                .process("Resources/schemes/icon-visa@3x.png"),
                .process("Resources/schemes/icon-jcb@3x.png"),
                .process("Resources/schemes/icon-discover.png"),
                .process("Resources/arrows/keyboard-previous@2x.png"),
                .process("Resources/schemes/icon-maestro.png"),
                .process("Resources/schemes/icon-maestro@3x.png"),
                .process("Resources/arrows/keyboard-down@2x.png"),
                .process("Resources/schemes/icon-amex.png"),
                .process("Resources/schemes/icon-amex@3x.png"),
                .process("Resources/arrows/keyboard-next@3x.png"),
                .process("Resources/schemes/icon-visa.png"),
                .process("Resources/checkmarks/checkmark@3x.png"),
                .process("Resources/schemes/icon-mastercard@2x.png"),
                .process("Resources/schemes/icon-jcb@2x.png"),
                .process("Resources/schemes/icon-discover@2x.png"),
                .process("Resources/schemes/icon-amex@2x.png"),
                .process("Resources/schemes/icon-maestro@2x.png"),
                .process("Resources/arrows/keyboard-next.png"),
                .process("Resources/arrows/keyboard-down@3x.png"),
                .process("Resources/schemes/icon-visa@2x.png"),
                .process("Resources/arrows/keyboard-previous@3x.png"),
                .process("Resources/schemes/icon-mastercard@3x.png"),
                .process("Resources/schemes/icon-mastercard.png"),
                .process("Resources/arrows/keyboard-down.png"),
                .process("Resources/schemes/icon-dinersclub@2x.png")
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

