## Usage

### Importing the library

```swift
import FramesIos
```

Two classes are available globally: `CheckoutAPIClient` and `CardUtils`.
`CheckoutAPIClient` is used to call the Checkout API with your public key.
`CardUtils` contains methods to use for handling a payment form.

### Instantiate `CheckoutAPIClient`

```swift
let checkoutAPIClient = CheckoutAPIClient(publicKey: "pk_......", environment: .live)
```

### Get the list of card providers

```swift
let checkoutAPIClient = CheckoutAPIClient(publicKey: "pk_......", environment: .live)
checkoutAPIClient.getCardProviders(successHandler: { cardProviders in
    // success
}, errorHandler: { error in
    // error
})
```

The success handler takes an array of `CardProvider` as a parameter.
The error handler takes an `ErrorResponse` as a parameter.

### Create a card token

```swift
let checkoutAPIClient = CheckoutAPIClient(publicKey: "pk_......", environment: .live)
// create the phone number
let phoneNumber = CkoPhoneNumber(countryCode:number:)
// create the address
let address = CkoAddress(name:addressLine1:addressLine2:city:state:postcode:country:phone:)
// create the card token request
let cardTokenRequest = CkoCardTokenRequest(number:expiryMonth:expiryYear:cvv:name:billingAddress:)
checkoutAPIClient.createCardToken(card: cardTokenRequest, successHandler: { cardTokenResponse in
    // success
}, errorHandler { error in
    // error
})
```

The success handler takes an array of `CkoCardTokenResponse` as a parameter.
The error handler takes an `ErrorResponse` as a parameter.

### Getting the type of a card number

You can get the `CardType` of a card number.

```swift
let cardUtils = CardUtils()

let cardNumber = "4242424242424242"
let cardType = cardUtils.getTypeOf(cardNumber: cardNumber)
```

### Formatting a card number

You can format the card number based on the card type (e.g. Visa card: 4242 4242 4242 4242).

```swift
let cardUtils = CardUtils()

let cardNumber = "4242424242424242"
let cardType = cardUtils.getTypeOf(cardNumber: cardNumber)
let cardNumberFormatted = cardUtils.format(cardNumber: cardNumber, cardType: cardType)
print(cardNumberFormatted) // 4242 4242 4242 4242
```

### Standardize a card number

You can transform a card number by removing any non digits characters and spaces.

```swift
let cardUtils = CardUtils()

let cardNumber = "4242 | 4242 | 4242 | 4242 "
let cardNumberStandardized = cardUtils.standardize(cardNumber: cardNumber)
print(cardNumberStandardized) // "4242424242424242"
```

### Validate a card number

You can validate a card number.

```swift
let cardNumber = "4242424242424242"
let cardUtils = CardUtils()
let isCardValid = cardUtils.isValid(cardNumber: cardNumber)
print(isCardValid) // true
```
