# Frames iOS
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Frames.svg)](https://img.shields.io/cocoapods/v/Frames)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/checkout/frames-ios?label=spm)

![Bitrise](https://img.shields.io/bitrise/b458eecbb0222141?token=7EWxlcgiqm8949liUxqcYA)
[![Platform](https://img.shields.io/cocoapods/p/Frames.svg?style=flat)]()
![license](https://img.shields.io/github/license/checkout/frames-ios.svg)

<div align="center">
    <img width=40% src="https://github.com/checkout/frames-ios/blob/main/screenshots/demo-frames-ios.webp?raw=true">
</div>

## Requirements

- iOS 12.0+
- Xcode 12.4+
- Swift 5.3+

 


## Documentation

Frames for iOS tokenises consumer data for use within [Checkout.com](https://www.checkout.com)'s payment infrastructure. We abstract away the complexity of taking payments, building payment UIs, and handling sensitive data.

- [Integration](#Integration): _a guide for consuming our SDK in your iOS app_

- [Demo projects](#Demo-projects): _We've created projects showcasing the range of functionality available in our SDKs while testing each distribution method offered_

- [Get started](#Get-started): _Start testing what you can achieve by presenting inside your Applications UI_ 

- [Make it your own](#Make-it-your-own): _Customising the UI to become a part of your app_

- [Other features](#Other-features): _How we help with Apple Pay & 3D Secure Challenges_

- [Migrating](#Migrating-from-3.X.X-to-4.X.X): _If you have used 3.5.x version (or lower) before_

- [License](#License)


More integration information can be found in the [Checkout Docs](https://docs.checkout.com/integrate/sdks/ios-sdk).
   
You can find the Frames API reference [on our Jazzy docs](https://checkout.github.io/frames-ios/index.html).


 


# Integration

We've done our best to support the most common distribution methods on iOS. We are in strong favour of [SPM](#Swift-Package-Manager) (Swift Package Manager) but if for any reason this doesn't work for you, we also support [Cocoapods](#Cocoapods).

### Swift Package Manager
[Swift Package Manager](https://swift.org/package-manager/) integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies. It should work out of the box on latest Xcode projects since Xcode 11 and has had a lot of community support, seeing huge adoption over the recent years. This is our preferred distribution method for Frames iOS and is the easiest one to integrate, keep updated and build around.

If you've never used it before, get started with Apple's step by step guide into [adding package dependencies to your app](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app) . Just use this repository's URL (https://github.com/checkout/frames-ios) when adding dependency.


### CocoaPods
[CocoaPods](http://cocoapods.org) is the traditional dependency manager for Apple projects. We do support it, but recommend using SPM given it is Apple's preferred dependency manager.

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

# PhoneNumberKit has stopped publishing Cocoapods releases to Public Registry
# This workaround enables application to get the releases straight from source repository 
pod 'PhoneNumberKit', :git => 'https://github.com/marmelroy/PhoneNumberKit'

target '<Your Target Name>' do
    pod 'Frames', '~> 4.0'
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


 


# Demo projects

Our sample application showcases our prebuilt UIs and how our SDK works. You can run this locally once you clone the repository (whether directly via git or with suggested integration methods).

Our demo apps also test the supported integration methods (SPM, Cocoapods), so if you're having any problems there, they should offer a working example. You will find them in the root of the repository, inside respective folders:
- iOS Example Frame (Using Cocoapods distribution)
- iOS Example Frame SPM (SPM distribution)

Once running, you will find the home screen with a number of design options. We have tried to make contrasting payment UIs to give you an idea of what can be achieved. We've also tried to write the code in the simplest way to track and understand how each UI flavour was created. Just start from `HomeViewController.swift` and follow the button actions in code (`@IBAction`) for some examples on how we achieve those UIs.




 


# Get started

This section assumes you've completed initial Integration. If you haven't, then please complete [Integration](#Integration) first.

#### 1. Import `Frames`
<sub>If unsure where to do it, the ViewController that will be presenting the journey is a good start</sub>
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
let country = Country(iso3166Alpha2: "GB")
let address = Address(
    addressLine1: "221B Baker Street",
    addressLine2: "Marylebone",
    city: "London",
    state: "London",
    zip: "NW1 6XE",
    country: country)
let phone = Phone(number: "+44 2072243688",
    country: country)
let billingFormData = BillingForm(
    name: "Amazing Customer",
    address: address,
    phone: phone)

let configuration = PaymentFormConfiguration(
    apiKey: "<Your Public Key>",
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

 
#### 4. Prepare your response from the flow completion
<sub>If the user completes flow without cancelling, the completion handler will be called, with a card token if successful, or with an error if failed</sub>
```swift
let completion: ((Result<TokenDetails, TokenRequestError>) -> Void) = { result in
    switch result {
    case .failure(let failure):
        if failure == .userCancelled {
            // Depending on needs, User Cancelled can be handled as an individual failure to complete, an error, or simply a callback that control is returned
            print("User has cancelled")
        } else {
            print("Failed, received error", failure.localizedDescription)
        }
    case .success(let tokenDetails):
        print("Success, received token", tokenDetails.token)
    }
}
```

 
#### 5. Use our `PaymentFormFactory` to generate the ViewController
<sub>Using properties from Steps 2, 3 & 4, lets now create the ViewController</sub>
```swift
let framesViewController = PaymentFormFactory.buildViewController(
    configuration: configuration, // Step 2
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


 


# Make it your own
<sub> Any customisation needs to be done before creating the ViewController. Once style is submitted to the factory, any changes done on it will not be reflected in the UI </sub>

:exclamation:**Note that building your own UI can place you in a higher band of PCI compliance. In order to remain in the lowest level of PCI compliance, we recommend using one of the UI options listed below**:exclamation:
 
In order of complexity we'll start with:


### Modify Default
In our [Get started](#Get-started) example we have used Default Style to get something working quickly. If that was mostly what you were looking for, then you'll be happy to know that each component is mutable and you should easily be able to customise individual properties. This is also used as example in our demo projects inside `Factory.swift`, in the method `getDefaultPaymentViewController`.

Example:
```swift
var paymentFormStyle = DefaultPaymentFormStyle()

// Change background of page
paymentFormStyle.backgroundColor = UIColor.darkGray

// Change card number input placeholder value
paymentFormStyle.expiryDate.textfield.placeholder = "00 / 00"

// Add custom border style around the Payment Button
if var payButton = paymentFormStyle.payButton as? DefaultPayButtonFormStyle {
  let payButtonBorder = DefaultBorderStyle(
      cornerRadius: 26,
      borderWidth: 3,
      normalColor: .black,
      focusColor: .clear,
      errorColor: .red,
      corners: [.bottomLeft, .topRight])
  payButton.borderStyle = payButtonBorder
  paymentFormStyle.payButton = payButton
}

// Change Payment button text
paymentFormStyle.payButton.text = "Pay £54.63"
```
We wouldn't recommend this approach if you're looking to override many values, since you would need to individually identify and change every property. But it can work for small tweaks.


### Use Theme
In our Demo projects we also demo this approach in `ThemeDemo.swift`. With the Theme, we are aiming to give you a design system that you can use to create the full UI style by providing a small number of properties that we will share across to sub components. Since you might not fully agree with our mapping, you can still individually change each component afterwards (as in the Modify Default example).

```swift
// Declare the theme object with the minimum required properties
var theme = Theme(
    primaryFontColor: UIColor(red: 0 / 255, green: 204 / 255, blue: 45 / 255, alpha: 1),
    secondaryFontColor: UIColor(red: 177 / 255, green: 177 / 255, blue: 177 / 255, alpha: 1),
    buttonFontColor: .green,
    errorFontColor: .red,
    backgroundColor: UIColor(red: 23 / 255, green: 32 / 255, blue: 30 / 255, alpha: 1),
    errorBorderColor: .red)

// Add border and corner radius around text inputs
theme.textInputBackgroundColor = UIColor(red: 36 / 255.0, green: 48 / 255.0, blue: 45 / 255.0, alpha: 1.0)
theme.textInputBorderRadius = 4

// Build complete payment form by providing only texts
var paymentFormStyle = theme.buildPaymentForm(
    headerView: theme.buildPaymentHeader(title: "Payment details",
                                        subtitle: "Accepting your favourite payment methods"),
    addBillingButton: theme.buildAddBillingSectionButton(text: "Add billing details",
                                                        isBillingAddressMandatory: false,
                                                        titleText: "Billing details"),
    billingSummary: theme.buildBillingSummary(buttonText: "Change billing details",
                                            titleText: "Billing details"),
    cardNumber: theme.buildPaymentInput(isTextFieldNumericInput: true,
                                        titleText: "Card number",
                                        errorText: "Please enter valid card number"),
    expiryDate: theme.buildPaymentInput(textFieldPlaceholder: "__ / __",
                                        isTextFieldNumericInput: false,
                                        titleText: "Expiry date",
                                        errorText: "Please enter valid expiry date"),
    securityCode: theme.buildPaymentInput(isTextFieldNumericInput: true,
                                        titleText: "CVV date",
                                        errorText: "Please enter valid security code"),
    payButton: theme.buildPayButton(text: "Pay now"))

// Override a custom property from the resulting payment form style
paymentFormStyle.payButton.disabledTextColor = UIColor.lightGray

let billingFormStyle = theme.buildBillingForm(
            header: theme.buildBillingHeader(title: "Billing information",
                                             cancelButtonTitle: "Cancel",
                                             doneButtonTitle: "Done"),
            cells: [.fullName(theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: false, title: "Your name")),
                    .addressLine1(theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: true, title: "Address")),
                    .city(theme.buildBillingInput(text: "", isNumericInput: false, isMandatory: true, title: "City")),
                    .country(theme.buildBillingCountryInput(buttonText: "Select your country", title: "Country")),
                    .phoneNumber(theme.buildBillingInput(text: "", isNumericInput: true, isMandatory: true, title: "Phone number"))])
```

We think this approach should hit a good balance between great control of UI & simple, concise code. The font sizes even use `preferredFont(forTextStyle: ...).pointSize` to give you font sizes that match your users device preferences. However if you still find the mapping to need excessive customisation, our final approach may be more to your liking.


### Declare all components

This is by no means the easy way, but it is absolutely the way to fully customise every property, and discover the full extent of customisability as you navigate through. You will find inside the Demo projects the files `Style.swift` and `CustomStyle1.swift` which follow this approach.

If deciding to do this, try to:

- let compiler help. Xcode's autocomplete should come in handy to help navigate from highest level into the lowest customisation option
```swift
let style = PaymentStyle(paymentFormStyle: <#T##PaymentFormStyle#>,
                        billingFormStyle: <#T##BillingFormStyle#>)
```

- protocols are the keyword. Starting from code above, the arguments will be protocol objects until the lowest level. 
```swift
// You will need to prepare your objects that conform to the required protocols
struct MyPaymentFormStyle: PaymentFormStyle {
    var backgroundColor: UIColor = ...
    var headerView: PaymentHeaderCellStyle = ...
    var editBillingSummary: BillingSummaryViewStyle? = ...
    var addBillingSummary: CellButtonStyle? = ...
    var cardholderInput: CellTextFieldStyle? = ...
    var cardNumber: CellTextFieldStyle = ...
    var expiryDate: CellTextFieldStyle = ...
    var securityCode: CellTextFieldStyle? = ...
    var payButton: ElementButtonStyle = ...
}

// Then feed them to your end PaymentStyle
let style = PaymentStyle(paymentFormStyle: MyPaymentFormStyle(),
                        billingFormStyle: <#T##BillingFormStyle#>)
```


 


# Other features
### Handle 3D Secure

When you send a 3D secure charge request from your server you will get back a 3D Secure URL. This is available from `_links.redirect.href` within the JSON response. You can then pass the 3D Secure URL to a `ThreedsWebViewController` in order to handle the verification.

The redirection URLs (`success_url` and `failure_url`) are set in the Checkout.com Hub, but they can be overwritten in the charge request sent from your server. It is important to provide the correct URLs to ensure a successful payment flow.

Lets imagine we are now working inside `YourViewController.swift` and we are handling the 3DS challenge:

```swift
// Ensure you know the fail & success URLs
private enum Constants {
    static let successURL = URL(string: "http://example.com/success")!
    static let failureURL = URL(string: "http://example.com/failure")
}

// Prepare the service
let checkoutAPIService = CheckoutAPIService(publicKey: "<Your Public Key>", environment: .sandbox)

// Create the ThreedsWebViewController
let threeDSWebViewController = ThreedsWebViewController(
    checkoutAPIService: checkoutAPIService,
    // If the payment response provided new success_url or failure_url, use those. Otherwise default to Checkout provided values as documented previously
    successUrl: serverOverridenSuccessURL ?? Constants.successURL,
    failUrl: serverOverridenFailureURL ?? Constants.failureURL)
threeDSWebViewController.delegate = self
threeDSWebViewController.authURL = challengeURL // This is coming from the payment response

// Present threeDSWebViewController
present(threeDSWebViewController, animated: true, completion: nil)
```

Previously we have added the line `threeDSWebViewController.delegate = self`. This will raise compiler error as we now need to have `YourViewController` conform to the required protocol. Doing this, we are able to find the outcome of the challenge and react accordingly
```swift
extension YourViewController: ThreedsWebViewControllerDelegate {
    func threeDSWebViewControllerAuthenticationDidSucceed(_ threeDSWebViewController: ThreedsWebViewController, token: String?) {
        
        // Congratulations, the Challenge was successful !

        threeDSWebViewController.dismiss(animated: true, completion: nil)
    }

    func threeDSWebViewControllerAuthenticationDidFail(_ threeDSWebViewController: ThreedsWebViewController) {
        
        // Oooops, the payment failed !
        
        threeDSWebViewController.dismiss(animated: true, completion: nil)
    }
}
```


### Using Apple Pay

We are able to handle `PKPayment` token data from Apple Pay, which translates an Apple Pay token into a Checkout.com token for you to pay with from your backend.

```swift
// Prepare the service
let checkoutAPIService = CheckoutAPIService(publicKey: "<Your Public Key>", environment: .sandbox)

func handle(payment: PKPayment) {
    // Get the data containing the encrypted payment information.
    let paymentData = payment.token.paymentData

    // Request an Apple Pay token.
    checkoutAPIService.createToken(.applePay(ApplePay(paymentData))) { result in
        switch result {
        case .success(let tokenDetails):
            // Congratulations, payment token is available
        case .failure(let error):
            // Ooooops, an error ocurred. Check `error.localizedDescription` for hint to what went wrong
        }
    }
}
```


### Phone number validation

Billing address phone number validation will use the device local to set the prefix of the phone number. For example, a UK number will be automatically prefixed with +44.

If users want to enter a phone number that differs from their device local (i.e. a US number when their device local is set up for the UK), they should first provide the country code (e.g. +1) when entering the phone number.


 


# Migrating from 3.X.X to 4.X.X 
3DS and Apple Pay processing remain unaffected so using them should still work the same. 

If you're using Frames iOS from versions prior to v4 (we would strongly recommend using the latest release), this update will bring breaking changes that'll require a little development time.

Because of our efforts to greatly improve the UI of the Frames and enabling you to customise it to such extents, the approach required is very different. This will require you to:
- remove usage of Frames older version from your code base. This may be an opportunity to remove a screen as well, or a few other objects that were created only to support older Frames integration!
- [Get started](#Get-started)


We would like to point out the great benefits that we think v4+ brings to our SDK, like:

- customisable UI focussed on enabling your users to seamlessly transition through the payment flow
- updated and improved validation logic, in line with our supported card payment methods
- using our updated UIs provides added security benefits to your customers


 


## License

Frames iOS is released under the MIT license. [See LICENSE](https://github.com/checkout/frames-ios/blob/main/LICENSE) for details.
