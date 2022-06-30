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
        case success
    }

    case checkoutAPIClientInitialised(environment: Environment)
    case paymentFormPresented(theme: Theme, locale: Locale)
    case billingFormPresented
    case threeDSWebviewPresented
    case threeDSChallengeLoaded(success: Bool)
    case threeDSChallengeComplete(success: Bool, tokenID: String?)
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
        case .threeDSWebviewPresented:
            return "3ds_webview_presented"
        case .threeDSChallengeLoaded:
            return "3ds_challenge_loaded"
        case .threeDSChallengeComplete:
            return "3ds_challenge_complete"
        case .exception:
            return "exception"
        }
    }

    var monitoringLevel: MonitoringLevel {
        switch self {
        case .checkoutAPIClientInitialised,
             .paymentFormPresented,
             .billingFormPresented,
             .threeDSWebviewPresented:
            return .info
        case .exception:
            return .error
        case .threeDSChallengeLoaded(let success),
             .threeDSChallengeComplete(let success, _):
            return success ? .info : .error
        }
    }

    var properties: [Property: AnyCodable] {
        switch self {
        case .billingFormPresented,
             .threeDSWebviewPresented:
            return [:]
        case let .paymentFormPresented(theme, locale):
            return [.theme: theme.rawProperties, .locale: locale.identifier].mapValues(AnyCodable.init(_:))
        case let .checkoutAPIClientInitialised(environment):
            let environmentString = environment.rawValue == "live" ? "production" : environment.rawValue
            return [.environment: environmentString].mapValues(AnyCodable.init(_:))
        case let .threeDSChallengeLoaded(success):
            return [.success: success].mapValues(AnyCodable.init(_:))
        case let .threeDSChallengeComplete(success, tokenID):
            return [.success: success]
                .updating(key: .tokenID, value: tokenID)
                .mapValues(AnyCodable.init(_:))
        case let .exception(message):
            return [.message: message]
                .mapValues(AnyCodable.init(_:))
        }
    }

    var loggedOncePerCorrelationID: Bool {
        switch self {
        case .checkoutAPIClientInitialised,
             .paymentFormPresented,
             .billingFormPresented,
             .threeDSWebviewPresented:
            return true
        case .threeDSChallengeLoaded,
             .threeDSChallengeComplete,
             .exception:
            return false
        }
    }
}
