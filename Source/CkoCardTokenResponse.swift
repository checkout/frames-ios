import Foundation

/// Card Token Response returned by a successful called to `createCardToken`.
public struct CkoCardTokenResponse: Codable {

    /// Card Token
    public let id: String

    /// Live Mode: true if in live environment
    public let liveMode: Bool

    /// Created date
    public let created: String

    /// Used: true if the card token has been used
    public let used: Bool

    /// Card used to create the card token
    public let card: Card
}
