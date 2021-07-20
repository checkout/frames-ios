import Foundation

/// Card Token Response returned by a successful called to `createCardToken`.
public struct CkoCardTokenResponse: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case billingAddress = "billing_address"
        case bin
        case cardCategory = "card_category"
        case cardType = "card_type"
        case expiresOn = "expires_on"
        case expiryMonth = "expiry_month"
        case expiryYear = "expiry_year"
        case issuer
        case issuerCountry = "issuer_country"
        case last4 = "last4"
        case name
        case phone
        case productID = "product_id"
        case productType = "product_type"
        case scheme
        case token
        case type
    }

    /// Type
    public let type: String

    /// Card Token
    public let token: String

    /// Token expiry date
    public let expiresOn: String

    /// Card expiry month
    public let expiryMonth: Int

    /// Card expiry year
    public let expiryYear: Int

    /// Cardholder name
    public let name: String?

    /// Card scheme
    public let scheme: String?

    /// Card last 4 digits
    public let last4: String

    /// Card BIN
    public let bin: String

    /// Card type
    public let cardType: String?

    /// Card category
    public let cardCategory: String?

    /// Card issuer
    public let issuer: String?

    /// Card issuer country
    public let issuerCountry: String?

    /// Card product ID
    public let productID: String?

    /// Card product type
    public let productType: String?
    
    /// Billing address
    public var billingAddress: CkoAddress?

    /// Phone
    public var phone: CkoPhoneNumber?
}

// Extension for backwards compatability.
extension CkoCardTokenResponse {
    
    @available(*, deprecated, renamed: "productID")
    public var productId: String? { return productID }
    
}
