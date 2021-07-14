import Foundation

/// Address
public struct CkoAddress: Codable, Equatable {
    /// Line 1 of the address
    public let addressLine1: String?

    /// Line 2 of the address
    public let addressLine2: String?

    /// The address city
    public let city: String?

    /// The address state
    public let state: String?

    /// The address zip/postal code
    public let zip: String?

    /// The two-letter ISO code of the address country
    public let country: String?

    public init(addressLine1: String? = nil, addressLine2: String? = nil,
                city: String? = nil, state: String? = nil, zip: String? = nil,
                country: String? = nil) {
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.state = state
        self.zip = zip
        self.country = country
    }
}
