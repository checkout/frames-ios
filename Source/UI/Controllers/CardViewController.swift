import Foundation
import UIKit
import CheckoutEventLoggerKit
import Checkout

/// A view controller that allows the user to enter card information.
public class CardViewController: UIViewController,
    AddressViewControllerDelegate,
    CardNumberInputViewDelegate,
    CvvInputViewDelegate,
    UITextFieldDelegate {

    // MARK: - Properties

    /// Card View
    public let cardView: CardView
    let cardUtils = CardUtils()

    public let checkoutAPIService: CheckoutAPIService?

    let cardHolderNameState: InputState
    let billingDetailsState: InputState

    public var billingDetailsAddress: Address?
    public var billingDetailsPhone: Phone?
    var notificationCenter = NotificationCenter.default
    public let addressViewController: AddressViewController

    /// List of available schemes
    /// Potential Task : rename amex , diners in checkout sdk keep it sync with frames scheme names
    public var availableSchemes: [Card.Scheme] = [.visa, .mastercard, .amex,
                                                 .diners, .discover, .jcb]

    /// Delegate
    public weak var delegate: CardViewControllerDelegate?

    // Scheme Icons
    private var lastSelected: UIImageView?

    /// Right bar button item
    public var rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                    target: self,
                                                    action: #selector(onTapDoneCardButton))

    var topConstraint: NSLayoutConstraint?

    private var suppressNextLog = false

    // MARK: - Initialization

    /// Returns a newly initialized view controller with the cardholder's name and billing details
    /// state specified. You can specified the region using the Iso2 region code ("UK" for "United Kingdom")
    public init(checkoutAPIService: CheckoutAPIService,
                cardHolderNameState: InputState,
                billingDetailsState: InputState, defaultRegionCode: String? = nil) {
        self.checkoutAPIService = checkoutAPIService
        self.cardHolderNameState = cardHolderNameState
        self.billingDetailsState = billingDetailsState
        cardView = CardView(cardHolderNameState: cardHolderNameState, billingDetailsState: billingDetailsState)
        addressViewController = AddressViewController(initialCountry: "you", initialRegionCode: defaultRegionCode)
        super.init(nibName: nil, bundle: nil)
    }

    /// Returns a newly initialized view controller with the nib file in the specified bundle.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Foundation.Bundle?) {
        cardHolderNameState = .required
        billingDetailsState = .required
        cardView = CardView(cardHolderNameState: cardHolderNameState, billingDetailsState: billingDetailsState)
        addressViewController = AddressViewController()
        checkoutAPIService = nil
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        cardHolderNameState = .required
        billingDetailsState = .required
        cardView = CardView(cardHolderNameState: cardHolderNameState, billingDetailsState: billingDetailsState)
        addressViewController = AddressViewController()
        checkoutAPIService = nil
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    /// Called after the controller's view is loaded into memory.
    override public func viewDidLoad() {
        super.viewDidLoad()
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(onTapDoneCardButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.rightBarButtonItem?.isEnabled = false
        // add gesture recognizer
        cardView.addressTapGesture.addTarget(self, action: #selector(onTapAddressView))
        cardView.billingDetailsInputView.addGestureRecognizer(cardView.addressTapGesture)

        addressViewController.delegate = self
        addTextFieldsDelegate()

        // add schemes icons
        view.backgroundColor = .groupTableViewBackground
        cardView.schemeIconsStackView.setIcons(schemes: availableSchemes)
        setInitialDate()

        self.automaticallyAdjustsScrollViewInsets = false
    }

    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "cardViewControllerTitle".localized(forClass: CardViewController.self)
        registerKeyboardHandlers(notificationCenter: notificationCenter,
                                 keyboardWillShow: #selector(keyboardWillShow),
                                 keyboardWillHide: #selector(keyboardWillHide))
        
        if suppressNextLog {
            suppressNextLog = false
        } else {
            guard let checkoutAPIService = checkoutAPIService else {
                return
            }
// Potential Task : add correlationID and logger to checkoutAPIService or Frames
//          checkoutAPIService.logger.add(metadata: checkoutAPIService.correlationID(),
//                                          forKey: .correlationID)
//          checkoutAPIService.logger.log(.paymentFormPresented)
        }
    }

    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterKeyboardHandlers(notificationCenter: notificationCenter)
    }

    /// Called to notify the view controller that its view has just laid out its subviews.
    public override func viewDidLayoutSubviews() {
        view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.leftAnchor.constraint(equalTo: view.safeLeftAnchor).isActive = true
        cardView.rightAnchor.constraint(equalTo: view.safeRightAnchor).isActive = true

        self.topConstraint = cardView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)
        if #available(iOS 11.0, *) {
            cardView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        } else {
            self.topConstraint?.isActive = true
        }
        cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {} else {
            cardView.scrollView.contentSize = CGSize(width: self.view.frame.width,
                                                        height: self.view.frame.height + 10)
        }

    }

    /// MARK: Methods
    public func setDefault(regionCode: String) {
        addressViewController.regionCodeSelected = regionCode
    }

    private func setInitialDate() {
        let calendar = Calendar(identifier: .gregorian)
        let date = Date()
        let month = calendar.component(.month, from: date)
        let year = String(calendar.component(.year, from: date))
        let monthString = month < 10 ? "0\(month)" : "\(month)"
        let subYearIndex = year.index(year.startIndex, offsetBy: 2)
        cardView.expirationDateInputView.textField.text =
            "\(monthString)/\(year[subYearIndex...year.index(subYearIndex, offsetBy: 1)])"
    }

    @objc func onTapAddressView() {
        navigationController?.pushViewController(addressViewController, animated: true)
        // add  let logger: FramesEventLogging to checkoutAPIService
        //checkoutApiClient?.logger.log(.billingFormPresented)
        suppressNextLog = true
    }

    @objc func onTapDoneCardButton() {

        cardView.cardNumberInputView.hideError()
        cardView.expirationDateInputView.hideError()
        cardView.cvvInputView.hideError()
        // Potential Task: do not hardcode environment
        let cardValidator = CardValidator(environment: .sandbox)
        // Get the values
        let cardNumber = cardView.cardNumberInputView.textField.text!
        let expirationDate = cardView.expirationDateInputView.textField.text!
        let cvv = cardView.cvvInputView.textField.text!

        let cardNumberStandardized = cardNumber.standardize()

        // Validate the values

        // Validate Card Number
        switch cardValidator.validate(cardNumber: cardNumber) {
        case .success(let scheme):
            if !availableSchemes.contains(where: { scheme == $0 }) {
                let message = "cardTypeNotAccepted".localized(forClass: CardViewController.self)
                cardView.cardNumberInputView.showError(message: message)
            }
        case .failure(let error):
            switch error {
            case .invalidCharacters:
                let message = "cardNumberInvalid".localized(forClass: CardViewController.self)
                cardView.cardNumberInputView.showError(message: message)
            }
        }

        // Validate CVV
        switch cardValidator.validate(cvv: cvv) {
        case .success:
            print("success cvv validation")
        case .failure(_):
            let message = "cvvInvalid".localized(forClass: CardViewController.self)
            cardView.cvvInputView.showError(message: message)
        }

        // Potential Task : need to add standardize function to existing checkout SDK for expiry date
        let (expiryMonth, expiryYear) = cardUtils.standardize(expirationDate: expirationDate)

        // Validate Expiry Date
        var cardExpiryDate: ExpiryDate?
        switch cardValidator.validate(expiryMonth: expiryMonth, expiryYear: expiryYear) {
        case .success(let date):
            cardExpiryDate = date
        case .failure(let error):
            let message = "expiryDateInvalid".localized(forClass: CardViewController.self)
            cardView.expirationDateInputView.showError(message: message)
        }

        if !validateCardDetails(cardNumber: cardNumber, cvv: cvv).isEmpty ||
            validateCardExpiryDate(expiryMonth: expiryMonth, expiryYear: expiryYear) != nil {
            return
        }

        guard let checkoutAPIService = checkoutAPIService else {
            return
        }

        self.delegate?.onSubmit(controller: self)

        guard let cardExpiryDate = cardExpiryDate else {
            return // dont silent return
        }

        let card = Card(number: cardNumberStandardized,
                        expiryDate: cardExpiryDate,
                        name: cardView.cardHolderNameInputView.textField.text,
                        cvv: cvv, billingAddress: billingDetailsAddress,
                        phone: billingDetailsPhone)

        checkoutAPIService.createToken(.card(card)) { result in
          switch result {
          case .success(let tokenDetails):
              self.delegate?.onTapDone(controller: self, cardToken: tokenDetails, status: .success)
          case .failure(let error):
            self.delegate?.onTapDone(controller: self, cardToken: nil, status: .failure)
          }
        }
    }

    // MARK: - AddressViewControllerDelegate

    /// Executed when an user tap on the done button.
    public func onTapDoneButton(controller: AddressViewController, address: Address, phone: Phone) {
        billingDetailsAddress = address
        billingDetailsPhone = phone
        let value = "\(address.addressLine1 ?? ""), \(address.city ?? "")"
        cardView.billingDetailsInputView.value.text = value
        validateFieldsValues()
        // return to CardViewController
        self.topConstraint?.isActive = false
        controller.navigationController?.popViewController(animated: true)
    }

    private func validateCardDetails(cardNumber: String, cvv: String) -> [Error] {

        var validationError: [Error] = [Error]()
        // Potential Task: do not hardcode environment
        let cardValidator = CardValidator(environment: .sandbox)

        switch cardValidator.validate(cardNumber: cardNumber) {
        case .success(let scheme):
            print(scheme)
            switch cardValidator.validate(cvv: cvv, cardScheme: scheme) {
            case .success:
                print("success")
            case .failure(let error):
                validationError.append(error)
                return validationError
            }
        case .failure(let error):
            validationError.append(error)
            return validationError
        }
        return validationError
    }

    private func validateCardExpiryDate(expiryMonth: String, expiryYear: String) -> Error? {
        // Potential Task: do not hardcode environment
        let cardValidator = CardValidator(environment: .sandbox)
        switch cardValidator.validate(expiryMonth: expiryMonth, expiryYear: expiryYear) {
        case .success( _):
            return nil
        case .failure(let error):
            return error
        }
    }

    private func addTextFieldsDelegate() {
        cardView.cardNumberInputView.delegate = self
        cardView.cardHolderNameInputView.textField.delegate = self
        cardView.expirationDateInputView.textField.delegate = self
        cardView.cvvInputView.delegate = self
        cardView.cvvInputView.onChangeDelegate = self
    }

    private func validateFieldsValues() {
        let cardNumber = cardView.cardNumberInputView.textField.text!
        let expirationDate = cardView.expirationDateInputView.textField.text!
        let cvv = cardView.cvvInputView.textField.text!

        // check card holder's name
        if cardHolderNameState == .required && (cardView.cardHolderNameInputView.textField.text?.isEmpty)! {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        // check billing details
        if billingDetailsState == .required && billingDetailsAddress == nil {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        // values are not empty strings
        if cardNumber.isEmpty || expirationDate.isEmpty ||
            cvv.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        scrollViewOnKeyboardWillShow(notification: notification, scrollView: cardView.scrollView, activeField: nil)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollViewOnKeyboardWillHide(notification: notification, scrollView: cardView.scrollView)
    }

    // MARK: - UITextFieldDelegate

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        validateFieldsValues()
    }

    /// Tells the delegate that editing stopped for the textfield in the specified view.
    public func textFieldDidEndEditing(view: UIView) {
        validateFieldsValues()

        if let superView = view as? CardNumberInputView {
            let cardNumber = superView.textField.text!
            let cardNumberStandardized = cardNumber.standardize()
            let cardType = cardUtils.getTypeOf(cardNumber: cardNumberStandardized)
            cardView.cvvInputView.cardType = cardType
        }
    }

    // MARK: - CardNumberInputViewDelegate

    /// Called when the card number changed.
    public func onChangeCardNumber(cardType: CardType?) {
        // reset if the card number is empty
        if cardType == nil && lastSelected != nil {
            cardView.schemeIconsStackView.arrangedSubviews.forEach { $0.alpha = 1 }
            lastSelected = nil
        }
        guard let type = cardType else { return }
        let index = availableSchemes.firstIndex(of: type.scheme)
        guard let indexScheme = index else { return }
        let imageView = cardView.schemeIconsStackView.arrangedSubviews[indexScheme] as? UIImageView

        if lastSelected == nil {
            cardView.schemeIconsStackView.arrangedSubviews.forEach { $0.alpha = 0.5 }
            imageView?.alpha = 1
            lastSelected = imageView
        } else {
            lastSelected!.alpha = 0.5
            imageView?.alpha = 1
            lastSelected = imageView
        }
    }

    // MARK: CvvInputViewDelegate

    public func onChangeCvv() {
        validateFieldsValues()
    }

}
