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
        let checkoutAPIClient = CheckoutAPIClient(publicKey: "pk_test_6e40a700-d563-43cd-89d0-f9bb17d35e73",
                                                  environment: .sandbox)
        let view = CardViewController(checkoutApiClient: checkoutAPIClient, cardHolderNameState: .normal, billingDetailsState: .normal, defaultRegionCode: "GB")
        view.billingDetailsAddress = CkoAddress(addressLine1: "Test line1", addressLine2: "Test line2", city: "London", state: "London", zip: "N12345", country: "GB")
        view.billingDetailsPhone = CkoPhoneNumber(countryCode: "44", number: "77 1234 1234")
        view.delegate = self
        view.addressViewController.setFields(address: view.billingDetailsAddress!, phone: view.billingDetailsPhone!)
        view.delegate = self
        view.rightBarButtonItem = UIBarButtonItem(title: "Pay", style: .done, target: nil, action: nil)
        view.availableSchemes = [.visa, .mastercard, .maestro]
        view.setDefault(regionCode: "GB")
        view.addressViewController.setCountrySelected(country: "GB", regionCode: "GB")
        return view
    }()

    @IBAction func onClickGoToPaymentPage(_ sender: Any) {
        navigationController?.pushViewController(cardViewController, animated: true)
    }

    func onTapDone(controller: CardViewController, cardToken: CkoCardTokenResponse?, status: CheckoutTokenStatus) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        switch status {
        case .success:
            self.showAlert(with: cardToken!.token)
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
