//
//  CardTokenizationViewController.swift
//  CheckoutCocoapodsSample
//
//  Created by Daven.Gomes on 30/11/2021.
//

import UIKit
import Checkout

class CardTokenizationViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  var viewModel: ViewModel
  let cardValidator: CardValidator
  let cardNumberDelegateHelper: CardNumberTextFieldDelegateHelper

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    let viewModel = ViewModel()
    let cardValidator = CardValidator(environment: .sandbox)

    self.viewModel = viewModel
    self.cardValidator = cardValidator
    self.cardNumberDelegateHelper = CardNumberTextFieldDelegateHelper(cardValidator: cardValidator) {
      viewModel.availableSchemes
    }

    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder: NSCoder) {
    let viewModel = ViewModel()
    let cardValidator = CardValidator(environment: .sandbox)

    self.viewModel = viewModel
    self.cardValidator = cardValidator
    self.cardNumberDelegateHelper = CardNumberTextFieldDelegateHelper(cardValidator: cardValidator) {
      viewModel.availableSchemes
    }

    super.init(coder: coder)
  }

  func validateCardDetails() {
    var errors: [Error] = []

    let cardNumberValidationResult = cardValidator.validate(
      cardNumber: viewModel.cardModel.cardNumber
    )

    switch cardNumberValidationResult {
    case .failure(let error):
      errors.append(error)

    case .success(let scheme):

      if !viewModel.availableSchemes.contains(scheme) {
        errors.append(SampleAppError.cardSchemeNotAccepted)
      }

      let cvvValidationResult = cardValidator.validate(
        cvv: viewModel.cardModel.cvv,
        cardScheme: scheme
      )

      if case .failure(let error) = cvvValidationResult {
        errors.append(error)
      }
    }

    let expiryValidationResult = validateExpiry()

    if case .failure(let error) = expiryValidationResult {
      errors.append(error)
    }

    let errorMessage = errors.isEmpty ? "None" : errors.map { $0.localizedDescription }.joined(separator: "\n\n")
    let title = "Validation Errors (\(errors.count))"
    displayAlert(title: title, message: errorMessage)
  }

  func tokeniseCardDetails() {
    // Get Card Expiry Date entered.
    var cardExpiryDate: ExpiryDate?

    switch validateExpiry() {
    case .success(let expiryDate):
      cardExpiryDate = expiryDate
    case .failure(let error):
      displayAlert(title: "Error:", message: "\(error.localizedDescription)")
    }

    let gbCountry = Country.allAvailable.first { $0.iso3166Alpha2 == "GB" }

    // Create a test Address Object
    let address = Address(
      addressLine1: "test line 1",
      addressLine2: "test line 2",
      city: "London",
      state: "London",
      zip: "N1 7LH",
      country: gbCountry
    )

    // Create a test Phone Object
    let phone = Phone(
      number: "+44 765678576",
      country: gbCountry
    )

    guard let cardExpiryDate = cardExpiryDate else {
      displayAlert(title: "Error:", message: "ExpiryDate is nil")
      return
    }

    // Create a Card Object from CardNumber, ExpiryDate, CVV, Billing Address and Phone Number,
    let card = Card(
      number: viewModel.cardModel.cardNumber,
      expiryDate: cardExpiryDate,
      name: "Test",
      cvv: viewModel.cardModel.cvv,
      billingAddress: address,
      phone: phone)

    let checkoutAPIService = CheckoutAPIService(
      publicKey: "pk_sbox_ym4kqv5lzvjni7utqbliqs2vhqc",
      environment: .sandbox)
    checkoutAPIService.createToken(.card(card)) { result in
      switch result {
      case .success(let tokenDetails):
        DispatchQueue.main.async {
          self.displayAlert(title: "Success:", message: "Token: \(tokenDetails.token)")
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self.displayAlert(title: "Error:", message: "Code : \(error.code) \n \(error.localizedDescription)")
        }
      }
    }
  }

  private func validateExpiry() -> Result<ExpiryDate, ValidationError.ExpiryDate> {
    switch viewModel.cardModel.expiry {
    case let .string(month, year):
      return cardValidator.validate(expiryMonth: month, expiryYear: year)
    case let .int(month, year):
      return cardValidator.validate(expiryMonth: month, expiryYear: year)
    }
  }

  private func displayAlert(title: String, message: String) {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )

    alertController.addAction(.init(title: "Dismiss", style: .default, handler: nil))

    present(
      alertController,
      animated: true,
      completion: nil
    )
  }
}

// MARK: - Non-Checkout Related

// MARK: Setup

extension CardTokenizationViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  private func setup() {
    title = "Card Tokenisation"

    tableView.register(
      UINib(
        nibName: "CardDetailsTableViewCell",
        bundle: nil
      ),
      forCellReuseIdentifier: "CardDetailsTableViewCell"
    )

    tableView.register(
      UINib(
        nibName: "ButtonsTableViewCell",
        bundle: nil
      ),
      forCellReuseIdentifier: "ButtonsTableViewCell"
    )

    tableView.dataSource = self
    tableView.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let selectedIndex = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedIndex, animated: true)
    }
  }
}

// MARK: UITableViewDataSource
extension CardTokenizationViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    4
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0, 1, 2, 3:
      return 1
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Test Card Numbers"
    case 1:
      return "Available Schemes"
    case 2:
      return "Card Details"
    default:
      return nil
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:

      let cell = UITableViewCell(style: .default, reuseIdentifier: "DefaultTableViewCell")
      cell.textLabel?.text = "Select Card"
      cell.accessoryType = .disclosureIndicator
      return cell

    case 1:

      let cell = UITableViewCell(style: .default, reuseIdentifier: "DefaultTableViewCell")
      let availableSchemes = viewModel.availableSchemes.map(\.rawValue.localizedCapitalized).joined(separator: ", ")
      cell.textLabel?.text = viewModel.availableSchemes.isEmpty ? "Select Schemes" : availableSchemes
      cell.accessoryType = .disclosureIndicator
      return cell

    case 2:

      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: "CardDetailsTableViewCell",
        for: indexPath
      ) as? CardDetailsTableViewCell else {
        fatalError("`CardDetailsTableViewCell` not registered.")
      }

      cell.updateTextFieldValues(
        cardNumber: viewModel.cardModel.cardNumber,
        month: viewModel.cardModel.expiry.month,
        year: viewModel.cardModel.expiry.year,
        cvv: viewModel.cardModel.cvv
      )

      cell.viewModel = CardDetailsTableViewCell.ViewModel(
        onCardNumberChange: { cardNumber in
          self.viewModel.cardModel.cardNumber = cardNumber ?? ""
        },
        onCVVChange: { cvv in
          self.viewModel.cardModel.cvv = cvv ?? ""
        },
        onExpiryMonthStringChange: { expiryMonth in
          self.viewModel.cardModel.expiry = .string(
            month: expiryMonth ?? "",
            year: self.viewModel.cardModel.expiry.year
          )
        },
        onExpiryYearStringChange: { expiryYear in
          self.viewModel.cardModel.expiry = .string(
            month: self.viewModel.cardModel.expiry.month,
            year: expiryYear ?? ""
          )
        },
        onExpiryIntChange: { expiryMonth, expiryYear in
          self.viewModel.cardModel.expiry = CardModel.Expiry.int(month: expiryMonth, year: expiryYear)
        }
      )

      cell.delegate = self

      return cell

    case 3:

      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: "ButtonsTableViewCell",
        for: indexPath
      ) as? ButtonsTableViewCell else {
        fatalError("`ButtonsTableViewCell` not registered.")
      }

      cell.didTapValidateButton = { [weak self] in
        self?.validateCardDetails()
      }

      cell.didTapTokeniseButton = { [weak self] in
        self?.tokeniseCardDetails()
      }

      return cell

    default:
      fatalError("Unsupported index path.")
    }
  }

  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Use our pre-defined test cards to see how the details are tokenized"
    case 1:
      return "Select card schemes to enable, which is used to check against what the user has entered"

    default:
      return nil
    }
  }
}

// MARK: UITableViewDelegate
extension CardTokenizationViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    return 73
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:

      let savedCardsViewController = SavedCardsViewController()
      savedCardsViewController.didSelectSavedCard = { [weak self] cardModel in
        self?.viewModel.cardModel = cardModel
        tableView.reloadRows(
          at: [IndexPath(row: 0, section: 2)],
          with: .automatic)
      }
      navigationController?.pushViewController(savedCardsViewController, animated: true)

    case 1:

      let selectSchemeViewController = SelectSchemeViewController()
      selectSchemeViewController.selectedSchemes = viewModel.availableSchemes
      selectSchemeViewController.didSelectSchemes = { [weak self] schemes in
        self?.viewModel.availableSchemes = schemes
        tableView.reloadRows(
          at: [IndexPath(row: 0, section: 1)],
          with: .automatic)
      }
      navigationController?.pushViewController(selectSchemeViewController, animated: true)

    default:
      break
    }
  }
}

extension CardTokenizationViewController: CardDetailsTableViewCellDelegate {
  var cardNumberDelegate: UITextFieldDelegate {
    cardNumberDelegateHelper
  }
}
