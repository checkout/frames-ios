import Foundation
import UIKit

/// A view controller that allows the user to enter address information.
public class AddressViewController: UIViewController,
    CountrySelectionViewControllerDelegate,
    UITextFieldDelegate {

    // MARK: - Properties

    /// Address View
    public let addressView: AddressView! = AddressView(frame: .zero)
    let countrySelectionViewController = CountrySelectionViewController()
    let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                     target: self, action: nil)
    var notificationCenter: NotificationCenter = NotificationCenter.default
    var regionCodeSelected: String?

    /// Delegate
    public weak var delegate: AddressViewControllerDelegate?

    // MARK: - Initialization

    /// Returns a newly initialized view controller with the cardholder's name and billing details
    /// state specified.
    public init(initialCountry: String, initialRegionCode: String? = nil) {
        self.regionCodeSelected = initialRegionCode
        super.init(nibName: nil, bundle: nil)
    }

    /// Returns a newly initialized view controller with the nib file in the specified bundle.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Foundation.Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    /// Called after the controller's view is loaded into memory.
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CheckoutTheme.primaryBackgroundColor
        view.addSubview(addressView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(onTapDoneButton))
        navigationItem.rightBarButtonItem?.isEnabled = false
        // add gesture recognizer
        addressView.countryRegionTapGesture.addTarget(self, action: #selector(onTapCountryRegionView))
        addressView.countryRegionInputView.addGestureRecognizer(addressView.countryRegionTapGesture)
        countrySelectionViewController.delegate = self
        addTextFieldsDelegate()

        if let regionCodeSelectedUnwrap = regionCodeSelected {
            let countryName = Locale.current.localizedString(forRegionCode: regionCodeSelectedUnwrap)
            if let countryNameUnwrap = countryName {
                setCountrySelected(country: countryNameUnwrap, regionCode: regionCodeSelectedUnwrap)
            }
        }
        self.navigationController?.navigationBar.isTranslucent = false
        
        validateFieldsValues()
    }

    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "addressViewControllerTitle".localized(forClass: AddressViewController.self)
        registerKeyboardHandlers(notificationCenter: notificationCenter,
                                      keyboardWillShow: #selector(keyboardWillShow),
                                      keyboardWillHide: #selector(keyboardWillHide))
    }

    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterKeyboardHandlers(notificationCenter: notificationCenter)
    }

    /// Called to notify the view controller that its view has just laid out its subviews.
    public override func viewDidLayoutSubviews() {
        view.addSubview(addressView)
        addressView.translatesAutoresizingMaskIntoConstraints = false
        addressView.leftAnchor.constraint(equalTo: view.safeLeftAnchor).isActive = true
        addressView.rightAnchor.constraint(equalTo: view.safeRightAnchor).isActive = true
        addressView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        addressView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        if #available(iOS 11.0, *) {} else {
            addressView.scrollView.contentSize = CGSize(width: self.view.frame.width,
                                                        height: self.view.frame.height + 10)
        }
    }

    // MARK: - Methods

    @objc func keyboardWillShow(notification: NSNotification) {
        scrollViewOnKeyboardWillShow(notification: notification,
                                          scrollView: addressView.scrollView,
                                          activeField: nil)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollViewOnKeyboardWillHide(notification: notification, scrollView: addressView.scrollView)
    }

    @objc func onTapCountryRegionView() {
        navigationController?.pushViewController(countrySelectionViewController, animated: true)
    }

    @objc func onTapDoneButton() {
        let countryCode = "\(addressView.phoneInputView.phoneNumber?.countryCode ?? 44)"
        let phone = CkoPhoneNumber(countryCode: countryCode,
                                   number: addressView.phoneInputView.nationalNumber)
        let address = CkoAddress(addressLine1: addressView.addressLine1InputView.textField.text,
                                 addressLine2: addressView.addressLine2InputView.textField.text,
                                 city: addressView.cityInputView.textField.text,
                                 state: addressView.stateInputView.textField.text,
                                 zip: addressView.zipInputView.textField.text,
                                 country: regionCodeSelected)
        delegate?.onTapDoneButton(controller: self, address: address, phone: phone)
    }

    private func addTextFieldsDelegate() {
        addressView.addressLine1InputView.textField.delegate = self
        addressView.addressLine2InputView.textField.delegate = self
        addressView.cityInputView.textField.delegate = self
        addressView.stateInputView.textField.delegate = self
        addressView.zipInputView.textField.delegate = self
        addressView.phoneInputView.textField.delegate = self
    }

    private func validateFieldsValues() {
        // required values are not nil
        guard
            let countryRegion = regionCodeSelected,
            let streetAddress = addressView.addressLine1InputView.textField.text,
            let postalTown = addressView.cityInputView.textField.text,
            let zip = addressView.zipInputView.textField.text
            else {
                navigationItem.rightBarButtonItem?.isEnabled = false
                return
        }

        // check phone number is valid
        guard !addressView.phoneInputView.nationalNumber.isEmpty else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        if !addressView.phoneInputView.isValidNumber {
            let message = "phoneNumberInvalid".localized(forClass: AddressViewController.self)
            addressView.phoneInputView.showError(message: message)
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        } else {
            addressView.phoneInputView.hideError()
        }

        // required values are not empty, and phone number is valid
        if
            countryRegion.isEmpty ||
            streetAddress.isEmpty ||
            postalTown.isEmpty ||
            zip.isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = false
                return
        }

        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    public func setCountrySelected(country: String, regionCode: String) {
        validateFieldsValues()
        regionCodeSelected = regionCode
        addressView.countryRegionInputView.value.text = country
    }

    // MARK: - CountrySelectionViewControllerDelegate

    /// Executed when an user select a country.
    public func onCountrySelected(country: String, regionCode: String) {
        setCountrySelected(country: country, regionCode: regionCode)
    }

    // MARK: - UITextFieldDelegate

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        validateFieldsValues()
    }

    public func setFields(address: CkoAddress, phone: CkoPhoneNumber) {
        addressView.addressLine1InputView.textField.text = address.addressLine1
        addressView.addressLine2InputView.textField.text = address.addressLine2
        addressView.cityInputView.textField.text = address.city
        addressView.stateInputView.textField.text = address.state
        addressView.zipInputView.textField.text = address.zip
        addressView.countryRegionInputView.value.text = address.country
        addressView.phoneInputView.textField.text = "+\(phone.countryCode ?? "")\(phone.number ?? "")"
    }

}
