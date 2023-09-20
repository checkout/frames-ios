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
