# Frames iOS example

## Setup to launch the example

### Step 1: Create a Hub account

[Request an account](https://www.checkout.com/contact-sales) and enter your details.

Once done, you will receive an email with your log in information so you can access your Hub account. You can find your public and secret key under _Settings > Channels_.

### Step 2: Clone the repository

Clone the [repository](https://github.com/checkout/frames-ios) and open it with XCode. Replace the public key in `iOS Example/ExampleViewController` with your own.

e.g.

```swift
  let publicKey = "pk_test_03728582-062b-419c-91b5-63ac2a481e07"
```

### Step 3: Set up the example back end

You can set up a quick back end to launch the demo.

> Note: The back end is meant for demo purposes.

Deploy the back end to Heroku by selecting the button below:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/checkout/mobile-sdk-backend)

Set the `SECRET_KEY` environment variable with your own.

Once the application is deployed, replace the value of `baseUrl` in `iOS Example/MerchantAPIClient` with your application URL.

e.g.

```swift
  let baseUrl = "https://just-a-test-2.herokuapp.com/"
```

### Step 4: Launch the example

Select _iOS Example_ to launch the example.

## Walkthrough

The _ExampleViewController_ displays a list of saved cards for a given customer.

To create the card token, you will need to instantiate `CheckoutAPIClient` with
your public key. If you don't have one already, [request an account](https://www.checkout.com/contact-sales).

```swift
    let publicKey = "pk_test_03728582-062b-419c-91b5-63ac2a481e07"
    var checkoutAPIClient: CheckoutAPIClient {
        return CheckoutAPIClient(publicKey: publicKey, environment: .sandbox)
    }
```

You can replace `pk_test_03728582-062b-419c-91b5-63ac2a481e07` with your own public key.

```swift
  let cardViewController = CardViewController(cardHolderNameState: .hidden, billingDetailsState: .normal)
```

Instantiate a `CardViewController`, which will load a form to enter card details in. The constructor takes two
arguments: `cardHolderNameState` and `billingDetailsState`. You can specify whether you want to include those fields
in the form.

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup table view
        cardsTableView.register(CardListCell.self, forCellReuseIdentifier: "cardCell")
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
        cardsTableView.estimatedRowHeight = 50
        // set available schemes
        cardViewController.availableSchemes = [.visa, .mastercard]
        // set delegates
        cardViewController.delegate = self
        threeDsViewController.delegate = self
        cvvConfirmationViewController.delegate = self
        // update the card list
        updateCustomerCardList()
    }
```

We specified which schemes are allowed.
By default, all schemes are allowed (see `CardScheme`). You can also used the `CheckoutAPIClient` to
get the list of card providers that you set in the Hub.

The controller must conform to the delegate `CardViewControllerDelegate`.

```swift
class MainViewController: UIViewController, CardViewControllerDelegate {
```

The delegate contains one method called `onTapDone`. This method is executed when the user tap
on the _Done_ button to validate the card information.

> Note that in the example, the _Done_ button has been renamed _Pay_.

We instantiate a `CvvConfirmationViewController` and `ThreedsWebViewController`.
The `CvvConfirmationViewController` is a simple page to allow the user to enter
a CVV. Use a `CvvConfirmationViewControllerDelegate` to get the CVV.

The `ThreedsWebViewController` is a simple web view to allow the user to handle
3D Secure. `ThreedsWebViewControllerDelegate` contains two methods: `onSuccess3D`
and `onFailure3D` to handle the response.

```swift
    let cvvConfirmationViewController = CvvConfirmationViewController()
    // successUrl and failUrl specified in the hub
    let threeDsViewController = ThreedsWebViewController(
        successUrl: "https://github.com/checkout/just-a-test/",
        failUrl: "https://github.com/checkout/just-a-test/master/"
    )

    // called if 3dsecure is successful
    func onSuccess3D() {
        print("dismissed 😎")
    }

    // called if 3dsecure failed
    func onFailure3D() {
        print("dismissed 😢")
    }
```
