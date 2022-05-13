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

  func setUpContent() {
    let ckoDarkBlue = UIColor(
      red: 12 / 255,
      green: 17 / 255,
      blue: 66 / 255,
      alpha: 1)
    let ckoLightBlue = UIColor(
      red: 41 / 255,
      green: 212 / 255,
      blue: 219 / 255,
      alpha: 1)
    let ckoLightYellow = UIColor(
      red: 255 / 255,
      green: 255 / 255,
      blue: 200 / 255,
      alpha: 1)

    validateButton.titleLabel?.textColor = ckoDarkBlue
    validateButton.backgroundColor = ckoLightBlue
    validateButton.layer.cornerRadius = 8

    tokeniseButton.backgroundColor = ckoDarkBlue
    tokeniseButton.layer.cornerRadius = 8
    tokeniseButton.titleLabel?.textColor = ckoLightYellow

    validateButton.setTitleColor(ckoDarkBlue, for: [.normal])
    tokeniseButton.setTitleColor(ckoLightYellow, for: [.normal])
  }
}
