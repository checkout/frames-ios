# Change Log

All notable changes to this project will be documented in this file.
`checkout-sdk-ios` adheres to [Semantic Versioning](http://semver.org/).

#### 3.x Releases

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
