import Foundation

/// Address
public struct Address: Codable {

    /// Line 1 of the address
    public let addressLine1: String?

    /// Line 2 of the address
    public let addressLine2: String?

    /// The address city
    public let city: String?

    /// The address state
    public let state: String?

    /// The address zip/postal code
    public let postcode: String?

    /// The two-letter ISO code of the address country
    public let country: String?

    /// The phone number
    public let phone: CkoPhoneNumber?
}
