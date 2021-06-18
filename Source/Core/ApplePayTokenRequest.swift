import Foundation

/// Apple Pay Token
public struct ApplePayTokenRequest: Codable {

    /// Token Type: Apple Pay
    var type = "applepay"

    /// The Apple Pay Payment Token
    // swiftlint:disable:next identifier_name
    public let token_data: ApplePayTokenData?
}

public struct ApplePayTokenData: Codable {
    
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

public struct ApplePayTokenDataHeader: Codable {
    let ephemeralPublicKey: String
    let publicKeyHash: String
    let transactionId: String
    
    public init(ephemeralPublicKey: String, publicKeyHash: String, transactionId: String) {
        self.ephemeralPublicKey = ephemeralPublicKey
        self.publicKeyHash = publicKeyHash
        self.transactionId = transactionId
    }
}
