//
//  CardValidator.swift
//
//
//  Created by Harry Brown on 21/10/2021.
//

import Foundation
import UIKit
import CheckoutEventLoggerKit

public protocol ExpiryDateValidating {
  func validate(expiryMonth: String, expiryYear: String) -> Result<ExpiryDate, ValidationError.ExpiryDate>
  func validate(expiryMonth: Int, expiryYear: Int) -> Result<ExpiryDate, ValidationError.ExpiryDate>
}

public protocol CardValidating: CardNumberValidating, CVVValidating, ExpiryDateValidating {
  func validate(_ card: Card) -> ValidationResult<ValidationError.Card>
}

/// Provides utility functions to validate cards
public class CardValidator: CardValidating {
  private let cardNumberValidator: CardNumberValidating
  private let addressValidator: AddressValidating
  private let phoneValidator: PhoneValidating
  private let cvvValidator: CVVValidating
  private let calendar: CalendarProtocol
  private let logManager: LogManaging.Type

/// Initializes a CardValidator object.
  public convenience init(environment: Environment) {
    let luhnChecker = LuhnChecker()
    let cardNumberValidator = CardNumberValidator(luhnChecker: luhnChecker)
    let addressValidator = AddressValidator()
    let phoneValidator = PhoneValidator()
    let cvvValidator = CVVValidator()
    let calendar = Calendar.current
    let logManager = LogManager.self

    logManager.setup(
      environment: environment,
      logger: CheckoutEventLogger(productName: Constants.Product.name),
      uiDevice: UIDevice.current,
      dateProvider: DateProvider(),
      anyCodable: AnyCodable()
    )

    self.init(
      cardNumberValidator: cardNumberValidator,
      addressValidator: addressValidator,
      phoneValidator: phoneValidator,
      cvvValidator: cvvValidator,
      calendar: calendar,
      logManager: logManager
    )
  }

  init(
    cardNumberValidator: CardNumberValidating,
    addressValidator: AddressValidating,
    phoneValidator: PhoneValidating,
    cvvValidator: CVVValidating,
    calendar: CalendarProtocol,
    logManager: LogManaging.Type
  ) {
    self.cardNumberValidator = cardNumberValidator
    self.addressValidator = addressValidator
    self.phoneValidator = phoneValidator
    self.cvvValidator = cvvValidator
    self.calendar = calendar
    self.logManager = logManager

    logManager.queue(event: .cardValidator)
  }

  // MARK: - Public

  /// Checks whether a given card number is valid and matches any of the supported schemes.
  /// - Parameters:
  ///   - cardNumber: The card number to validate.
  /// - Returns: The card's scheme if successful, else an error.
  public func validate(cardNumber: String) -> Result<Card.Scheme, ValidationError.CardNumber> {
    logManager.queue(event: .validateCardNumber)
    return cardNumberValidator.validate(cardNumber: cardNumber)
  }

  /// Checks whether the given expiry month and year are valid,
  /// if valid returns the values wrapped in an `ExpiryDate` object.
  /// The `expiryMonth` can be 1 or 2 digits, and the `expiryYear` can be 2 or 4 digits.
  /// - Parameters:
  ///   - expiryMonth: The expiry month of the card.
  ///   - expiryYear: The expiry year of the card.
  /// - Returns: The card's expiry date as an `ExpiryDate` object, else an error.
  public func validate(
    expiryMonth: String,
    expiryYear: String
  ) -> Result<ExpiryDate, ValidationError.ExpiryDate> {
    logManager.queue(event: .validateExpiryString)
    return validateExpiry(
      expiryMonth: expiryMonth,
      expiryYear: expiryYear
    )
  }


  /// Checks whether the given expiry month and year are valid,
  /// if valid returns the values wrapped in an `ExpiryDate` object.
  /// The `expiryMonth` can be 1 or 2 digits, and the `expiryYear` can be 2 or 4 digits.
  /// - Parameters:
  ///   - expiryMonth: The expiry month of the card.
  ///   - expiryYear: The expiry year of the card.
  /// - Returns: The card's expiry date as an `ExpiryDate` object, else an error.
  public func validate(
    expiryMonth: Int,
    expiryYear: Int
  ) -> Result<ExpiryDate, ValidationError.ExpiryDate> {
    logManager.queue(event: .validateExpiryInteger)
    return validateExpiry(
      expiryMonth: String(expiryMonth),
      expiryYear: String(expiryYear)
    )
  }


  /// Checks whether a CVV is valid for a given card scheme.
  /// If the cardScheme is `unknown`, this validates that the cvv is 3 or 4 digits.
  /// - Parameters:
  ///   - cvv: The CVV of the card.
  ///   - cardScheme: The scheme of the card.
  /// - Returns: Whether the CVV is valid, else an error.
  public func validate(
    cvv: String,
    cardScheme: Card.Scheme = .unknown
  ) -> ValidationResult<ValidationError.CVV> {
    logManager.queue(event: .validateCVV)
    return cvvValidator.validate(cvv: cvv, cardScheme: cardScheme)
  }

  public func validate(_ card: Card) -> ValidationResult<ValidationError.Card> {
    let cardScheme: Card.Scheme

    switch validate(cardNumber: card.number) {
    case .success(let scheme):
      cardScheme = scheme
    case .failure(let error):
      return .failure(.cardNumber(error))
    }

    if let cvv = card.cvv {
      switch validate(cvv: cvv, cardScheme: cardScheme) {
      case .success:
        break
      case .failure(let cvvError):
        return .failure(.cvv(cvvError))
      }
    }

    if let billingAddress = card.billingAddress {
      switch addressValidator.validate(billingAddress) {
      case .success:
        break
      case .failure(let billingAddressError):
        return .failure(.billingAddress(billingAddressError))
      }
    }

    if let phone = card.phone {
      switch phoneValidator.validate(phone) {
      case .success:
        break
      case .failure(let phoneError):
        return .failure(.phone(phoneError))
      }
    }

    return .success
  }

  // MARK: - Private

  private func validateExpiry(
    expiryMonth: String,
    expiryYear: String
  ) -> Result<ExpiryDate, ValidationError.ExpiryDate> {
    guard let month = Int(expiryMonth) else {
      return .failure(.invalidMonthString)
    }

    guard let year = Int(expiryYear) else {
      return .failure(.invalidYearString)
    }

    guard month >= 1 && month <= 12 else {
      return .failure(.invalidMonth)
    }

    let fourDigitYear: Int

    switch self.fourDigitYear(
      from: expiryYear,
      year: year) {
    case .success(let fourDigitYearResult):
      fourDigitYear = fourDigitYearResult
    case .failure(let expiryDateError):
      return .failure(expiryDateError)
    }

    let currentDate = Date()

    guard let providedDate = calendar.date(
      from: DateComponents(
        year: fourDigitYear,
        month: month
      )
    ), providedDate >= currentDate else {
      return .failure(.inThePast)
    }

    let expiryDate = ExpiryDate(
      month: month,
      year: fourDigitYear)

    return .success(expiryDate)
  }

  private func fourDigitYear(
    from expiryYear: String,
    year: Int
  ) -> Result<Int, ValidationError.ExpiryDate> {
    switch expiryYear.count {
    case 0, 1, 3:
      return .failure(.incompleteYear)
    case 2:
      return .success(2000 + year)
    case 4:
      return .success(year)
    default:
      return .failure(.invalidYear)
    }
  }
}
