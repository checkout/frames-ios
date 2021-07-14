import Foundation
import CheckoutEventLoggerKit

enum FramesLogEvent: Equatable {

    enum Property: String {
        case errorCodes
        case errorType
        case httpStatusCode
        case message
        case requestID
        case scheme
        case serverError
        case tokenType
    }

    case paymentFormPresented
    case tokenRequested(tokenType: TokenType)
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
        case let .tokenRequested(tokenType):
            return [.tokenType: tokenType.rawValue]
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
