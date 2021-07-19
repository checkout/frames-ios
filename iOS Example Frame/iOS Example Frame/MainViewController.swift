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
       
        checkoutAPIClient.createApplePayToken(paymentData: paymentData) { status in
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
