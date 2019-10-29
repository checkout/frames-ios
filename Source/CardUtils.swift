import Foundation

/// Payment Form Utilities
public class CardUtils {

    // MARK: - Properties

    /// Dictionary of card types based on their scheme
    let cardTypes: KeyValuePairs<CardScheme, CardType> = [
        .visa: CardType(scheme: .visa,
                        name: "Visa",
                        pattern: "^4\\d*$",
                        gaps: [4, 8, 12],
                        validLengths: [16],
                        validCvvLengths: [3],
                        isLuhnChecked: true),
        .mastercard: CardType(scheme: .mastercard,
                              name: "Mastercard",
                              pattern: "^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[0-1]|2720)\\d*$",
                              gaps: [4, 8, 12],
                              validLengths: [16],
                              validCvvLengths: [3],
                              isLuhnChecked: true),
        .americanExpress: CardType(scheme: .americanExpress,
                                   name: "American Express",
                                   pattern: "^3[47]\\d*$",
                                   gaps: [4, 10],
                                   validLengths: [15],
                                   validCvvLengths: [4],
                                   isLuhnChecked: true),
        .dinersClub: CardType(scheme: .dinersClub,
                              name: "Diner's Club",
                              pattern: "^3(0[0-5]|[689])\\d*$",
                              gaps: [4, 10],
                              validLengths: [14, 16, 19],
                              validCvvLengths: [3],
                              isLuhnChecked: true),
        .discover: CardType(scheme: .discover,
                            name: "Discover",
                            pattern: "^(6011|65|64[4-9])\\d*$",
                            gaps: [4, 8, 12],
                            validLengths: [16, 19],
                            validCvvLengths: [3],
                            isLuhnChecked: true),
        .jcb: CardType(scheme: .jcb,
                       name: "JCB",
                       pattern: "^(2131|1800|35)\\d*$",
                       gaps: [4, 8, 12],
                       validLengths: [16, 17, 18, 19],
                       validCvvLengths: [3],
                       isLuhnChecked: true),
        .unionPay: CardType(scheme: .unionPay,
                            name: "UnionPay",
                            // swiftlint:disable line_length
                            pattern: "^(((620|(621(?!83|88|98|99))|622(?!06|018)|62[3-6]|627[02,06,07]|628(?!0|1)|629[1,2]))\\d*|622018\\d{12})$",
                            // swiftlint:enable line_length_violation
                            gaps: [4, 10],
                            validLengths: [16, 17, 18, 19],
                            validCvvLengths: [3],
                            isLuhnChecked: false),
        .maestro: CardType(scheme: .maestro,
                           name: "Maestro",
                           // swiftlint: disable line_length
                           pattern: "^(?:5[06789]\\d\\d|(?!6011[0234])(?!60117[4789])(?!60118[6789])(?!60119)(?!64[456789])(?!65)6\\d{3})\\d{8,15}$",
                           // swiftlint: enable line_length_violation
                           gaps: [4, 8, 12],
                           validLengths: [12, 13, 14, 15, 16, 17, 18, 19],
                           validCvvLengths: [3],
                           isLuhnChecked: true)
    ]

    // MARK: - Initialization

    /// Create an instance of `CardUtils`
    ///
    /// - returns: The new `CardUtils` instance
    public init() {}

    // MARK: - Methods

    /// Perform the lunh check algorithm to determine the validity of a card number
    /// Note: the card number must be without spaces
    ///
    /// - parameter cardNumber: Card number
    ///
    ///
    /// - returns: true if the card valid the lunh check algorithm, false otherwise
    public func luhnCheck(cardNumber: String) -> Bool {
        let digits = Array(cardNumber)
        var sum = 0
        var oddDigit = true
        for index in stride(from: digits.count - 1, through: 0, by: -1) {
            guard var nDigit = Int(String(digits[index])) else { return false }
            if !oddDigit {
                nDigit *= 2
                if nDigit > 9 { nDigit -= 9 }
            }
            sum += nDigit
            oddDigit = !oddDigit
        }
        return sum % 10 == 0
    }

    /// Get the type of the card based on the card number
    /// Note: the card number must be without spaces
    ///
    /// - parameter cardNumber: Card number
    ///
    ///
    /// - returns: The card type corresponding to the card number, nil if no card type is found
    public func getTypeOf(cardNumber: String) -> CardType? {
        for (_, cardType) in cardTypes {
            if cardNumber.range(of: cardType.pattern, options: .regularExpression) != nil {
                return cardType
            }
        }
        return nil
    }

    /// Format the card number based on the card type
    /// e.g. Visa card: 4242 4242 4242 4242
    ///
    /// - parameter cardNumber: Card number
    /// - parameter cardType: Card type
    ///
    ///
    /// - returns: The formatted card number
    public func format(cardNumber: String, cardType: CardType) -> String {
        var index = 0
        var numberOfGaps = 0
        return cardNumber.reduce("") {
            defer { index += 1 }
            guard cardType.gaps.count > numberOfGaps else { return "\($0)\($1)" }
            if index == cardType.gaps[numberOfGaps] {
                numberOfGaps += 1
                return "\($0) \($1)"
            }
            return "\($0)\($1)"
        }
    }

    /// Check if the card number is valid
    ///
    /// - parameter cardNumber: Card number
    ///
    ///
    /// - returns: true if the card number is valid, false otherwise
    public func isValid(cardNumber: String) -> Bool {
        let cardType = self.getTypeOf(cardNumber: cardNumber)
        return cardType != nil ? self.isValid(cardNumber: cardNumber, cardType: cardType!) : false
    }

    /// Check if the card number is valid based on the card type
    ///
    /// - parameter cardNumber: Card number
    /// - parameter cardType: Card type
    ///
    ///
    /// - returns: true if the card number is valid, false otherwise
    public func isValid(cardNumber: String, cardType: CardType) -> Bool {
        if cardType.isLuhnChecked {
            guard luhnCheck(cardNumber: cardNumber) else { return false }
        }
        return cardType.validLengths.contains { $0 == cardNumber.count }
    }

    /// Check if the cvv is valid based on the card type
    ///
    /// - parameter cvv: cvv (card verification value)
    /// - parameter cardType: Card type
    ///
    ///
    /// - returns: true if the cvv is valid, false otherwise
    public func isValid(cvv: String, cardType: CardType) -> Bool {
        return cardType.validCvvLengths.contains { $0 == cvv.count }
    }

    /// Check if the expiration date is valid
    ///
    /// - parameter expirationMonth: Expiration month
    /// - parameter expirationYear: Expiration year
    ///
    ///
    /// - returns: true if the expiration date is valid, false otherwise
    public func isValid(expirationMonth: String, expirationYear: String) -> Bool {
        // check month and year are accepted values
        guard expirationMonth.count == 2 else { return false }
        guard expirationYear.count == 4 || expirationYear.count == 2 else { return false }
        let expirationYear4Digits = expirationYear.count == 2 ? "20\(expirationYear)" : expirationYear
        guard let month = Int(expirationMonth), let year = Int(expirationYear4Digits) else { return false }
        if month > 12 || month < 1 { return false }

        // check the date is not before the current one
        let calendar = Calendar(identifier: .gregorian)
        let providedDate = calendar.date(from: DateComponents(year: year, month: month))
        let componentsCurrentDate = calendar.dateComponents([.month, .year], from: Date())
        let currentDate = calendar.date(from: componentsCurrentDate)
        if let providedDateUnwrap = providedDate, let currentDateUnwrap = currentDate {
            return providedDateUnwrap >= currentDateUnwrap
        }
        return false
    }

    /// Standardize the card number by removing non digits and spaces
    ///
    /// - parameter cardNumber: Card Number
    ///
    ///
    /// - returns: The card number standardized.
    public func standardize(cardNumber: String) -> String {
        return cardNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }

    /// Standardize the expiration date by removing non digits and spaces
    ///
    /// - parameter expirationDate: Expiration Date (e.g. 05/2020)
    ///
    ///
    /// - returns: Expiry month and expiry year (month: 05, year: 21)
    public func standardize(expirationDate: String) -> (month: String, year: String) {
        let digitOnlyDate = expirationDate.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
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

    /// Get the card type object of a card scheme
    ///
    /// - parameter scheme: Card scheme (e.g. Visa)
    ///
    ///
    /// - returns: The card type corresponding to the scheme, nil if no card type is found
    public func getCardType(scheme: CardScheme) -> CardType? {
        return cardTypes.first(where: { $0.key == scheme})?.value
    }
}
