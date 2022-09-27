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

Frames for iOS tokenises customer and card data for use within [Checkout.com](https://www.checkout.com)'s payment infrastructure. We want to abstract all the complexity in taking payments from your Mobile Application and allow you to focus on the amazing experience & features you deliver to your users.

- [Integration](#Integration): _Lets talk about our SDK code showing up inside your amazing application's sourcecode._

- [Demo projects](#Demo-projects): _We have crafted projects showcasing the functionality while testing each distribution method offered_

- [Get started](#Get-started): _Start testing what you can achieve by presenting inside your Applications UI_ 

- [Make it your own](#Make-it-your-own): _Customising the UI to become a part of your app_

- [Other features](): _How we help with Apple Pay & 3D Secure Challenges_

- [License](#License)


Complete information will be found in the [Checkout Docs](https://docs.checkout.com/integrate/sdks/ios-sdk).
   
You can find the Frames API reference [on this website](https://checkout.github.io/frames-ios/index.html).


 


# Integration

We've done our best to support most common distribution methods on iOS for you. We are in strong favour of [SPM](#Swift-Package-Manager) (Swift Package Manager) but if for any reason this doesn't work for you, we're also supporting [Cocoapods](#Cocoapods) and [Carthage](#Carthage)

### Swift Package Manager
[Swift Package Manager](https://swift.org/package-manager/) integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies. It should work out of the box on latest Xcode projects since Xcode 11 and has had a lot of community support, seeing huge adoption over the recent years. This makes it our favourite distribution method and the easiest one to integrate, keep updated and build around.

If you've never used it before, get started with Apple's step by step guide into [adding package dependencies to your app](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app) and we'll boost your project in no time! Just use this repository's URL (https://github.com/checkout/frames-ios) when adding dependency.


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


 


# Demo projects

With the help of some of our amazing coleagues at Checkout, we have created some very simple demo applications that use our SDK and you should be able to run locally as soon as you cloned the repository (whether directly via git or with suggested Integration methods).

Our demo apps also test the supported integration methods (SPM, Cocoapods, Carthage), so if you're having any problems there, they should offer a working example. You will find them in the root of the repository, inside respective folders:
- iOS Example Frame (Using Cocoapods distribution)
- iOS Example Frame SPM (SPM distribution)
- iOS Example Frame Carthage (Carthage distribution)

Once running, you will find the home screen with a number of design options. We have tried to make them pretty contrasting to give your UI/UX teammates an idea of what can be achieved. We've also tried to write the code in the simplest way to track and understand how each UI flavour was created. Just start from `HomeViewController.swift` and follow the button actions in code (`@IBAction`) for some examples on how we achieve those UIs.




 


# Get started

If you got here, we'll either assume you've completed Integration or you're just curious. If none, then please complete [Integration](#Integration) first.

#### 1. Import `Frames`
<sub>If unsure where to just do it for now from your ViewController that will be presenting the journey.</sub>
```swift
import Frames
```

#### 2. Prepare your object responsible for the Frames configuration
This is the logical configuration:
- ensuring you receive access for the request
- enable us to prevalidate supported schemes at input stage
- prefill user information (Optional but may go a long way with User Experience if able to provide)

```swift
/** 
    This is optional and can use nil instead of this property. 
    But if you can provide these details for your user you can
        - make their checkout experience easier by prefilling fields they may need to do
        - improve acceptance success for card tokenisation
*/
let billingFormData = BillingForm(
    name: "Amazing Customer",
    address: nil,
    phone: nil)

let configuration = PaymentFormConfiguration(
    apiKey: "pk_test_6e40a700-d563-43cd-89d0-f9bb17d35e73",
    environment: .sandbox,
    supportedSchemes: [.visa, .maestro, .mastercard],
    billingFormData: billingFormData)
```

#### 3. Prepare the Styling for the UI
<sub>We will cover [Make it your own](#Make-it-your-own) later, for now we'll use Default Style</sub>
```swift
// Style applied on Card input screen (Payment Form)
let paymentFormStyle = DefaultPaymentFormStyle()

// Style applied on Billing input screen (Billing Form)
let billingFormStyle = DefaultBillingFormStyle()

// Frames Style
let style = PaymentStyle(
    paymentFormStyle: paymentFormStyle,
    billingFormStyle: billingFormStyle)
```

#### 4. Prepare your response from the flow completing
<sub>If the user completes flow without cancelling, the completion handler will be called, with a card token if successful, or with an error if failed</sub>
```swift
let completion: ((Result<TokenDetails, TokenRequestError>) -> Void) = { result in
    switch result {
    case .failure(let error):
        print("Failed, received error", error.localizedDescription)
    case .success(let tokenDetails):
        print("Success, received token", tokenDetails.token)
    }
}
```

#### 5. Use our `PaymentFormFactory` to generate the ViewController
<sub>Using properties from Steps 2, 3 & 4, lets now create the ViewController</sub>
```swift
let framesViewController = PaymentFormFactory.buildViewController(
    configuration: configuration, // Step 2,
    style: style,                 // Step 3
    completionHandler: completion // Step 4
)
```

#### 6. Present the ViewController to your user
<sub>We now have created the ViewController needed to enable full tokenisation for your user. Let's present it.</sub>
```swift
/** 
    We are assuming you started the Walkthrough from the presenting ViewController 
        and that a Navigation Controller is available
    
    You will need to make minor adjustments otherwise. 
    
    For the best experience we recommend embedding the presenting ViewController inside an UINavigationController
*/
navigationController?.pushViewController(framesViewController, animated: true)
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
