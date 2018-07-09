import Foundation

/// Address
public struct CkoAddress: Codable {

    /// Name
    public var name: String?

    /// Line 1
    public var addressLine1: String?

    /// Line 2
    public var addressLine2: String?

    /// City
    public var city: String?

    /// State
    public var state: String?

    /// Postcode
    public var postcode: String?

    /// Country
    public var country: String?

    /// Phone
    public var phone: CkoPhoneNumber?

    /// Initialize `CkoAddress`
    ///
    /// - parameter name: Name
    /// - parameter addressLine1: Line 1
    /// - parameter addressLine2: Line 2
    /// - parameter city: City
    /// - parameter state: State
    /// - parameter postcode: Postcode
    /// - parameter country: Country
    /// - parameter phone: Phone
    ///
    ///
    /// - returns: The new `CkoAddress` instance
    public init(name: String? = nil, addressLine1: String? = nil, addressLine2: String? = nil,
                city: String? = nil, state: String? = nil, postcode: String? = nil,
                country: String? = nil, phone: CkoPhoneNumber? = nil) {
        self.name = name
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.state = state
        self.postcode = postcode
        self.country = country
        self.phone = phone
    }
}
