import Foundation
import CheckoutEventLoggerKit

enum FramesLogEvent {

    case paymentFormPresented

    var event: Event {
        Event(typeIdentifier: "com.checkout.frames-mobile-sdk.\(typeIdentifier)",
              time: time,
              monitoringLevel: monitoringLevel,
              properties: properties)
    }

    var providingMetadata: [String: String] {
        switch self {
        case .paymentFormPresented:
            return [:]
        }
    }

    private var typeIdentifier: String {
        switch self {
        case .paymentFormPresented:
            return "payment_form_presented"
        }
    }

    private var time: Date {
        Date()
    }

    private var monitoringLevel: MonitoringLevel {
        switch self {
        case .paymentFormPresented:
            return .info
        }
    }

    private var properties: [String: AnyCodable] {
        switch self {
        case .paymentFormPresented:
            return [:]
        }
    }
}
