import Foundation
import CheckoutEventLoggerKit

@frozen enum FramesLogEvent: Equatable {

    @frozen enum Property: String {
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
    }

    case paymentFormPresented
    case billingFormPresented
    case exception(message: String)

    var typeIdentifier: String {
        return "com.checkout.frames-mobile-sdk.\(typeIdentifierSuffix)"
    }

    private var typeIdentifierSuffix: String {
        switch self {
        case .paymentFormPresented:
            return "payment_form_presented"
        case .billingFormPresented:
            return "billing_form_presented"
        case .exception:
            return "exception"
        }
    }

    var monitoringLevel: MonitoringLevel {
        switch self {
        case .paymentFormPresented,
             .billingFormPresented:
            return .info
        case .exception:
            return .error
        }
    }

    var properties: [Property: AnyCodable] {
        switch self {
        case .paymentFormPresented,
             .billingFormPresented:
            return [:]
        case let .exception(message):
            return [.message: message]
                .mapValues { AnyCodable($0) }
        }
    }

}
