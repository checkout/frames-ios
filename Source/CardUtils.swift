import Foundation
import Checkout

/// Payment Form Utilities
public final class CardUtils {

    // MARK: - Properties

    /// map of card scheme to indexes of spaces in formatted card number string
    /// eg. a visa card has gaps at 4, 8 and 12. 4242424242424242 becomes 4242 4242 4242 4242
    let cardGaps: [Card.Scheme: [Int]] = [.visa: [4, 8, 12],
                                          .mastercard: [4, 8, 12],
                                          .mada: [4, 8, 12],
                                          .amex: [4, 10],
                                          .diners: [4, 10],
                                          .discover: [4, 8, 12],
                                          .jcb: [4, 8, 12],
                                          .maestro: [4, 8, 12]]

    // MARK: - Initialization

    /// Create an instance of `CardUtils`
    ///
    /// - returns: The new `CardUtils` instance
    public init() {}

    // MARK: - Methods

    /// Format the card number based on the card type
    /// e.g. Visa card: 4242 4242 4242 4242
    ///
    /// - parameter cardNumber: Card number
    /// - parameter cardType: Card type
    ///
    ///
    /// - returns: The formatted card number
    public func format(cardNumber: String, scheme: Card.Scheme) -> String {
        guard let gaps = cardGaps[scheme] else {
            return cardNumber
        }

        var cardNumber = cardNumber

        for gap in gaps.sorted().reversed() {
            if gap < cardNumber.count {
                cardNumber.insert(" ", at: cardNumber.index(cardNumber.startIndex, offsetBy: gap))
            }
        }

        return cardNumber
    }

    func removeNonDigits(from string: String) -> String {
        return string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }

    /// Standardize the expiration date by removing non digits and spaces
    ///
    /// - parameter expirationDate: Expiration Date (e.g. 05/2020)
    ///
    ///
    /// - returns: Expiry month and expiry year (month: 05, year: 21)
    public func standardize(expirationDate: String) -> (month: String, year: String) {
        let digitOnlyDate = removeNonDigits(from: expirationDate)
        switch digitOnlyDate.count {
        case ..<1:
            return (month: "", year: "")
        case ..<3:
            if let monthInt = Int(digitOnlyDate) {
                return  monthInt < 10 ? (month: "0\(digitOnlyDate)", year: "") : (month: digitOnlyDate, year: "")
            }
        case ...5:
            let indexEndMonth = digitOnlyDate.index(digitOnlyDate.startIndex, offsetBy: 2)
            let month = digitOnlyDate[..<indexEndMonth]
            let year = digitOnlyDate[indexEndMonth...]
            return (month: String(month), year: String(year))
        case 5...:
            let indexEndMonth = digitOnlyDate.index(digitOnlyDate.startIndex, offsetBy: 2)
            let indexStartYear = digitOnlyDate.index(digitOnlyDate.startIndex, offsetBy: 4)
            let month = digitOnlyDate[..<indexEndMonth]
            let year = digitOnlyDate[indexStartYear...]
            return (month: String(month), year: String(year))
        default:
            break
        }
        return (month: "", year: "")
    }
}
