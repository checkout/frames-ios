# Frames iOS
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Frames.svg)](https://img.shields.io/cocoapods/v/Frames)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/checkout/frames-ios?label=carthage)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/checkout/frames-ios?label=spm)

![Bitrise](https://img.shields.io/bitrise/b458eecbb0222141?token=7EWxlcgiqm8949liUxqcYA)
[![Platform](https://img.shields.io/cocoapods/p/Frames.svg?style=flat)]()
![license](https://img.shields.io/github/license/checkout/frames-ios.svg)

<p align="center">
    <img src="https://github.com/checkout/frames-ios/blob/PIMOB-1048_support_readme_for_frames_relase_v4.0.0/screenshots/demo-frames-ios.gif?raw=true" width="320" alt="Demo frames ios"/>
</p>

## Requirements

- iOS 12.0+
- Xcode 12.4+
- Swift 5.3+

## Documentation

Further information on using the Frames SDK is available in the [integration guide](https://docs.checkout.com/integrate/sdks/ios-sdk).

Frames for iOS tokenises customer and card data for use within [Checkout.com](https://www.checkout.com)'s payment infrastructure.

> Frames only can be integrated with the UI
   
Embed the fully customisable UI provided by the SDK to accept card details, customer name and billling details and exchange them for a secure token. (See the [`HomeViewController` tab](https://docs.checkout.com/integrate/sdks/ios-sdk#iOSSDK-Step2:ImporttheiOSSDKandchooseyourapproach))

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
platform :ios, '12.0'
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

import SDK in a Factory

```swift
import Frames
import Checkout
import UIKit

enum Factory {
    
    static func getDefaultPaymentViewController(completionHandler: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) -> UIViewController {

        let country = Country(iso3166Alpha2: "GB")!
        let address = Address(addressLine1: "Test line1",
                          addressLine2: nil,
                          city: "London",
                          state: "London",
                          zip: "N12345",
                          country: country)

        let phone = Phone(number: "77 1234 1234", country: country)
        let billingFormData = BillingForm(name: "Bình Inyene", address: address, phone: phone)
        let billingFormStyle = FramesFactory.defaultBillingFormStyle
        let paymentFormStyle = FramesFactory.defaultPaymentFormStyle
        let supportedSchemes: [CardScheme] = [.visa, .mastercard, .maestro]

        let configuration = PaymentFormConfiguration(apiKey: "<Your Public Key>", environment: .sandbox, supportedSchemes: supportedSchemes, billingFormData: billingFormData)
    
        let style = PaymentStyle(paymentFormStyle: paymentFormStyle, billingFormStyle: billingFormStyle)
    
        let viewController = PaymentFormFactory.buildViewController(configuration: configuration, style: style, completionHandler: completionHandler)
    
        return viewController
  }
}
```

### Using the `getDefaultPaymentViewController` as `UIViewController` in UI
```swift
class YourViewController: UIViewController {
    
    private func showDefaultTheme() {
        let viewController = Factory.getDefaultPaymentViewController { [weak self] result in
            self?.handleTokenResponse(with: result)
        }
        navigationController?.pushViewController(viewController, animated: true)
  } 
  
  private func handleTokenResponse(with result: Result<TokenDetails, TokenisationError.TokenRequest>) {
    switch result {
      case .failure(let error):
       // handle failure
      case .success(let tokenDetails):
        // handle success
    }
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



### Customize with `Frames Style`

> TODO: update Styling URL

Further documentation about customizing Frames is available from the [customization guide](https://www.checkout.com/docs/integrate/sdks/ios-sdk/customization-guide).


## License

Frames iOS is released under the MIT license. [See LICENSE](https://github.com/checkout/frames-ios/blob/main/LICENSE) for details.
