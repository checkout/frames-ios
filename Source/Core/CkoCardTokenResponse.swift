import Foundation

/// Card Token Response returned by a successful called to `createCardToken`.
public struct CkoCardTokenResponse: Codable {

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
    public let productId: String?

    /// Card product type
    public let productType: String?
    
    /// Billing address
    public var billingAddress: CkoAddress?

    /// Phone
    public var phone: CkoPhoneNumber?
}
