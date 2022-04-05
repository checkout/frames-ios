import Foundation
import CheckoutEventLoggerKit

enum FramesLogEvent: Equatable, PropertyProviding {

    enum Property: String {
        case environment
        case errorCodes
        case errorType
        case httpStatusCode
        case message
        case publicKey
        case requestID
        case scheme
        case serverError
        case tokenID
        case tokenType
        case locale
        case theme
        case primaryBackgroundColor
        case secondaryBackgroundColor
        case tertiaryBackgroundColor
        case primaryTextColor
        case secondaryTextColor
        case errorTextColor
        case chevronColor
        case font
        case barStyle
        case red
        case green
        case blue
        case alpha
        case size
        case name
    }

    case checkoutAPIClientInitialised(environment: Environment)
    case paymentFormPresented(theme: Theme, locale: Locale)
    case billingFormPresented
    case tokenRequested(tokenType: TokenType, publicKey: String)
    case tokenResponse(tokenType: TokenType,
                       publicKey: String,
                       tokenID: String?,
                       scheme: String?,
                       httpStatusCode: Int,
                       errorResponse: ErrorResponse?)
    case exception(message: String)

    var typeIdentifier: String {
        return "com.checkout.frames-mobile-sdk.\(typeIdentifierSuffix)"
    }

    private var typeIdentifierSuffix: String {
        switch self {
        case .checkoutAPIClientInitialised:
            return "checkout_api_client_initialised"
        case .paymentFormPresented:
            return "payment_form_presented"
        case .billingFormPresented:
            return "billing_form_presented"
        case .tokenRequested:
            return "token_requested"
        case .tokenResponse:
            return "token_response"
        case .exception:
            return "exception"
        }
    }

    var monitoringLevel: MonitoringLevel {
        switch self {
        case .checkoutAPIClientInitialised,
             .paymentFormPresented,
             .billingFormPresented,
             .tokenRequested,
             .tokenResponse:
            return .info
        case .exception:
            return .error
        }
    }

    var properties: [Property: AnyCodable] {
        switch self {
        case .billingFormPresented:
            return [:]
        case let .paymentFormPresented(theme, locale):
            return [.theme: theme.rawProperties, .locale: locale.identifier].mapValues(AnyCodable.init(_:))
        case let .checkoutAPIClientInitialised(environment):
            let environmentString = environment.rawValue == "live" ? "production" : environment.rawValue
            return [.environment: environmentString].mapValues(AnyCodable.init(_:))
        case let .tokenRequested(tokenType, publicKey):
            return [.tokenType: tokenType.rawValue, .publicKey: publicKey]
                .mapValues(AnyCodable.init(_:))
        case let .tokenResponse(tokenType, publicKey, tokenID, scheme, httpStatusCode, errorResponse):
            let serverError = errorResponse?.rawProperties
            return [.tokenType: tokenType.rawValue, .publicKey: publicKey, .httpStatusCode: httpStatusCode]
                .updating(key: .scheme, value: scheme)
                .updating(key: .serverError, value: serverError)
                .updating(key: .tokenID, value: tokenID)
                .mapValues(AnyCodable.init(_:))
        case let .exception(message):
            return [.message: message]
                .mapValues(AnyCodable.init(_:))
        }
    }
    
}
