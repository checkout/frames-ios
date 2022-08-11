# Frames iOS
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Frames.svg)](https://img.shields.io/cocoapods/v/Frames)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/checkout/frames-ios?label=carthage)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/checkout/frames-ios?label=spm)

![Bitrise](https://img.shields.io/bitrise/b458eecbb0222141?token=7EWxlcgiqm8949liUxqcYA)
[![Platform](https://img.shields.io/cocoapods/p/Frames.svg?style=flat)]()
![license](https://img.shields.io/github/license/checkout/frames-ios.svg)

> TODO: replace gif
<p align="center">
	<img src="https://github.com/checkout/frames-ios/blob/master/screenshots/demo-frames-ios.gif?raw=true" width="320" alt="Demo frames ios"/>
</p>

## Requirements

- iOS 10.0+
- Xcode 12.4+
- Swift 5.3+

## Documentation

Further information on using the Frames SDK is available in the [integration guide](https://docs.checkout.com/integrate/sdks/ios-sdk).

Frames for iOS tokenises customer and card data for use within [Checkout.com](https://www.checkout.com)'s payment infrastructure.

> Frames only can be integrated with the UI
   
Embed the fully customisable UI provided by the SDK to accept card details, customer name and billling details and exchange them for a secure token. (See the [`CardViewController` tab](https://docs.checkout.com/integrate/sdks/ios-sdk#iOSSDK-Step2:ImporttheiOSSDKandchooseyourapproach))

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
    pod 'Frames', '~> 4'
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

```
github "checkout/frames-ios" ~> 4
```

Run `carthage update --use-xcframeworks` to build the framework and drag the built `Frames` into your Xcode project.

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding Frames as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/checkout/frames-ios.git", .upToNextMajor(from: "4.0.0"))
]
```

## Usage

Import the SDK:

```swift
import Frames
```

### Using the `PaymentFormViewController` UI

```swift
class YourViewController: UIViewController {
    // Create a PaymentFormConfiguration instance with your public key.
    let paymentConfiguration = PaymentFormConfiguration(
        apiKey: "<Your Public Key>",
        environment: .sandbox,
        // (Optional) Replace with which specific schemes are allowed.
        supportedSchemes: Card.Schemes.allCases,
        billingFormData: nil
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup payment form styles
        // (Optional) Replace with customisations.
        let paymentStyle = PaymentStyle(
            paymentFormStyle: BillingFormFactory.defaultPaymentFormStyle,
            billingFormStyle: BillingFormFactory.defaultBillingFormStyle
        )
        
        // Build paymentFormViewController
        let paymentFormViewController = PaymentFormFactory.buildViewController(
            configuration: paymentConfiguration, 
            style: paymentStyle
        )

        // Push the paymentFormViewController onto the navigation stack.
        navigationController?.pushViewController(paymentFormViewController, animated: true)
    }

    // TODO: replace with callbacks or new delegate methods for 4.0.0
    func onTapDone(
        controller: CardViewController, 
        cardToken: CkoCardTokenResponse?, 
        status: CheckoutTokenStatus
    ) {
        // Called when the tokenization request has completed.
        print(cardToken ?? "cardToken is nil")
    }

    func onSubmit(controller: CardViewController) {
        // Called just before a create card token request is made.
        // This is a great place to start animating a loading indicator, such as a spinner.
    }
}
```

### Handle 3D Secure

When you send a 3D secure charge request from your server you will get back a 3D Secure URL. This is available from `_links.redirect.href` within the JSON response. You can then pass the 3D Secure URL to a `ThreedsWebViewController` in order to handle the verification.

The redirection URLs (`success_url` and `failure_url`) are set in the Checkout.com Hub, but they can be overwritten in the charge request sent from your server. It is important to provide the correct URLs to ensure a successful payment flow.

Create and configure a `ThreedsWebViewController`.

```swift
let checkoutAPIService = CheckoutAPIService(publicKey: "<Your Public Key>", environment: .sandbox)

guard
    let successUrl = URL(string: "http://example.com/success"),
    let failUrl = URL(string: "http://example.com/failure"),
    let challengeUrl = URL(string: "http://example.com/3ds")\
else {
    // handle error
    return
}

let threeDSWebViewController = ThreedsWebViewController(
    checkoutAPIService: checkoutAPIService,
    successUrl: successUrl,
    failUrl: failUrl
)
threeDSWebViewController.delegate = self
threeDSWebViewController.url = challengeUrl
```

Handle the result by adding conformance to `ThreedsWebViewControllerDelegate`.

> TODO: clean up these delegate methods and update the docs accordingly
```swift
extension YourViewController: ThreedsWebViewControllerDelegate {
    func threeDSWebViewControllerAuthenticationDidSucceed(_ threeDSWebViewController: ThreedsWebViewController, token: String?) {
        // Handle successful 3DS.
    }

    func threeDSWebViewControllerAuthenticationDidFail(_ threeDSWebViewController: ThreedsWebViewController) {
        // Handle failed 3DS.
    }
}
```

> Suggested syntax instead
```swift
typealias ThreeDSWebViewResult = Result<String?, ThreeDSWebViewError>

extension YourViewController: ThreedsWebViewControllerDelegate {
    func threeDSWebViewComplete(
        _ threeDSWebViewController: ThreedsWebViewController,
        result: ThreeDSWebViewResult
    ) {
        switch result {
        case .success(let token):
            // Handle successful 3DS.
        case .failure(let error):
            // Handle failed 3DS
        }
    }
}
```

## Apple Pay example

Our iOS SDK also supports handling `PKPayment` token data from Apple Pay.

```swift
func handle(payment: PKPayment) {
    // Create a CheckoutAPIClient instance with your public key.

    let checkoutAPIService = CheckoutAPIService(
        publicKey: "<Your Public Key>", 
        environment: .sandbox
    )

    // Get the data containing the encrypted payment information.
    let paymentData = payment.token.paymentData

    // Request an Apple Pay token.
    checkoutAPIService.createToken(.applePay(ApplePay(paymentData))) { result in
        switch result {
        case .success(let tokenDetails):
            print(tokenDetails)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
```



### Customize with `CheckoutTheme`

> TODO: theming

Further documentation about customizing Frames is available from the [customization guide](https://www.checkout.com/docs/integrate/sdks/ios-sdk/customization-guide).

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

> TODO: update link to point at `main` when moving from git flow to github flow
Frames iOS is released under the MIT license. [See LICENSE](https://github.com/checkout/frames-ios/blob/master/LICENSE) for details.
