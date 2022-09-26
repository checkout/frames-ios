# Frames iOS
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Frames.svg)](https://img.shields.io/cocoapods/v/Frames)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/checkout/frames-ios?label=carthage)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/checkout/frames-ios?label=spm)

![Bitrise](https://img.shields.io/bitrise/b458eecbb0222141?token=7EWxlcgiqm8949liUxqcYA)
[![Platform](https://img.shields.io/cocoapods/p/Frames.svg?style=flat)]()
![license](https://img.shields.io/github/license/checkout/frames-ios.svg)

<p align="center">
    <img src="https://github.com/checkout/frames-ios/blob/feature/PIMOB-1048_support_readme_for_frames_relase_v4.0.0/screenshots/demo-frames-ios.gif?raw=true" width="320" alt="Demo frames ios"/>
</p>

## Requirements

- iOS 12.0+
- Xcode 12.4+
- Swift 5.3+

 


## Documentation

Frames for iOS tokenises customer and card data for use within [Checkout.com](https://www.checkout.com)'s payment infrastructure.

[Integration](#Integration): _Lets talk about our SDK code showing up inside your amazing application's sourcecode._

[Get started](#Get-started): _Start testing what we can do by presenting inside your UI_ 

[Make it your own](#Make-it-your-own)

Complete information will be found in the [Checkout ](https://docs.checkout.com/integrate/sdks/ios-sdk).
   
Embed the fully customisable UI provided by the SDK to accept card details, customer name and billling details and exchange them for a secure token. (See the [`HomeViewController` tab](https://docs.checkout.com/integrate/sdks/ios-sdk#iOSSDK-Step2:ImporttheiOSSDKandchooseyourapproach))

You can find the Frames API reference [on this website](https://checkout.github.io/frames-ios/index.html).


- Walkthrough
  - [Frames iOS example](frames-ios-example.html)

 


## Integration

We've done our best to support most common distribution methods on iOS for you. We are in strong favour of [SPM](#Swift-Package-Manager) but if for any reason this doesn't work for you, we're also supporting [Cocoapods](#Cocoapods) and [Carthage](#Carthage)

### Swift Package Manager
[Swift Package Manager](https://swift.org/package-manager/) integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies. It should work out of the box on latest Xcode projects since Xcode 11 and has had a lot of community support, seeing huge adoption over the recent years. This makes it our favourite distribution method and the easiest one to integrate, keep updated and build around.

Follow Apple's step by step guide into [adding package dependencies to your app](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app) and get started in no time! Just use this repository's URL (https://github.com/checkout/frames-ios) when adding dependency.

### CocoaPods
[CocoaPods](http://cocoapods.org) is the traditional dependency manager for Apple projects. Still supported but not always able to validate all its peculiar ways.

Make sure cocoapods is installed on your machine by running
```bash
$ pod --version
```
Any version newer than **1.10.0** is a good sign. If not installed, or unsupported, follow [Cocoapods Getting Started](https://guides.cocoapods.org/using/getting-started.html)

Once Cocoapods of a valid version is on your machine, to integrate Frames into your Xcode project, update your `Podfile`:
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Frames', '~> 4'
end
```

Then, run the following command in terminal:

```bash
$ pod install
```

To update your existing Cocoapod dependencies, use:
```bash
$ pod update
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

If you haven't already, [install Carthage](https://github.com/Carthage/Carthage#installing-carthage)

To integrate Frames into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github "checkout/frames-ios" ~> 4
```

Run `carthage update --use-xcframeworks` to build the framework and drag the built `Frames` into your Xcode project.


 


## Get started

Assuming you have completed the Integration via one of the suggested Install methods above (please use SPM if possible), let's have a look at getting the code running in your application.

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

## Make it your own

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
