# Make it your own
<sub> Any customisation needs to be done before creating the ViewController. Once style is submitted to the factory, any changes done on it will not be reflected in the UI </sub>

:exclamation:**Note that building your own UI can place you in a higher band of PCI compliance. In order to remain in the lowest level of PCI compliance, we recommend using one of the UI options listed below**:exclamation:
 
In order of complexity we'll start with:


### Modify Default
In our [Get started](https://github.com/checkout/frames-ios/blob/main/.github/partial-readmes/GetStarted.md) example we have used Default Style to get something working quickly. If that was mostly what you were looking for, then you'll be happy to know that each component is mutable and you should easily be able to customise individual properties. This is also used as example in our demo projects inside `Factory.swift`, in the method `getDefaultPaymentViewController`.

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
