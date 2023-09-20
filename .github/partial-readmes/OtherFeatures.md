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
