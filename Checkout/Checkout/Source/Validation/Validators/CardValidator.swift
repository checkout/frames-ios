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

  /// Checks whether a given card number is at least a partial match for any of the supported schemes.
  /// - Parameters:
  ///   - cardNumber: The card number to validate.
  /// - Returns: The card's scheme if successful, else an error.
  public func eagerValidate(cardNumber: String) -> Result<Card.Scheme, ValidationError.CardNumber> {
    logManager.queue(event: .validateCardNumber)
    return cardNumberValidator.eagerValidate(cardNumber: cardNumber)
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

    guard let expiryMonth = Int(expiryMonth) else {
      return .failure(.invalidMonthString)
    }

    switch fourDigitYear(from: expiryYear) {
    case .success(let expiryYear):
      return validateExpiry(
        expiryMonth: expiryMonth,
        expiryYear: expiryYear
      )
    case .failure(let error):
      return .failure(error)
    }
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

    switch fourDigitYear(from: expiryYear) {
    case .success(let expiryYear):
      return validateExpiry(
        expiryMonth: expiryMonth,
        expiryYear: expiryYear
      )
    case .failure(let error):
      return .failure(error)
    }
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
    expiryMonth: Int,
    expiryYear: Int
  ) -> Result<ExpiryDate, ValidationError.ExpiryDate> {
    guard expiryMonth >= 1 && expiryMonth <= 12 else {
      return .failure(.invalidMonth)
    }

    let currentDate = Date()
    // using UTC-12 as this is the latest timezone where a card could be valid
    let cardExpiryComponents = DateComponents(
      timeZone: .utcMinus12,
      year: expiryYear,
      month: expiryMonth
    )

    guard
      let cardExpiryDate = calendar.date(from: cardExpiryComponents),
      let nextMonth = calendar.date(byAdding: .month, value: 1, to: cardExpiryDate),
      nextMonth > currentDate
    else {
      return .failure(.inThePast)
    }

    let expiryDate = ExpiryDate(
      month: expiryMonth,
      year: expiryYear)

    return .success(expiryDate)
  }

  private func fourDigitYear(from expiryYear: String) -> Result<Int, ValidationError.ExpiryDate> {
    switch expiryYear.count {
    case 0...4:
      guard let year = Int(expiryYear) else {
        return .failure(.invalidYearString)
      }

      return fourDigitYear(from: year)
    default:
      return .failure(.invalidYear)
    }
  }

  private func fourDigitYear(from expiryYear: Int) -> Result<Int, ValidationError.ExpiryDate> {
    // year must be 2 or 4+ digits, otherwise year is incomplete
    // 0 digits - no year has been entered yet
    // 1 or 3 digits - we are waiting on an extra digit
    guard expiryYear > 1000 || (expiryYear > 9 && expiryYear < 100) else {
      return .failure(.incompleteYear)
    }

    // year must be less than 5 digits, otherwise year is invalid
    // 5+ digits - a typo has been entered after the year
    guard expiryYear < 10000 else {
      return .failure(.invalidYear)
    }

    guard expiryYear < 100 else {
      // 4 digit year
      return .success(expiryYear)
    }

    // 2 digit year
    return .success(2000 + expiryYear)
  }
}
