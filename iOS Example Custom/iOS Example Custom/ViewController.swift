//
//  ViewController.swift
//  iOS Example Custom
//
//  Created by Floriel Fedry on 01/06/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import UIKit
import Frames

class ViewController: UIViewController {

    var checkoutAPIClient: CheckoutAPIClient = CheckoutAPIClient(publicKey: "pk_test_6e40a700-d563-43cd-89d0-f9bb17d35e73",
                                                                 environment: .sandbox)
    
    @IBOutlet weak var cardNumberView: CardNumberInputView!
    @IBOutlet weak var expirationDateView: ExpirationDateInputView!
    @IBOutlet weak var cvvView: CvvInputView!
    @IBAction func onTapPay(_ sender: Any) {
        let card = getCardTokenRequest()
        print(card)
        checkoutAPIClient.createCardToken(card: card) { result in

            switch result {
            case .success(let cardTokenResponse):
                self.showAlert(with: cardTokenResponse.token)

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let views: [StandardInputView] = [cardNumberView, expirationDateView, cvvView]
        views.forEach { view in
            view.layer.borderColor = UIColor.lightGray.cgColor
            view.layer.borderWidth = 2
            view.layer.cornerRadius = 10
            view.backgroundColor = UIColor(red: 34/255, green: 41/255, blue: 47/255, alpha: 1)
            view.textField.textColor = .white
            view.label.textColor = .white
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getCardTokenRequest() -> CkoCardTokenRequest {
        let cardUtils = CardUtils()
        let cardNumber = cardUtils.standardize(cardNumber: cardNumberView.textField.text!)
        let expirationDate = expirationDateView.textField.text
        let cvv = cvvView.textField.text
        let (expiryMonth, expiryYear) = cardUtils.standardize(expirationDate: expirationDate!)
        return CkoCardTokenRequest(number: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear, cvv: cvv!)
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

