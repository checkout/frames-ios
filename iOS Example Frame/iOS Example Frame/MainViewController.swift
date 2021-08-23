//
//  ViewController.swift
//  iOS Example Frame
//
//  Created by Floriel Fedry on 11/06/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import UIKit
import Frames

class MainViewController: UIViewController, CardViewControllerDelegate {
    
    @IBOutlet weak var goToPaymentPageButton: UIButton!
    @IBOutlet weak var createTokenWithApplePay: UIButton!
    
    // Step1 : create instance of CheckoutAPIClient
    let checkoutAPIClient = CheckoutAPIClient(publicKey: "pk_test_6e40a700-d563-43cd-89d0-f9bb17d35e73",
                                              environment: .sandbox)
    
    @IBAction func goToPaymentPage(_ sender: Any) {
        navigationController?.pushViewController(cardViewController, animated: true)
    }
    
    
    func onSubmit(controller: CardViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    lazy var cardViewController: CardViewController = {
        let b = CardViewController(checkoutApiClient: checkoutAPIClient, cardHolderNameState: .normal, billingDetailsState: .required, defaultRegionCode: "GB")
        b.billingDetailsAddress = CkoAddress(addressLine1: "Test line1", addressLine2: "Test line2", city: "London", state: "London", zip: "N12345", country: "GB")
        b.billingDetailsPhone = CkoPhoneNumber(countryCode: "44", number: "77 1234 1234")
        b.delegate = self
        b.addressViewController.setFields(address: b.billingDetailsAddress!, phone: b.billingDetailsPhone!)
        return b
    }()

    @IBAction func onClickGoToPaymentPage(_ sender: Any) {
        navigationController?.pushViewController(cardViewController, animated: true)
    }
    
    @IBAction func onClickGoTokenWithApplePay(_ sender: Any) {
        
        // Step2 : Load ApplePay Payment Data
        let header = Header()
        let paymentData = PaymentData(header: header)
    
        let appleHeader = ApplePayTokenDataHeader(ephemeralPublicKey: paymentData.header.ephemeralPublicKey, publicKeyHash: paymentData.header.publicKeyHash, transactionId: paymentData.header.transactionId)
        let applePayToken = ApplePayTokenData(version: paymentData.version, data: paymentData.data, signature: paymentData.signature, header: appleHeader)
        
        
        guard let applePayTokenData = try? JSONEncoder().encode(applePayToken) else {
            print("applePayTokenData is nil")
            return
        }
       
        checkoutAPIClient.createApplePayToken(paymentData: applePayTokenData) { status in
            switch status {
            case .failure(let error):
                self.showAlert(with: error.localizedDescription)
            case .success(let CkoCardTokenResponse):
                self.showAlert(with: CkoCardTokenResponse.token)
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
    
    func onTapDone(controller: CardViewController, cardToken: CkoCardTokenResponse?, status: CheckoutTokenStatus) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        switch status {
        case .success:
            
            // **** For testing only. ****
            print("addressLine1 : \(cardToken?.billingAddress?.addressLine1 ?? "")")
            print("addressLine2 : \(cardToken?.billingAddress?.addressLine2 ?? "")")
            print("countryCode \(cardToken?.phone?.countryCode ?? "")")
            print("phone number \(cardToken?.phone?.number ?? "")")
            // **** For testing only. ****
            
            guard let cardToken = cardToken else {
                self.showAlert(with: "Token object is nil")
                return
            }
            self.showAlert(with: cardToken.token)
            
        case .failure:
            print("failure")
        }
    }

    private func showAlert(with cardToken: String) {
        let alert = UIAlertController(title: "Payment",
                                      message: cardToken, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

// Struct to hold Apple Pay sandbox data for testing.
// Note : Token generation will work fine. If you try to make payment might not work as the below data needs to be generated again. ( this is only for testing token generation using apple pay data )
struct PaymentData: Codable {
    var version = "EC_v1"
    var data = "cWjjsdADd0e6O2cba0cpF1458RnoR0DAxvP/lfwBPz/HfcfBQY8Wld/m+k8WjBpwn504khNVFuJ3pGdZwUHUGVv5PrujtiglkCH3B+uMDYSzalfCi6/wQf0zDmHJVoghZb0dDz4Xrh4NicTYqcmTBzPRSEcisDxxbyzH8nD2jsd/bBA2Q+jzCGhWcV/gKKjLY2XQOEc0RpHyVAKtanGSfCpCZQPQ6D/19nzvWQe9kuqfLPqmB+gBi6Z7eYMhgdLKUZpXd/m3TL3AjrOeZxvoUr++VEI+XqRqDJT5GH+cmKRlR4/ezM9y4fwdO6DJUmh8kx1iWh0CFO38KmPM+dEcL7vKS2UkIyw4FExt4LLtgGBF2P6xu7JWUyRGnLYXRfZxpd0VpgGqCqLcDRn1"
    var signature = "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"
    let header: Header
}

struct Header: Codable {
    var ephemeralPublicKey = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEcadkxKiD26rU6v7m2g6EyJCjTPzHLtiekGrVxrR7MKYzI3w5L0Kn2EnAt81t3E1IpDkZCdY81CCVu5WO143G2w=="
    var publicKeyHash = "0KORSnwFZImfHyE1SuzhDaMMOMBia+SKBZPRuTzTCUc="
    var transactionId = "0d6788b178d15c6fa2d076c2a7d61bf8897722fa96d2d711ad2c4f617e9b0c70"
}

