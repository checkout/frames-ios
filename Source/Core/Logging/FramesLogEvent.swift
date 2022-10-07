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

    case paymentFormInitialised(environment: Environment)
    case paymentFormPresented
    case paymentFormSubmitted
    case paymentFormSubmittedResult(token: String)
    case paymentFormCanceled
    case billingFormPresented
    case billingFormCanceled
    case billingFormSubmit
    case threeDSWebviewPresented
    case threeDSChallengeLoaded(success: Bool)
    case threeDSChallengeComplete(success: Bool, tokenID: String?)
    case exception(message: String)
    case warn(message: String)

    var typeIdentifier: String {
        return "com.checkout.frames-mobile-sdk.\(typeIdentifierSuffix)"
    }

    private var typeIdentifierSuffix: String {
        switch self {
        case .paymentFormInitialised:
            return "payment_form_initialised"
        case .paymentFormPresented:
            return "payment_form_presented"
        case .paymentFormSubmitted:
            return "payment_form_submitted"
        case .paymentFormSubmittedResult:
            return "payment_form_submitted_result"
        case .paymentFormCanceled:
            return "payment_form_cancelled"
        case .billingFormPresented:
            return "billing_form_presented"
        case .billingFormCanceled:
            return "billing_form_cancelled"
        case .billingFormSubmit:
            return "billing_form_submit"
        case .threeDSWebviewPresented:
            return "3ds_webview_presented"
        case .threeDSChallengeLoaded:
            return "3ds_challenge_loaded"
        case .threeDSChallengeComplete:
            return "3ds_challenge_complete"
        case .warn:
            return "warn"
        case .exception:
            return "exception"
        }
    }

    var monitoringLevel: MonitoringLevel {
        switch self {
        case .paymentFormInitialised,
             .paymentFormPresented,
             .paymentFormSubmitted,
             .paymentFormSubmittedResult,
             .paymentFormCanceled,
             .billingFormPresented,
             .billingFormCanceled,
             .billingFormSubmit,
             .threeDSWebviewPresented:
            return .info
        case .warn:
            return .warn
        case .exception:
            return .error
        case .threeDSChallengeLoaded(let success),
             .threeDSChallengeComplete(let success, _):
            return success ? .info : .error
        }
    }

    var properties: [Property: AnyCodable] {
        switch self {
        case .paymentFormSubmitted,
                .paymentFormCanceled,
                .billingFormPresented,
                .billingFormCanceled,
                .billingFormSubmit,
                .threeDSWebviewPresented:
            return [:]
        case .paymentFormPresented:
            return [Property.locale: Locale.current.identifier].mapValues(AnyCodable.init(_:))
        case let .paymentFormInitialised(environment):
            let environmentString = environment.rawValue == "live" ? "production" : environment.rawValue
            return [.environment: environmentString].mapValues(AnyCodable.init(_:))
        case let .paymentFormSubmittedResult(token):
            return [.tokenID: AnyCodable(token)]
        case let .threeDSChallengeLoaded(success):
            return [.success: success].mapValues(AnyCodable.init(_:))
        case let .threeDSChallengeComplete(success, tokenID):
            return [.success: success]
                .updating(key: .tokenID, value: tokenID)
                .mapValues(AnyCodable.init(_:))
        case let .warn(message),
            let .exception(message):
            return [.message: message]
                .mapValues(AnyCodable.init(_:))
        }
    }
}
