![Checkout.com](https://github.com/checkout/frames-ios/blob/main/.github/media/checkout-logo.png)

# Frames iOS
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Frames.svg)](https://img.shields.io/cocoapods/v/Frames)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/checkout/frames-ios?label=spm)
[![Platform](https://img.shields.io/cocoapods/p/Frames.svg?style=flat)]()
![license](https://img.shields.io/github/license/checkout/frames-ios.svg)

<div align="center">
    <img width=40% src="https://github.com/checkout/frames-ios/blob/main/.github/media/demo-frames-ios.webp?raw=true">
</div>

## Requirements

- iOS 12.0+
- Xcode 12.4+
- Swift 5.3+

 
## Documentation

Frames for iOS tokenises consumer data for use within [Checkout.com](https://www.checkout.com)'s payment infrastructure. We abstract away the complexity of taking payments, building payment UIs, and handling sensitive data.

- [Integration](https://github.com/checkout/frames-ios/blob/main/.github/partial-readmes/Integration.md): _a guide for consuming our SDK in your iOS app_

- [Get started](https://github.com/checkout/frames-ios/blob/main/.github/partial-readmes/GetStarted.md): _Start testing what you can achieve by presenting inside your Applications UI_ 

- [Make it your own](https://github.com/checkout/frames-ios/blob/main/.github/partial-readmes/MakeItYourOwn.md): _Customising the UI to become a part of your app_

- [Other features](https://github.com/checkout/frames-ios/blob/main/.github/partial-readmes/OtherFeatures.md): _How we help with Apple Pay & 3D Secure Challenges_

- [Make a hosted security code payment](https://github.com/checkout/frames-ios/blob/main/.github/partial-readmes/SecurityCodeComponent.md): _Make a compliant saved card payment with hosted security code tokenisation_

- [Migrating](https://github.com/checkout/frames-ios/blob/main/.github/partial-readmes/Migration.md): _If you have used 3.5.x version (or lower) before_


More integration information can be found in the [Checkout Docs](https://docs.checkout.com/integrate/sdks/ios-sdk).
   
You can find the Frames API reference [on our Jazzy docs](https://checkout.github.io/frames-ios/index.html).

## Demo projects

Our sample application showcases our prebuilt UIs and how our SDK works. You can run this locally once you clone the repository (whether directly via git or with suggested integration methods).

Our demo apps also test the supported integration methods (SPM, Cocoapods), so if you're having any problems there, they should offer a working example. You will find them in the root of the repository, inside respective folders:
- iOS Example Frame (Using Cocoapods distribution)
- iOS Example Frame SPM (SPM distribution)

Once running, you will find the home screen with a number of design options. We have tried to make contrasting payment UIs to give you an idea of what can be achieved. We've also tried to write the code in the simplest way to track and understand how each UI flavour was created. Just start from `HomeViewController.swift` and follow the button actions in code (`@IBAction`) for some examples on how we achieve those UIs.
 
## Changelog

Find our CHANGELOG.md [here](https://github.com/checkout/frames-ios/blob/main/.github/CHANGELOG.md).

## Contributing

Find our guide to start contributing [here](https://github.com/checkout/frames-ios/blob/main/.github/CONTRIBUTING.md).

## Licence

Frames iOS is released under the MIT licence. [See LICENSE](https://github.com/checkout/frames-ios/blob/main/LICENSE) for details.
