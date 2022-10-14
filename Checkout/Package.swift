// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "Checkout",
  defaultLocalization: "en",
  platforms: [
    .macOS(.v10_12),
    .iOS(.v12)
  ],
  products: [
    .library(
      name: "Checkout",
      targets: ["Checkout"]
    )
  ],
  dependencies: [
    .package(
      name: "CheckoutEventLoggerKit",
      url: "https://github.com/checkout/checkout-event-logger-ios-framework.git",
      from: "1.2.0"
    )
  ],
  targets: [
    .target(
      name: "Checkout",
      dependencies: ["CheckoutEventLoggerKit"],
      path: "Checkout/Source"
    ),
    .testTarget(
      name: "CheckoutTests",
      dependencies: ["Checkout", "CheckoutEventLoggerKit"],
      path: "Checkout/Test"
    ),
    .testTarget(
      name: "CheckoutIntegrationTests",
      dependencies: ["Checkout"],
      path: "Checkout/Integration"
    )
  ],
  swiftLanguageVersions: [.v5]
)
