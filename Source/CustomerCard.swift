import Foundation

/// Customer Card used when you want to get the list of cards.
public struct CustomerCard: Codable {

    /// Customer Id
    public let customerId: String

    /// Expiry month
    public let expiryMonth: String

    /// Expiry year
    public let expiryYear: String

    /// Billing address
    public let billingDetails: CkoAddress

    /// Card Id
    public let id: String

    /// Last 4 digits of the card number
    public let last4: String

    /// Bin of the card number (first 6 digits)
    public let bin: String

    /// Payment method used (e.g. Visa)
    public let paymentMethod: String

    /// Card fingerprint
    public let fingerprint: String

    /// Name of the card owner
    public let name: String?

    /// True if it is the default card
    public let defaultCard: Bool
}
