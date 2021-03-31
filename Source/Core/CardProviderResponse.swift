import Foundation

/// Response obtained via a called to `getCardProviders`
struct CardProviderResponse: Codable {

    /// type of the object response: 'list'
    let object: String

    /// number of card providers
    let count: Int

    /// list of card providers
    let data: [CardProvider]
}
