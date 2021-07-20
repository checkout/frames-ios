import Foundation

/// Apple Pay Token
@available(*, deprecated, message: "This will be removed in a future release.")
public struct ApplePayTokenRequest: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case tokenData = "token_data"
        case type
    }

    /// Token Type: Apple Pay
    var type = "applepay"

    /// The Apple Pay Payment Token
    let tokenData: ApplePayTokenData?
    
}

// Extension for backwards compatability.
extension ApplePayTokenRequest {
    
    // swiftlint:disable:next identifier_name
    public var token_data: ApplePayTokenData? {
        return tokenData
    }
    
    public init(token_data: ApplePayTokenData?) {
        self.tokenData = token_data
    }
    
}

@available(*, deprecated, message: "This will be removed in a future release.")
public struct ApplePayTokenData: Codable, Equatable {
    
    let version: String
    let data: String
    let signature: String
    let header: ApplePayTokenDataHeader
    
    public init(version: String, data: String, signature: String, header: ApplePayTokenDataHeader) {
        self.version = version
        self.data = data
        self.signature = signature
        self.header = header
    }
    
}

@available(*, deprecated, message: "This will be removed in a future release.")
public struct ApplePayTokenDataHeader: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case ephemeralPublicKey
        case publicKeyHash
        case transactionID = "transactionId"
    }
    
    let ephemeralPublicKey: String
    let publicKeyHash: String
    let transactionID: String
    
    public init(ephemeralPublicKey: String, publicKeyHash: String, transactionId: String) {
        self.ephemeralPublicKey = ephemeralPublicKey
        self.publicKeyHash = publicKeyHash
        self.transactionID = transactionId
    }
}
