// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Frames",
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
            path: "Source"
        ),
        .testTarget(
            name: "Frames-Tests",
            dependencies: ["Frames"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)

