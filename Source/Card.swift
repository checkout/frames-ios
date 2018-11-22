import Foundation

/// Card used to create the card token
public struct Card: Codable {

    /// Expiry month
    public let expiryMonth: String

    /// Expiry year
    public let expiryYear: String

    /// Billing address
    public let billingDetails: Address

    /// Last 4 digits of the card number
    public let last4: String

    /// Bin of the card number (first 6 digits)
    public let bin: String

    /// Payment method used (e.g. Visa)
    public let paymentMethod: String

    /// Name of the card owner
    public let name: String?
}
