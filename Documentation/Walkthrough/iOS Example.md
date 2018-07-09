# iOS Example

A few examples are present in the repository. Let's walkthrough the example called _iOS Example_.

## Setup to launch the example

### 1 - Get sandbox account

To get a sandbox account, you need to go to the website [checkout.com](checkout.com), click on **Get sandbox** and enter your details.
Once done, you will receive an email with your public and secret key.

### 2 - Clone the repository

Clone the [repository](https://github.com/checkout/frames-ios) and open it with xcode. Replace the public key in `iOS Example/ExampleViewController` by the one received in the email.

e.g.

```swift
  let publicKey = "pk_test_03728582-062b-419c-91b5-63ac2a481e07"
```

### 3 - Setup the example backend

You can setup a quick backend to launch the demo.

> Note: The backend is meant for demo purposes.

Deploy the backend to heroku by clicking on the button below:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/checkout/mobile-sdk-backend)

Set the `SECRET_KEY` environment variable with the one received in the email and deploy the application.

Once the application is deployed, replaced the value of `baseUrl` in `iOS Example/MerchantAPIClient` by your application url.

e.g.

```swift
  let baseUrl = "https://just-a-test-2.herokuapp.com/"
```

### 4 - Launch the example

Select **iOS Example** and you can launch the example.

## Walkthrough

The _ExampleViewController_ displays a list of saved cards for a given customer.

To create the card token, you will need to instantiate the checkout API Client `CheckoutAPIClient` with
your public key. If you don't have one already, go to the checkout.com website to get a sandbox account.

```swift
    let publicKey = "pk_test_03728582-062b-419c-91b5-63ac2a481e07"
    var checkoutAPIClient: CheckoutAPIClient {
        return CheckoutAPIClient(publicKey: publicKey, environment: .sandbox)
    }
```

You can replace `pk_test_03728582-062b-419c-91b5-63ac2a481e07` by your own public key.

```swift
  let cardViewController = CardViewController(cardHolderNameState: .hidden, billingDetailsState: .normal)
```

Instantiate a `CardViewController` that will show the form to enter card details. The constructor takes two
arguments: `cardHolderNameState` and `billingDetailsState`. You can specified if you want to include those fields
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
get the list of card providers that you set in the hub.

The controller must conform to the delegate `CardViewControllerDelegate`.

```swift
class MainViewController: UIViewController, CardViewControllerDelegate {
```

The delegate contains one method called `onTapDone`. This method is executed when the user tap
on the _done_ button to validate the card information. Note that in the example, the _done_ button has
been renamed _Pay_.

We instantiate a `CvvConfirmationViewController` and `ThreedsWebViewController`.
The `CvvConfirmationViewController` is a simple page to allow the user to enter
a cvv. Use a `CvvConfirmationViewControllerDelegate` to get the cvv.

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
