//
//  ViewController.swift
//  CheckoutSample
//
//  Created by Harry Brown on 18/10/2021.
//

import UIKit
import Checkout

class ViewController: UIViewController {
  @IBOutlet weak var cardTokenisationButton: UIButton!
  @IBOutlet weak var threeDSButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }

  @IBAction func cardTokenisationTouchUpInside(_ sender: Any) {
    let cardTokenisationViewController = CardTokenizationViewController()
    push(viewController: cardTokenisationViewController)
  }

  @IBAction func threeDSTouchUpInside(_ sender: Any) {
    let threeDSViewController = ThreeDSViewController()
    push(viewController: threeDSViewController)
  }

  private func push(viewController: UIViewController) {
    navigationController?.pushViewController(
      viewController,
      animated: true
    )
  }

  private func setUp() {
    title = "Checkout"

    cardTokenisationButton.layer.cornerRadius = 8
    cardTokenisationButton.backgroundColor = .ckoLightBlue
    cardTokenisationButton.titleLabel?.textColor = .ckoDarkBlue
    cardTokenisationButton.setTitleColor(.white, for: .normal)

    threeDSButton.layer.cornerRadius = 8
    threeDSButton.backgroundColor = .ckoDarkBlue
    threeDSButton.titleLabel?.textColor = .ckoLightYellow
    threeDSButton.setTitleColor(.white, for: .normal)
  }
}
