import Foundation

protocol RequestParameterProviding {
    
    var additionalHeaders: [String: String] { get }
    var httpMethod: HTTPMethod { get }
    func encodeBody(with encoder: TopLevelEncoder) throws -> Data?
    func url(with environmentURLProvider: EnvironmentURLProviding) -> URL
    
}

enum Request: RequestParameterProviding, Equatable {
    
    case applePayToken(body: ApplePayTokenRequest, publicKey: String, correlationID: String)
    case cardToken(body: CkoCardTokenRequest, publicKey: String, correlationID: String)
    case cardProviders(publicKey: String, correlationID: String)
    
    var additionalHeaders: [String: String] {
        switch self {
        case let .applePayToken(_, publicKey, correlationID),
             let .cardToken(_, publicKey, correlationID),
             let .cardProviders(publicKey, correlationID):
            return [
                "Authorization": publicKey,
                "User-Agent": Constants.userAgent,
                "Cko-Correlation-Id": correlationID
            ]
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .applePayToken, .cardToken:
            return .post
        case .cardProviders:
            return .get
        }
    }
    
    func encodeBody(with encoder: TopLevelEncoder) throws -> Data? {
        switch self {
        case let .applePayToken(body, _, _):
            return try encoder.encode(body)
        case let .cardToken(body, _, _):
            return try encoder.encode(body)
        case .cardProviders:
            return nil
        }
    }
    
    func url(with environmentURLProvider: EnvironmentURLProviding) -> URL {
        switch self {
        case .applePayToken, .cardToken:
            return environmentURLProvider.unifiedPaymentsURL
                .appendingPathComponent("tokens")
        case .cardProviders:
            return environmentURLProvider.classicURL
                .appendingPathComponent("providers/cards")
        }
    }
    
}
