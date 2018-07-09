import Foundation

/// Card used to create the card token
public struct CkoCardTokenRequest: Codable {

    /// Card number
    public let number: String

    /// Expiry month
    public let expiryMonth: String

    /// Expiry year
    public let expiryYear: String

    /// CVV (card verification value)
    public let cvv: String

    /// Name of the card owner
    public var name: String?

    /// Billing address
    public var billingAddress: CkoAddress?

    /// Initialize `CkoCardTokenRequest`
    ///
    /// - parameter number: Card number
    /// - parameter expiryMonth: Expiry month
    /// - parameter expiryYear: Expiry year
    /// - parameter cvv: CVV (card verification value)
    /// - parameter name: Name of the card owner
    /// - parameter billingAddress: Billing Address
    ///
    ///
    /// - returns: The new `CardRequest` instance
    public init(number: String, expiryMonth: String, expiryYear: String, cvv: String,
                name: String? = nil, billingAddress: CkoAddress? = nil) {
        self.number = number
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cvv = cvv
        self.name = name
        self.billingAddress = billingAddress
    }
}
