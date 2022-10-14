//
//  SavedCardsViewController.swift
//  CheckoutCocoapodsSample
//
//  Created by Daven.Gomes on 01/12/2021.
//

import UIKit

class SavedCardsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  var savedCardModels: [CardModel] = []
  var didSelectSavedCard: ((CardModel) -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Saved Cards"

    loadTestCards()

    tableView.register(
      UINib(
        nibName: "SavedCardTableViewCell",
        bundle: nil
      ),
      forCellReuseIdentifier: "SavedCardTableViewCell"
    )
    tableView.dataSource = self
    tableView.delegate = self
  }
}

extension SavedCardsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    savedCardModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "SavedCardTableViewCell",
      for: indexPath
    ) as? SavedCardTableViewCell else {
      fatalError("SavedCardTableViewCell not registered.")
    }

    let savedCardModel = savedCardModels[indexPath.row]

    cell.cardNameLabel.text = savedCardModel.cardName
    cell.cardNumberLabel.text = savedCardModel.cardNumber
    cell.expiryDateLabel.text = "\(savedCardModel.expiry.month)/\(savedCardModel.expiry.year)"
    cell.cvvLabel.text = savedCardModel.cvv

    return cell
  }

  // swiftlint:disable function_body_length
  func loadTestCards() {
    // refer : https://www.checkout.com/docs/testing/test-card-numbers#Non-3D_Secure_enabled_cards

    let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())
    let defaultCardExpiry = CardModel.Expiry.int(month: 10, year: currentYear + 2)

    // Non-3D Secure enabled cards
    let visaNon3d = CardModel(
      cardName: "Visa Non 3DS",
      cardNumber: "4485 1415 2054 4212",
      expiry: defaultCardExpiry,
      cvv: "100")

    let masterCardNon3d = CardModel(
      cardName: "Mastercard Non 3DS",
      cardNumber: "5248 2277 9889 6148",
      expiry: defaultCardExpiry,
      cvv: "100")

    // 3D Secure enabled cards
    let visa3ds2Enabled = CardModel(
      cardName: "Visa 3DS2 Enabled",
      cardNumber: "4242 4242 4242 4242",
      expiry: defaultCardExpiry,
      cvv: "100")
    let visaSpain3ds1 = CardModel(
      cardName: "Visa Spain 3DS1",
      cardNumber: "4002 9312 3456 7895",
      expiry: defaultCardExpiry,
      cvv: "100")
    let visaAustralia3ds1 = CardModel(
      cardName: "Visa Australia 3DS1",
      cardNumber: "4029 7912 3456 7892",
      expiry: defaultCardExpiry,
      cvv: "100")
    let masterCard3ds2 = CardModel(
      cardName: "Mastercard 3DS2",
      cardNumber: "5436 0310 3060 6378",
      expiry: defaultCardExpiry,
      cvv: "257")

    let amex3DS2 = CardModel(
      cardName: "Amex 3DS2",
      cardNumber: "3456 7890 1234 564",
      expiry: defaultCardExpiry,
      cvv: "1051")

    let amex3DS1 = CardModel(
      cardName: "Amex 3DS1",
      cardNumber: "3782 8224 6310 005",
      expiry: defaultCardExpiry,
      cvv: "1000")

    let dinersClub3ds1 = CardModel(
      cardName: "DinersClub 3DS1",
      cardNumber: "3012 3456 7890 19",
      expiry: defaultCardExpiry,
      cvv: "257")

    let discover3ds1 = CardModel(
      cardName: "Discover 3DS1",
      cardNumber: "6011 1111 1111 1117",
      expiry: defaultCardExpiry,
      cvv: "100")

    let jcb3ds1 = CardModel(
      cardName: "Discover 3DS1",
      cardNumber: "3530 1113 3330 0000",
      expiry: defaultCardExpiry,
      cvv: "100")

    savedCardModels.append(contentsOf: [
      visaNon3d,
      masterCardNon3d,
      visa3ds2Enabled,
      visaSpain3ds1,
      visaAustralia3ds1,
      masterCard3ds2,
      amex3DS1,
      amex3DS2,
      dinersClub3ds1,
      discover3ds1,
      jcb3ds1
    ])
  }
}

extension SavedCardsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cardModel = savedCardModels[indexPath.row]
    didSelectSavedCard?(cardModel)
    tableView.deselectRow(at: indexPath, animated: true)
    navigationController?.popViewController(animated: true)
  }
}
