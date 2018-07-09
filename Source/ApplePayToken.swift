import Foundation

/// Apple Pay token
public struct ApplePayToken: Codable {

    /// Type of the token: applepay
    public let type: String

    /// Token that can be used to process a _Charge with Card Token_
    public let token: String

    /// Expiration date of the apple pay token
    public let expiresOn: String
}
