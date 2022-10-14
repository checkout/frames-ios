//
//  ButtonsTableViewCell.swift
//  CheckoutCocoapodsSample
//
//  Created by Daven.Gomes on 01/12/2021.
//

import UIKit

class ButtonsTableViewCell: UITableViewCell {
  @IBOutlet weak var validateButton: UIButton!
  @IBOutlet weak var tokeniseButton: UIButton!

  var didTapValidateButton: (() -> Void)?
  var didTapTokeniseButton: (() -> Void)?

  override func awakeFromNib() {
    super.awakeFromNib()
    setUpContent()
  }

  @IBAction func validateTouchUpInside(_ sender: Any) {
    didTapValidateButton?()
  }

  @IBAction func tokeniseTouchUpInside(_ sender: Any) {
    didTapTokeniseButton?()
  }

  private func setUpContent() {
    validateButton.titleLabel?.textColor = .ckoDarkBlue
    validateButton.backgroundColor = .ckoLightBlue
    validateButton.layer.cornerRadius = 8

    tokeniseButton.backgroundColor = .ckoDarkBlue
    tokeniseButton.layer.cornerRadius = 8
    tokeniseButton.titleLabel?.textColor = .ckoLightYellow

    validateButton.setTitleColor(.ckoDarkBlue, for: [.normal])
    tokeniseButton.setTitleColor(.ckoLightYellow, for: [.normal])
  }
}
