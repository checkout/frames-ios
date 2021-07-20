import Foundation

/// Card used to create the card token
public struct CkoCardTokenRequest: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case billingAddress = "billing_address"
        case cvv
        case expiryMonth = "expiry_month"
        case expiryYear = "expiry_year"
        case name
        case number
        case phone
        case type
    }

    /// Type
    var type: String = "card"

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

    /// Phone
    public var phone: CkoPhoneNumber?

    /// Initialize `CkoCardTokenRequest`
    ///
    /// - parameter number: Card number
    /// - parameter expiry_month: Expiry month
    /// - parameter expiry_year: Expiry year
    /// - parameter cvv: CVV (card verification value)
    /// - parameter name: Name of the card owner
    /// - parameter billing_address: Billing Address
    /// - parameter phone: Billing Address
    ///
    ///
    /// - returns: The new `CardRequest` instance
    public init(number: String, expiryMonth: String, expiryYear: String, cvv: String,
                name: String? = nil, billingAddress: CkoAddress? = nil, phone: CkoPhoneNumber? = nil) {
        self.number = number
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cvv = cvv
        self.name = name
        self.billingAddress = billingAddress
        self.phone = phone
    }

    public func createWith(shippingDetails: CkoAddress) -> CkoCardTokenRequest {
        return CkoCardTokenRequest(number: self.number, expiryMonth: self.expiryMonth,
                                   expiryYear: self.expiryYear, cvv: self.cvv, name: self.name,
                                   billingAddress: shippingDetails, phone: self.phone)
    }
}
