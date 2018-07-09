import Foundation

/// Token response
public struct TokenResponse: Codable {

    /// Token type
    public let type: String

    /// The reference token
    public let token: String

    /// The date/time the token will expire
    public let expiresOn: String
}
