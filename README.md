# Frames iOS

[![Build Status](https://travis-ci.org/checkout/frames-ios.svg?branch=master)](https://travis-ci.org/checkout/frames-ios)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Frames.svg)](https://img.shields.io/cocoapods/v/Frames)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/Frames.svg?style=flat)]()
[![codecov](https://codecov.io/gh/checkout/frames-ios/branch/master/graph/badge.svg)](https://codecov.io/gh/checkout/frames-ios)
[![codebeat badge](https://codebeat.co/badges/d9bae177-78c1-40bb-94a7-187a7759d549)](https://codebeat.co/projects/github-com-checkout-frames-ios-master)
![license](https://img.shields.io/github/license/checkout/frames-ios.svg)

<p align="center">
	<img src="https://github.com/checkout/frames-ios/blob/master/screenshots/demo-frames-ios.gif?raw=true" width="320" alt="Demo frames ios"/>
</p>

## Requirements

- iOS 10.0+
- Xcode 12.4+
- Swift 5.3+

## Documentation

Further information on using the Frames SDK is available in the [integration guide](https://docs.checkout.com/integrate/sdks/ios-sdk).

Frames for iOS provides a convenient solution that can take the customer's sensitive information and exchange them for a secure token that can be used within Checkout.com's infrastructure.

Frames can be integrated in 2 ways:

1. Integrated with the UI
Embed the fully customisable UI provided by the SDK to accept card details, customer name and billling details and exchange them for a secure token. (See the [`CardViewController` tab](https://docs.checkout.com/integrate/sdks/ios-sdk#iOSSDK-Step2:ImporttheiOSSDKandchooseyourapproach))

2. Integrated without the UI
Use the provided API to send sensitive data to the Checkout.com server and retrieve the secure token (See the [`Headless` tab](https://docs.checkout.com/integrate/sdks/ios-sdk#iOSSDK-Step2:ImporttheiOSSDKandchooseyourapproach)).

You can find the Frames API reference [on this website](https://checkout.github.io/frames-ios/index.html).

- [Usage](https://checkout.github.io/frames-ios/usage.html)
- [Customizing the card view](https://checkout.github.io/frames-ios/customizing-the-card-view.html)
- Walkthrough
  - [Frames iOS example](frames-ios-example.html)

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.10.0+ is required to build Frames.

To integrate Frames into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Frames', '~> 3'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Frames into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "checkout/frames-ios" ~> 3
```

Run `carthage update --use-xcframeworks` to build the framework and drag the built `Frames` into your Xcode project.

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding Frames as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```
dependencies: [
    .package(url: "https://github.com/checkout/frames-ios.git", .upToNextMajor(from: "3.0.0"))
]
```

## Usage

Import the SDK:

```swift
import Frames
```

### Using the `CardViewController` UI

```swift
class ViewController: UIViewController, CardViewControllerDelegate {

    // Create a CheckoutAPIClient instance with your public key.
    let checkoutAPIClient = CheckoutAPIClient(
        publicKey: "<Your Public Key>",
        environment: .sandbox)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the CardViewController.
        let cardViewController = CardViewController(
            checkoutApiClient: checkoutAPIClient,
            cardHolderNameState: .hidden,
            billingDetailsState: .hidden)

        // Set the CardViewController delegate.
        cardViewController.delegate = self

        // Replace the bar button with Pay.
        cardViewController.rightBarButtonItem = UIBarButtonItem(
            title: "Pay",
            style: .done,
            target: nil,
            action: nil)

        // (Optional) Specify which schemes are allowed.
        cardViewController.availableSchemes = [.visa, .mastercard]

        // Push the cardViewController onto the navigation stack.
        navigationController?.pushViewController(cardViewController, animated: false)
    }

    func onTapDone(controller: CardViewController, cardToken: CkoCardTokenResponse?, status: CheckoutTokenStatus) {
        // Called when the tokenization request has completed.
        print(cardToken ?? "cardToken is nil")
    }

    func onSubmit(controller: CardViewController) {
        // Called just before a create card token request is made.
    }

}
```

### Headless Mode 

```swift
// Create a CheckoutAPIClient instance with your public key.
let checkoutAPIClient = CheckoutAPIClient(
    publicKey: "<Your Public Key>",
    environment: .sandbox)

let phoneNumber = CkoPhoneNumber(
    countryCode: "44",
    number: "7700900000")

let address = CkoAddress(
    addressLine1: "Wenlock Works",
    addressLine2: "Shepherdess Walk",
    city: "London",
    state: "London",
    zip: "N1 7BQ",
    country: "GB")

// Create a CardTokenRequest instance with the phoneNumber and address values.
let cardTokenRequest = CkoCardTokenRequest(
    number: "4242424242424242",
    expiryMonth: "01",
    expiryYear: "29",
    cvv: "100",
    name: "Test Customer",
    billingAddress: address,
    phone: phoneNumber)

// Request the card token.
checkoutAPIClient.createCardToken(card: cardTokenRequest) { result in
    switch result {
    case .success(let response):
        print(response)
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

### Using Methods available in FramesIos

You can find more examples on the [usage guide](https://checkout.github.io/frames-ios/usage.html).

#### Create the API Client `CheckoutAPIClient`:

```swift
// Replace "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14" with your own public key.
let checkoutAPIClient = CheckoutAPIClient(
    publicKey: "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14",
    environment: .sandbox)
```

#### Create the `CardUtils` instance:

```swift
let cardUtils = CardUtils()
```

#### Use `CardUtils` to verify card number:

```swift
// Verify card number.
let cardNumber = "4242424242424242"
let isValidCardNumber = cardUtils.isValid(cardNumber: cardNumber)

print(isValidCardNumber) // true
```

### Validate a CVV with `CardUtils`

```swift
// Verify CVV.
let cardNumber = "4242424242424242"
guard let cardType = cardUtils.getTypeOf(cardNumber: cardNumber) else { return }

let cvv = "100"
let isValidCVV = cardUtils.isValid(cvv: cvv, cardType: cardType)

print(isValidCVV) // true
```

### Validate an expiration date with CardUtils

```swift
// Verify expiration date.
let expirationMonth = "01"
let expirationYear = "29"

let isValidExpiration = cardUtils.isValid(
    expirationMonth: expirationMonth,
    expirationYear: expirationYear)

print(isValidExpiration) // true
```

### Get information about a card number with CardUtils

```swift
let cardNumber = "4242424242424242"
guard let cardType = cardUtils.getTypeOf(cardNumber: cardNumber) else { return }
print(cardType.name) // Visa
```

### Format a card number with CardUtils

```swift
let cardNumber = "4242424242424242"
guard let cardType = cardUtils.getTypeOf(cardNumber: cardNumber) else { return }

let formattedCardNumber = cardUtils.format(cardNumber: cardNumber, cardType: cardType)
print(formattedCardNumber) // 4242 4242 4242 4242
```

### Standardize a card number with CardUtils

```swift
let cardNumber = "4242 | 4242 | 4242 | 4242 "
let standardizedCardNumber = cardUtils.standardize(cardNumber: cardNumber)
print(standardizedCardNumber) // "4242424242424242"
```

#### Create the card token request `CkoCardTokenRequest`:

```swift
// Create a CheckoutAPIClient instance with your public key.
let checkoutAPIClient = CheckoutAPIClient(
    publicKey: "<Your Public Key>",
    environment: .sandbox)

let phoneNumber = CkoPhoneNumber(
    countryCode: "44",
    number: "7700900000")

let address = CkoAddress(
    addressLine1: "Wenlock Works",
    addressLine2: "Shepherdess Walk",
    city: "London",
    state: "London",
    zip: "N1 7BQ",
    country: "GB")

// Create a CardTokenRequest instance with the phoneNumber and address values.
let cardTokenRequest = CkoCardTokenRequest(
    number: "4242424242424242",
    expiryMonth: "01",
    expiryYear: "29",
    cvv: "100",
    name: "Test Customer",
    billingAddress: address,
    phone: phoneNumber)

// Request the card token.
checkoutAPIClient.createCardToken(card: cardTokenRequest) { result in
    switch result {
    case .success(let response):
        print(response)
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

The completion handler here provides a `Result<CkoCardTokenResponse, NetworkError>` value.

### Prompt for CVV confirmation

Create and configure a `CvvConfirmationViewController`.

```swift
let cvvConfirmationViewController = CvvConfirmationViewController()
cvvConfirmationViewController.delegate = self
```

Handle the result by adding conformance to `CvvConfirmationViewControllerDelegate`.

```swift
extension ViewController: CvvConfirmationViewControllerDelegate {

    func onConfirm(controller: CvvConfirmationViewController, cvv: String) {
        // Handle cvv.
    }

    func onCancel(controller: CvvConfirmationViewController) {
        // Handle cancellation.
    }

}
```

### Handle 3D Secure

When you send a 3D secure charge request from your server you will get back a 3D Secure URL. This is available from `_links.redirect.href` within the JSON response. You can then pass the 3D Secure URL to a `ThreedsWebViewController` in order to handle the verification.

The redirection URLs (`success_url` and `failure_url`) are set in the Checkout.com Hub, but they can be overwritten in the charge request sent from your server. It is important to provide the correct URLs to ensure a successful payment flow.


Create and configure a `ThreedsWebViewController`.

```swift
let threeDSWebViewController = ThreedsWebViewController(
    successUrl: "http://example.com/success",
    failUrl: "http://example.com/failure")
threeDSWebViewController.url = "http://example.com/3ds"
threeDSWebViewController.delegate = self
```

Handle the result by adding conformance to `ThreedsWebViewControllerDelegate`.

```swift
extension ViewController: ThreedsWebViewControllerDelegate {

    func threeDSWebViewControllerAuthenticationDidSucceed(_ threeDSWebViewController: ThreedsWebViewController, token: String?) {
        // Handle successful 3DS.
    }

    func threeDSWebViewControllerAuthenticationDidFail(_ threeDSWebViewController: ThreedsWebViewController) {
        // Handle failed 3DS.
    }

}
```

### Customize with `CheckoutTheme`

Further documentation about customizing Frames is available from the [customization guide](https://docs.checkout.com/integrate/sdks/ios-sdk/ios-sdk-customization-guide).

```swift
CheckoutTheme.primaryBackgroundColor = .purple
CheckoutTheme.secondaryBackgroundColor = .magenta
CheckoutTheme.tertiaryBackgroundColor = .red
CheckoutTheme.color = .white
CheckoutTheme.secondaryColor = .lightGray
CheckoutTheme.errorColor = .blue
CheckoutTheme.chevronColor = .white
CheckoutTheme.font = UIFont(name: "Chalkboard SE", size: 12)!
```

## License

Frames iOS is released under the MIT license. [See LICENSE](https://github.com/checkout/frames-ios/blob/master/LICENSE) for details.
