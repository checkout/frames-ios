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
    public var billingDetails: CkoAddress?

    /// Initialize `CkoCardTokenRequest`
    ///
    /// - parameter number: Card number
    /// - parameter expiryMonth: Expiry month
    /// - parameter expiryYear: Expiry year
    /// - parameter cvv: CVV (card verification value)
    /// - parameter name: Name of the card owner
    /// - parameter billingDetails: Billing Address
    ///
    ///
    /// - returns: The new `CardRequest` instance
    public init(number: String, expiryMonth: String, expiryYear: String, cvv: String,
                name: String? = nil, billingDetails: CkoAddress? = nil) {
        self.number = number
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cvv = cvv
        self.name = name
        self.billingDetails = billingDetails
    }

    public func createWith(shippingDetails: CkoAddress) -> CkoCardTokenRequest {
        return CkoCardTokenRequest(number: self.number, expiryMonth: self.expiryMonth,
                                   expiryYear: self.expiryYear, cvv: self.cvv, name: self.name,
                                   billingDetails: shippingDetails)
    }
}
