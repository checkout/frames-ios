import Foundation
import Checkout

/// Payment Form Utilities
enum CardUtils {

  // MARK: - Methods

  /// Format the card number based on the card type
  /// e.g. Visa card: 4242 4242 4242 4242
  ///
  /// - parameter cardNumber: Card number
  /// - parameter cardType: Card type
  ///
  ///
  /// - returns: The formatted card number
  static func format(cardNumber: String, scheme: Card.Scheme) -> String {
    var cardNumber = cardNumber

    for gap in scheme.cardGaps.sorted(by: >) where gap < cardNumber.count {
      cardNumber.insert(" ", at: cardNumber.index(cardNumber.startIndex, offsetBy: gap))
    }

    return cardNumber
  }

  static func removeNonDigits(from string: String) -> String {
    return string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
  }
}
