import Foundation

/// List of the api enpoints.
///
/// - cardProviders: used to get the list of card providers.
/// - tokens: used to create tokens with Unified Payments API.
enum Endpoint: String {
    case cardProviders = "providers/cards"
    case tokens = "tokens"
}
