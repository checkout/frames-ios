## Make a payment with a hosted security code 
Use our security code component to make a compliant saved card payment in regions where sending a security code is always mandatory. 

Within this flow, we will securely tokenise the security code and return a security code token to your application layer, which you can then use to continue the payment flow with.

### Step 1: Initialise the configuration

```swift
var configuration = SecurityCodeComponentConfiguration(apiKey: "PUBLIC_KEY",                        // set your public key
                                                       environment: Frames.Environment.sandbox)     // set the environment
```

### Step 2: Create a UIView

Either create a UIView on storyboard and define the `Custom Class` and `Module` like below and create an `IBOutlet` in the code counterpart:

<img width="727" alt="Screenshot 2023-11-06 at 11 46 34" src="https://github.com/checkout/frames-ios/assets/125963311/ee19b1f8-f3eb-47ee-a20a-e328bdba7001">

Or, create it programmatically:

```swift
let securityCodeView = SecurityCodeComponent()
securityCodeView.frame = parentView.bounds
parentView.addSubview(securityCodeView)
```

### Step 3: Style the component

Since we are using a secure display view, it shouldn't be possible to edit the properties of the inner text field. Hence, we provide the `SecurityCodeComponentStyle` type for it to be configured. Other than text style, all the other things can be configured like any other `UIView`s.

Security code view has a `clear` background by default.

```swift
    let style = SecurityCodeComponentStyle(text: .init(),
                                           font: UIFont.systemFont(ofSize: 24),
                                           textAlignment: .natural,
                                           textColor: .red,
                                           tintColor: .red,
                                           placeholder: "Enter here")
configuration.style = style
```

### Step 4: Inject an optional card scheme for granular security code validation

If you don't define a card scheme, then all 3 and 4 digit security codes are considered valid for all card schemes. So, you won't utilise the early rejection from SDK level but will get the error from the API level if you don't define a card scheme. If the CVV is length 0, the SDK will throw a validation error when calling `createToken` independent from the injected card scheme.

```swift
configuration.cardScheme = Card.Scheme(rawValue: "VISA") // or you can directly use `Card.Scheme.visa`. You should be getting the scheme name string values from your backend.
```

### Step 5: Call the configure method

```swift
securityCodeView.configure(with: configuration) { [weak self] isSecurityCodeValid in
  DispatchQueue.main.async {
    self?.payButton.isEnabled = isSecurityCodeValid 
  }  
 }
```

### Step 6: Create a security code token
```swift
securityCodeView.createToken { [weak self] result in
  DispatchQueue.main.async {
      switch result {
      case .success(let tokenDetails):
        self?.showAlert(with: tokenDetails.token, title: "Success")

      case .failure(let error):
        self?.showAlert(with: error.localizedDescription, title: "Failure")
      }
   }
}
```

You can then continue the payment flow with this `token` by passing into a field name as `cvv` in the payment request. 
