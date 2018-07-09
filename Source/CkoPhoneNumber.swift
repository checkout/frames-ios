import Foundation

/// A phone number
public struct CkoPhoneNumber: Codable {

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
