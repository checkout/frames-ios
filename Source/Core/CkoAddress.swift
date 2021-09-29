import Foundation

/// Address
public struct CkoAddress: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case city
        case country
        case state
        case zip
    }
    
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
