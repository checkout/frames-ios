//
//  ViewController.swift
//  iOS Example Frame
//
//  Created by Floriel Fedry on 11/06/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import UIKit
import Frames
import Checkout

class MainViewController: UIViewController, CardViewControllerDelegate, ThreedsWebViewControllerDelegate {

    @IBOutlet weak var goToPaymentPageButton: UIButton!
    @IBOutlet weak var createTokenWithApplePay: UIButton!
    @IBOutlet weak var threeDSURLTextField: UITextField!

    private static let successURL = URL(string: "https://httpstat.us/200")!
    private static let failureURL = URL(string: "https://httpstat.us/403")!

    private static let countryGB = Country.from(iso3166Alpha2: "GB")!
    
    // Step1 : create instance of CheckoutAPIService
    let checkoutAPIService = Frames.CheckoutAPIService(publicKey: "pk_test_6e40a700-d563-43cd-89d0-f9bb17d35e73",
                                                       environment: .sandbox)
    var cardViewController: CardViewController?

    // MARK: View Methods.

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeNavigationBarAppearance()
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        cardViewController?.addressViewController.setCountrySelected(country: Self.countryGB)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIFont.loadAllCheckoutFonts
        setupCardViewController()
    }

    private func setupCardViewController(){
        let cardFormData = defaultCardFormData()
        cardViewController = createCardViewController(checkoutAPIService: checkoutAPIService,
                                                      billingFormData: cardFormData.billingForm,
                                                      billingFormStyle: cardFormData.billingFormStyle)
        cardViewController?.delegate = self
    }

    // MARK: IBAction Methods.

    @IBAction private func goToDefaultUIPaymentPage(_ sender: Any) {

        let cardFormData = defaultCardFormData()
        cardViewController = createCardViewController(checkoutAPIService: checkoutAPIService,
                                                      billingFormData: cardFormData.billingForm,
                                                      billingFormStyle: cardFormData.billingFormStyle)
        cardViewController?.isNewUI = true
        cardViewController?.availableSchemes = [.visa, .mastercard, .maestro]
        pushCardViewController(cardViewController: cardViewController)
    }

    @IBAction private func goToCustom1PaymentPage(_ sender: Any) {

        let billingFormCustom1Style = BillingFormCustom1Style()
        let address = Address(addressLine1: "Test line1 Custom 1",
                              addressLine2: nil,
                              city: "London Custom 1",
                              state: "London Custom 1",
                              zip: "N12345",
                              country: Self.countryGB)

        let phone = Phone(number: "77 1234 1234",
                          country: Self.countryGB)
        let name = "User Custom 1"

        let billingForm = BillingForm(name: name, address: address, phone: phone)

        cardViewController = createCardViewController(checkoutAPIService: checkoutAPIService,
                                                      billingFormData: billingForm,
                                                      billingFormStyle: billingFormCustom1Style)
        cardViewController?.isNewUI = true
        cardViewController?.availableSchemes = [.visa, .mastercard, .maestro]
        pushCardViewController(cardViewController: cardViewController)
    }

    @IBAction private func goToCustom2PaymentPage(_ sender: Any) {
        let billingFormStyle = BillingFormCustom2Style()
        let address = Address(addressLine1: "Test line Custom 2",
                              addressLine2: nil,
                              city: "London Custom 2",
                              state: "London Custom 2",
                              zip: "N12345",
                              country: Self.countryGB)

        let phone = Phone(number: "77 1234 1234",
                          country: Self.countryGB)
        let name = "User Custom 2"

        let billingForm = BillingForm(name: name, address: address, phone: phone)

        cardViewController = createCardViewController(checkoutAPIService: checkoutAPIService,
                                                      billingFormData: billingForm,
                                                      billingFormStyle: billingFormStyle)
        cardViewController?.isNewUI = true
        cardViewController?.availableSchemes = [.visa, .mastercard, .maestro]
        pushCardViewController(cardViewController: cardViewController)
    }

    @IBAction private func goToPaymentPage(_ sender: Any) {
        cardViewController?.isNewUI = false
        pushCardViewController(cardViewController: cardViewController)
    }

    @IBAction private func onClickGoTokenWithApplePay(_ sender: Any) {

        // Use example Apple Pay payment data.
        guard let paymentDataURL = Bundle.main.url(
                forResource: "example_apple_pay_payment_data",
                withExtension: "json") else {
            print("Unable to get URL of Apple Pay payment data.")
            return
        }

        let paymentData: Data
        do {
            paymentData = try Data(contentsOf: paymentDataURL)
        } catch {
            print(error.localizedDescription)
            return
        }

        // Potential Task: public struct ApplePay in Checkout SDK needs a public init othwerwise will be treated as internal
        let applePay = ApplePay(tokenData: paymentData)

        checkoutAPIService.createToken(.applePay(applePay)) { status in
            switch status {
            case .failure(let error):
                self.showAlert(with: error.localizedDescription)
            case .success(let tokenDetails):
                self.showAlert(with: tokenDetails.token)
            }
        }
    }

    @IBAction private func onStart3DS(_ sender: Any) {
        guard let threeDSURLString = threeDSURLTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let threeDSURL = URL(string: threeDSURLString) else {
            showAlert(with: "3DS URL could not be parsed")
            return
        }

        let threedsWebViewController = ThreedsWebViewController(successUrl: Self.successURL, failUrl: Self.failureURL)
        threedsWebViewController.delegate = self
        threedsWebViewController.url = threeDSURL.absoluteString

        present(threedsWebViewController, animated: true, completion: nil)
    }

    // MARK: Private Methods.

    private func pushCardViewController(cardViewController: CardViewController?) {
        if let cardViewController = cardViewController {
            navigationController?.pushViewController(cardViewController, animated: true)
        }
    }

    private func showAlert(with cardToken: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Payment",
                                          message: cardToken, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func createCardViewController(checkoutAPIService: Frames.CheckoutAPIService,
                                          billingFormData: BillingForm,
                                          cardHolderNameState: InputState = .normal,
                                          billingDetailsState: InputState = .required,
                                          billingFormStyle: BillingFormStyle,
                                          defaultRegionCode: String = "GB") -> CardViewController {

        let viewController = CardViewController(checkoutAPIService: checkoutAPIService,
                                                billingFormData: billingFormData,
                                                cardHolderNameState: .normal,
                                                billingDetailsState: .required,
                                                billingFormStyle: billingFormStyle,
                                                defaultRegionCode: defaultRegionCode)

        viewController.delegate = self

        if let billingFormAddress = viewController.billingFormData?.address,
           let billingFormPhone = viewController.billingFormData?.phone {
            viewController.addressViewController.setFields(address: billingFormAddress, phone: billingFormPhone)
        }
        viewController.rightBarButtonItem = UIBarButtonItem(title: "Pay", style: .done, target: nil, action: nil)
        viewController.setDefault(regionCode: defaultRegionCode)
        return viewController
    }

    private func defaultCardFormData() -> (billingFormStyle: BillingFormStyle, billingForm : BillingForm) {

        let billingFormStyle = BillingFormFactory.defaultBillingFormStyle
        let address = Address(addressLine1: "Test line1",
                              addressLine2: nil,
                              city: "London",
                              state: "London",
                              zip: "N12345",
                              country: Self.countryGB)

        let phone = Phone(number: "77 1234 1234",
                          country: Self.countryGB)
        let name = "User 1"

        let billingForm = BillingForm(name: name, address: address, phone: phone)

        return (billingFormStyle, billingForm)
    }

    // MARK: CardViewControllerDelegate Methods.

    func onSubmit(controller: CardViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func onTapDone(controller: CardViewController, result: Result<TokenDetails, TokenisationError.TokenRequest>) {

        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }

        switch result {
        case .success(let cardToken):

            // **** For testing only. ****
            print("addressLine1 : \(cardToken.billingAddress?.addressLine1 ?? "")")
            print("addressLine2 : \(cardToken.billingAddress?.addressLine2 ?? "")")
            print("countryCode \(cardToken.phone?.countryCode ?? "")")
            print("phone number \(cardToken.phone?.number ?? "")")
            // **** For testing only. ****

            self.showAlert(with: cardToken.token)

        case .failure:
            print("failure")
        }
    }

    // MARK: ThreedsWebViewControllerDelegate Methods.

    func threeDSWebViewControllerAuthenticationDidSucceed(_ threeDSWebViewController: ThreedsWebViewController, token: String?) {
        showAlert(with: "3DS success, token: \(token ?? "nil")")
    }

    func threeDSWebViewControllerAuthenticationDidFail(_ threeDSWebViewController: ThreedsWebViewController) {
        showAlert(with: "3DS Fail")
    }
}

extension UIViewController {
    func customizeNavigationBarAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = .white
            appearance.shadowImage = UIImage()
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }

        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
}
