# Customizing the Card View

The SDK provides a `CardViewController` that can be used to allow users to enter their card details.
You can modify the card view after the initialization.

## Customizing the fields

```swift
    let cardViewController = CardViewController(cardHolderNameState: .hidden, billingDetailsState: .hidden)
    let softBlack = UIColor(red: 34/255, green: 41/255, blue: 47/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        cardViewController.view.backgroundColor = softBlack
        customizeFields()
    }

    func customizeFields() {
        let cardView = cardViewController.cardView
        let views: [StandardInputView] = [cardView.cardNumberInputView,
                                          cardView.expirationDateInputView,
                                          cardView.cvvInputView]
        cardView.backgroundColor = softBlack
        cardView.acceptedCardLabel.textColor = .white
        views.forEach { view in
            view.layer.borderColor = UIColor.lightGray.cgColor
            view.layer.borderWidth = 2
            view.layer.cornerRadius = 10
            view.backgroundColor = softBlack
            view.textField.textColor = .white
            view.label.textColor = .white
        }
    }
```

We start by initializing a card view controller without the card holder and billing details fields.

```swift
  let cardViewController = CardViewController(cardHolderNameState: .hidden, billingDetailsState: .hidden)
```

Inside the `viewDidLoad` method, we can access the cardView `let cardView = cardViewController.cardView`.
The public properties can be modified. This allows you to add different colors and style. In the code below, we implement a dark theme.

```swift
    let views: [StandardInputView] = [cardView.cardNumberInputView,
        cardView.expirationDateInputView,
        cardView.cvvInputView]
    cardView.backgroundColor = softBlack
    cardView.acceptedCardLabel.textColor = .white
    views.forEach { view in
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 10
        view.backgroundColor = softBlack
        view.textField.textColor = .white
        view.label.textColor = .white
    }
```
