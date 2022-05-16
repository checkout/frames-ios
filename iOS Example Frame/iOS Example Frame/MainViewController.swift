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
    
    // Step1 : create instance of CheckoutAPIService
    let checkoutAPIService = Frames.CheckoutAPIService(publicKey: "pk_test_6e40a700-d563-43cd-89d0-f9bb17d35e73",
                                                       environment: .sandbox)

    @IBAction func goToPaymentPage(_ sender: Any) {
        cardViewController.isNewUI = false
        navigationController?.pushViewController(cardViewController, animated: true)
    }
    
    @IBAction func goToNewPaymentPage(_ sender: Any) {
        cardViewController.isNewUI = true
        navigationController?.pushViewController(cardViewController, animated: true)
    }


    func onSubmit(controller: CardViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    lazy var cardViewController: CardViewController = {
        let b = CardViewController(checkoutAPIService: checkoutAPIService, cardHolderNameState: .normal, billingDetailsState: .required, defaultRegionCode: "GB")
        b.billingDetailsAddress = Address(addressLine1: "Test line1", addressLine2: "Test line2", city: "London", state: "London", zip: "N12345", country: Country.allAvailable.first { $0.iso3166Alpha2 == "GB" })
        b.billingDetailsPhone = Phone(number: "77 1234 1234",
                                      country: Country.allAvailable.first { $0.iso3166Alpha2 == "GB" })
        b.delegate = self
        b.addressViewController.setFields(address: b.billingDetailsAddress!, phone: b.billingDetailsPhone!)
        return b
    }()

    @IBAction func onClickGoToPaymentPage(_ sender: Any) {
        navigationController?.pushViewController(cardViewController, animated: true)
    }

    @IBAction func onClickGoTokenWithApplePay(_ sender: Any) {
        
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cardViewController.delegate = self
        cardViewController.rightBarButtonItem = UIBarButtonItem(title: "Pay", style: .done, target: nil, action: nil)
        cardViewController.availableSchemes = [.visa, .mastercard, .maestro]
        cardViewController.setDefault(regionCode: "GB")
    }

    override func viewDidAppear(_ animated: Bool) {
        cardViewController.addressViewController.setCountrySelected(country: "GB", regionCode: "GB")
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


    @IBAction func onStart3DS(_ sender: Any) {
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

    func threeDSWebViewControllerAuthenticationDidSucceed(_ threeDSWebViewController: ThreedsWebViewController, token: String?) {
        showAlert(with: "3DS success, token: \(token ?? "nil")")
    }

    func threeDSWebViewControllerAuthenticationDidFail(_ threeDSWebViewController: ThreedsWebViewController) {
        showAlert(with: "3DS Fail")
    }
}
