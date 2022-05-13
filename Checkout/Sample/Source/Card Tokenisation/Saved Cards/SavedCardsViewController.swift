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
    cell.expiryDateLabel.text = "\(savedCardModel.expiryMonth)/\(savedCardModel.expiryYear)"
    cell.cvvLabel.text = savedCardModel.cvv

    return cell
  }

  // swiftlint:disable function_body_length
  func loadTestCards() {
    // refer : https://www.checkout.com/docs/testing/test-card-numbers#Non-3D_Secure_enabled_cards

    // Non-3D Secure enabled cards
    let visaNon3d = CardModel(
      cardName: "Visa Non 3DS",
      cardNumber: "4485 1415 2054 4212",
      expiryMonth: "10",
      expiryYear: "2024",
      cvv: "100")

    let masterCardNon3d = CardModel(
      cardName: "Mastercard Non 3DS",
      cardNumber: "5248 2277 9889 6148",
      expiryMonth: "10",
      expiryYear: "2024",
      cvv: "100")

    // 3D Secure enabled cards
    let visa3ds2Enabled = CardModel(
      cardName: "Visa 3DS2 Enabled",
      cardNumber: "4242 4242 4242 4242",
      expiryMonth: "10",
      expiryYear: "2024",
      cvv: "100")
    let visaSpain3ds1 = CardModel(
      cardName: "Visa Spain 3DS1",
      cardNumber: "4002 9312 3456 7895",
      expiryMonth: "10",
      expiryYear: "2024",
      cvv: "100")
    let visaAustralia3ds1 = CardModel(
      cardName: "Visa Australia 3DS1",
      cardNumber: "4029 7912 3456 7892",
      expiryMonth: "10",
      expiryYear: "2024",
      cvv: "100")
    let masterCard3ds2 = CardModel(
      cardName: "Mastercard 3DS2",
      cardNumber: "5436 0310 3060 6378",
      expiryMonth: "10",
      expiryYear: "2024",
      cvv: "257")

    let amex3DS2 = CardModel(
      cardName: "Amex 3DS2",
      cardNumber: "3456 7890 1234 564",
      expiryMonth: "10",
      expiryYear: "2024",
      cvv: "1051")

    let amex3DS1 = CardModel(
      cardName: "Amex 3DS1",
      cardNumber: "3782 8224 6310 005",
      expiryMonth: "10",
      expiryYear: "2024",
      cvv: "1000")

    let dinersClub3ds1 = CardModel(
      cardName: "DinersClub 3DS1",
      cardNumber: "3012 3456 7890 19",
      expiryMonth: "10",
      expiryYear: "2024",
      cvv: "257")

    let discover3ds1 = CardModel(
      cardName: "Discover 3DS1",
      cardNumber: "6011 1111 1111 1117",
      expiryMonth: "10",
      expiryYear: "2024",
      cvv: "100")

    let jcb3ds1 = CardModel(
      cardName: "Discover 3DS1",
      cardNumber: "3530 1113 3330 0000",
      expiryMonth: "10",
      expiryYear: "2024",
      cvv: "100")

    savedCardModels.append(visaNon3d)
    savedCardModels.append(masterCardNon3d)
    savedCardModels.append(visa3ds2Enabled)
    savedCardModels.append(visaSpain3ds1)
    savedCardModels.append(visaAustralia3ds1)
    savedCardModels.append(masterCard3ds2)
    savedCardModels.append(amex3DS1)
    savedCardModels.append(amex3DS2)
    savedCardModels.append(dinersClub3ds1)
    savedCardModels.append(discover3ds1)
    savedCardModels.append(jcb3ds1)
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
