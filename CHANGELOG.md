# Change Log

All notable changes to this project will be documented in this file.
`checkout-sdk-ios` adheres to [Semantic Versioning](http://semver.org/).

#### 4.x Releases

## [4.0.4](https://github.com/checkout/frames-ios/releases/tag/4.0.4)

Released on 2023-01-05

Updates:

- Mapped the `scheme_local` property from the /tokens endpoint via the SDK (NAS keys only)
- Handles cartes_bancaires and mada strings in `scheme` property returned from /tokens endpoint
- Passing new error type `userCancelled` in completion handler for tokenisation journey

## [4.0.3](https://github.com/checkout/frames-ios/releases/tag/4.0.3)

Released on 2022-12-04

Updates
- Fix Cocoapods resources in AppStore archive [Fix]

## [4.0.2](https://github.com/checkout/frames-ios/releases/tag/4.0.2)

Released on 2022-11-25

Updates
- Fix Security Code input issue with leading zeros [Fix]
- Improved phone number validation, improving UX and input handling [Enhancement]

All SDK integrators desiring the new SDK should use 4.0.2 onwards, as it fixes some known bugs with 4.0.1.

## [4.0.1](https://github.com/checkout/frames-ios/releases/tag/4.0.1)

Released on 2022-11-08

Updates
- Fix Apple Pay token type [Fix]
- Fix some typos and cleaned up code [Fix]
- Font can now be set within the Theme [Fix]
- Improved efficiency of our 3DSWebView [Enhancement]
- Enabled host app to use its own navigation controller [Enhancement]

All SDK integrators desiring the new SDK should use 4.0.1 onwards, as it fixes some known bugs with 4.0.0.

## [4.0.0](https://github.com/checkout/frames-ios/releases/tag/4.0.0)

Released on 2022-10-19

1. Improved validation and tokenisation logic
2. Fully updated customisation, to be in line with your app experience
3. More secure UIs that protect your customers

Version causes breaking changes. Please check our ReadMe for latest integration advice.

#### 3.x Releases

## [3.5.2](https://github.com/checkout/frames-ios/releases/tag/3.5.2)

Released on 2021-11-04.

#### Fixed

* Issue where `ThreedsWebViewControllerDelegate` callback methods were called twice per 3DS flow

## [3.5.1](https://github.com/checkout/frames-ios/releases/tag/3.5.1)

Released on 2021-10-19.

#### Fixed

* `Localizable.strings` issue when used with Cocoapods as a static library.
* Compilation issue for simulator release builds with Swift Package Manager.

## [3.5.0](https://github.com/checkout/frames-ios/releases/tag/3.5.0)

Released on 2021-09-29.

#### Added

* New delegate methods on `ThreedsWebViewControllerDelegate` to receive `token`

## [3.4.4](https://github.com/checkout/frames-ios/releases/tag/3.4.4)

Released on 2021-08-25.

#### Fixed

* Card token request serialization.

### Removed

* Support for i386 architecture.

## [3.4.3](https://github.com/checkout/frames-ios/releases/tag/3.4.3)

Released on 2021-06-24.

#### Fixed

* Cocoapods build issues that blocked release
* Billing address showing up nil inside CkoCardTokenResponse
* iOS Custom Example project crash while creating token

## [3.4.2](https://github.com/checkout/frames-ios/releases/tag/3.4.2)

Released on 2021-05-10.

#### Fixed

* App Store distribution issues for Carthage apps that use Frames and PhoneNumberKit.

## [3.4.1](https://github.com/checkout/frames-ios/releases/tag/3.4.1)

Released on 2021-04-13.

#### Fixed

* All resources now load with Swift Package Manager.
* Carthage distribution now fixed.

## [3.4.0](https://github.com/checkout/frames-ios/releases/tag/3.4.0)

Released on 2021-03-31.

#### Added

* User-agent for requests.

#### Fixed

* Response objects are now decoded properly using snake case.
* Distribution via Swift Package Manager is now fixed.

### Removed
* PhoneNumberKit source files have been removed, which were embedded in the framework. This includes `CKOPhoneNumberKit`. PhoneNumberKit is now referenced from the Podspec and Swift Package Manager configuration.

## [3.3.0](https://github.com/checkout/frames-ios/releases/tag/3.3.0)

Released on 2021-02-24.

#### Added

* New option on `CheckoutTheme` to change the chevron color.

## [3.2.0](https://github.com/checkout/frames-ios/releases/tag/3.2.0)

Released on 2021-01-13.

#### Added

* New methods that return a `NetworkError` in the completion handlers, with more details about the errors received.

#### Fixed

* Compilation issue when using `DetailsInputView` in a Storyboard file.

## [3.1.1](https://github.com/checkout/frames-ios/releases/tag/3.1.1)

Released on 2020-10-30.

#### Fixed

* Remove update.sh file from PhoneNumberKit to prevent validation failures.

## [3.1.0](https://github.com/checkout/frames-ios/releases/tag/3.1.0)

Released on 2020-10-19.

#### Changed

* Update PhoneNumberKit dependency.
* Rename PhoneNumberKit public classes to CKOPhoneNumberKit.

## [3.0.5](https://github.com/checkout/frames-ios/releases/tag/3.0.5)

Released on 2020-08-12.

#### Fixed

* Fixed a crash happening while editing phone number field

## [3.0.4](https://github.com/checkout/frames-ios/releases/tag/3.0.4)

Released on 2020-05-21.

#### Added

* Added billing address and phone number to token response

## [3.0.3](https://github.com/checkout/frames-ios/releases/tag/3.0.3)

Released on 2020-05-18.

#### Fixed

* Fix ThreedsWebViewController to support 3DS2 interceptor

## [3.0.2](https://github.com/checkout/frames-ios/releases/tag/3.0.2)

Released on 2020-01-17.

#### Fixed

* Fix CVV field keyboard localisation issue

## [3.0.1](https://github.com/checkout/frames-ios/releases/tag/3.0.1)

Released on 2019-10-30.

#### Fixed

* Make ErrorResponse properties public

## [3.0.0](https://github.com/checkout/frames-ios/releases/tag/3.0.0)

Released on 2019-10-28.

#### Fixed

* Moved to the Unified Payments API tokenisation endpoint.
* Made Swift 5 compatible


#### 2.x Releases

## [2.6.0](https://github.com/checkout/frames-ios/releases/tag/2.6.0)

Released on 2018-11-19.

#### Added

* Added a delegate method `onSubmit` that is executed when the card data is submitted to create the card token.

#### Fixed

* Fixed issue with ios 10 where the fields on the billing address screen will display only one character.
* Fixed cursor position when formatting card number and phone number input field.

## [2.5.0](https://github.com/checkout/frames-ios/releases/tag/2.5.0)

Released on 2018-11-14.

#### Modified

* Change the delegate method to not expose the card request in it.

## [2.4.0](https://github.com/checkout/frames-ios/releases/tag/2.4.0)

Released on 2018-11-08.

#### Added

* `CheckoutTheme` that will allow to modify the colors and fonts more easily.

#### Modified

* Change the names and order of the Billing details text fields.

## [2.3.0](https://github.com/checkout/frames-ios/releases/tag/2.3.0)

Released on 2018-09-18.

#### Modified

* Change the expiration date format. The expiration year is now 2 digits long (e.g. 19 for 2019).

#### Fixed

* Fixed UI Tests for iOS Custom.

## [2.2.0](https://github.com/checkout/frames-ios/releases/tag/2.2.0)

Released on 2018-07-23.

#### Added

* Error message for the phone number input field. It will invite the user to use the country code.

#### Modified

* Update localization: English, French, Spanish, German, Italian, Dutch.

---

## [2.1.0](https://github.com/checkout/frames-ios/releases/tag/2.1.0)

Released on 2018-07-13.

#### Modified

* AddressViewControllerDelegate method onTapDoneButton takes the controller as a parameter.
* CardViewControllerDelegate method onTapDone takes the controller as a parameter, which leave the navigation control out of the controller.

---

## [2.0.0](https://github.com/checkout/frames-ios/releases/tag/2.0.0)

Released on 2018-07-09.

#### Added

* Initial release of FramesIos.
