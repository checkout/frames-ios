import Foundation

/// Card Token
public struct CardTokenRequest: Codable {

    let type = "card"

    /// The card number
    public var number: String

    /// The two-digit expiry month of the card
    public var expiryMonth: Int

    /// The four-digit expiry year of the card
    public var expiryYear: Int

    /// The card-holder name
    public var name: String?

    /// The card verification value/code. 3 digits, except Amex (4 digits).
    public var cvv: String?

    /// The payment source owner's billing address
    public var billingAddress: Address?

    /// The payment source owner's phone number
    public var phone: CkoPhoneNumber?

    /// Initialize `CardTokenRequest`
    ///
    /// - parameter number: The card number
    /// - parameter expiryMonth: The two-digit expiry month of the card
    /// - parameter expiryYear: The four-digit expiry year of the card
    /// - parameter name: The card-holder name
    /// - parameter cvv: The card verification value/code. 3 digits, except Amex (4 digits).
    /// - parameter billingAddress: The payment source owner's billing address
    /// - parameter phone: The payment source owner's phone number
    ///
    ///
    /// - returns: The new `CardTokenRequest` instance
    public init(number: String, expiryMonth: Int, expiryYear: Int,
                name: String? = nil, cvv: String? = nil, billingAddress: Address? = nil,
                phone: CkoPhoneNumber? = nil) {
        self.number = number
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.name = name
        self.cvv = cvv
        self.billingAddress = billingAddress
        self.phone = phone
    }

    /// Initialize `CardTokenRequest`
    ///
    /// - parameter number: The card number
    /// - parameter expiryMonth: The two-digit expiry month of the card
    /// - parameter expiryYear: The four-digit expiry year of the card
    /// - parameter cvv: The card verification value/code. 3 digits, except Amex (4 digits).
    ///
    ///
    /// - returns: The new `CardTokenRequest` instance
    public init(number: String, expiryMonth: Int, expiryYear: Int, cvv: String? = nil) {
        self.init(number: number, expiryMonth: expiryMonth, expiryYear: expiryYear, name: nil,
                  cvv: cvv, billingAddress: nil, phone: nil)
    }
}
