import Foundation

/// Apple Pay Token
public struct ApplePayTokenRequest: Codable {

    /// Token Type: Apple Pay
    let type = "applepay"

    /// The Apple Pay Payment Token
    // swiftlint:disable:next identifier_name
    public let token_data: ApplePayTokenData?
}

public struct ApplePayTokenData: Codable {
    let version: String
    let data: String
    let signature: String
    let header: ApplePayTokenDataHeader
}

public struct ApplePayTokenDataHeader: Codable {
    let ephemeralPublicKey: String
    let publicKeyHash: String
    let transactionId: String
}
