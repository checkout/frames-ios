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

  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }

  @IBAction func cardTokenisationTouchUpInside(_ sender: Any) {
    let cardTokenisationViewController = CardTokenizationViewController()

    navigationController?.pushViewController(
      cardTokenisationViewController,
      animated: true
    )
  }

  private func setUp() {
    title = "Checkout"
    cardTokenisationButton.layer.cornerRadius = 8
    cardTokenisationButton.backgroundColor = .systemBlue
    cardTokenisationButton.titleLabel?.textColor = UIColor.white
    cardTokenisationButton.setTitleColor(.white, for: .normal)
  }
}
