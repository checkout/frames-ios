//
//  CardDetailsTableViewCell.swift
//  CheckoutCocoapodsSample
//
//  Created by Daven.Gomes on 01/12/2021.
//

import UIKit

class CardDetailsTableViewCell: UITableViewCell {
  @IBOutlet weak var cardNumberTextField: UITextField!
  @IBOutlet weak var expiryMonthTextField: UITextField!
  @IBOutlet weak var expiryYearTextField: UITextField!
  @IBOutlet weak var cvvTextField: UITextField!

  var onCardNumberChange: ((String?) -> Void)?
  var onExpiryMonthChange: ((String?) -> Void)?
  var onExpiryYearChange: ((String?) -> Void)?
  var onCVVChange: ((String?) -> Void)?

  @IBAction func cardNumberTextFieldEditingChanged(_ sender: Any) {
    onCardNumberChange?(cardNumberTextField.text)
  }

  @IBAction func expiryMonthTextFieldEditingChanged(_ sender: Any) {
    onExpiryMonthChange?(expiryMonthTextField.text)
  }

  @IBAction func expiryYearTextFieldEditingChanged(_ sender: Any) {
    onExpiryYearChange?(expiryYearTextField.text)
  }

  @IBAction func cvvTextFieldEditingChanged(_ sender: Any) {
    onCVVChange?(cvvTextField.text)
  }
}
