import Foundation
import CheckoutEventLoggerKit

enum FramesLogEvent: Equatable {

    enum Property: String {
        case errorCodes
        case errorType
        case httpStatusCode
        case message
        case publicKey
        case requestID
        case scheme
        case serverError
        case tokenType
    }

    case paymentFormPresented
    case tokenRequested(tokenType: TokenType, publicKey: String)
    case tokenResponse(tokenType: TokenType, scheme: String?, httpStatusCode: Int, errorResponse: ErrorResponse?)
    case exception(message: String)

    var typeIdentifier: String {
        let suffix: String
        switch self {
        case .paymentFormPresented:
            suffix = "payment_form_presented"
        case .tokenRequested:
            suffix = "token_requested"
        case .tokenResponse:
            suffix = "token_response"
        case .exception:
            suffix = "exception"
        }
        
        return "com.checkout.frames-mobile-sdk.\(suffix)"
    }

    var monitoringLevel: MonitoringLevel {
        switch self {
        case .paymentFormPresented,
             .tokenRequested,
             .tokenResponse:
            return .info
        case .exception:
            return .error
        }
    }

    var properties: [Property: AnyCodable] {
        switch self {
        case .paymentFormPresented:
            return [:]
        case let .tokenRequested(tokenType, publicKey):
            return [.tokenType: tokenType.rawValue, .publicKey: publicKey]
                .mapValues { AnyCodable($0) }
        case let .tokenResponse(tokenType, scheme, httpStatusCode, errorResponse):
            let serverError = errorResponse?.properties.mapKeys(\.rawValue)
            return [.tokenType: tokenType.rawValue, .httpStatusCode: httpStatusCode]
                .updating(key: .scheme, value: scheme)
                .updating(key: .serverError, value: serverError)
                .mapValues { AnyCodable($0) }
        case let .exception(message):
            return [.message: message]
                .mapValues { AnyCodable($0) }
        }
    }
    
}
