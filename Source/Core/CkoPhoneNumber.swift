import Foundation

/// A phone number
public struct CkoPhoneNumber: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case number
    }

    /// The international country calling code. Required for some risk checks.
    public let countryCode: String?

    /// The phone number.
    public let number: String?

    /// Initialize `PhoneNumber`
    ///
    /// - parameter countryCode: The internation country calling code.
    /// - parameter number: The phone number.
    ///
    ///
    /// - returns: The new `PhoneNumber` instance
    public init(countryCode: String? = nil, number: String? = nil) {
        self.countryCode = countryCode
        self.number = number
    }

}
