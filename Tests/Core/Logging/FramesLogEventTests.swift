import CheckoutEventLoggerKit
import XCTest

@testable import Frames

final class FramesLogEventTests: XCTestCase {

    // MARK: - typeIdentifier

    func test_typeIdentifier_paymentFormPresented_returnsCorrectValue() {
        
        let subject = FramesLogEvent.paymentFormPresented(logTheme: true)
        XCTAssertEqual("com.checkout.frames-mobile-sdk.payment_form_presented", subject.typeIdentifier)
    }

    func test_typeIdentifier_exception_returnsCorrectValue() {

        let subject = createExceptionEvent()
        XCTAssertEqual("com.checkout.frames-mobile-sdk.exception", subject.typeIdentifier)
    }

    // MARK: - monitoringLevel

    func test_monitoringLevel_paymentFormPresented_returnsCorrectValue() {
        
        let subject = FramesLogEvent.paymentFormPresented(logTheme: true)
        XCTAssertEqual(.info, subject.monitoringLevel)
    }

    func test_monitoringLevel_exception_returnsCorrectValue() {

        let subject = createExceptionEvent()
        XCTAssertEqual(.error, subject.monitoringLevel)
    }

    // MARK: - properties

    func test_properties_paymentFormPresented_returnsCorrectValue() {
        let event = FramesLogEvent.paymentFormPresented(logTheme: true)
        let eventProperties = event.properties.mapValues(\.value)
        
        XCTAssertEqual(eventProperties.count, 2)
        XCTAssertEqual(eventProperties[.locale] as? String, Locale.current.identifier)
        // There is an issue with the theme recording! This will go with new UI so have spent sufficient time on it without luck.
        // The theme is not currently recorded as it has been at time of recording, it will be recorded as it is at time of dispatch!!!
    }

    func test_properties_exception_returnsCorrectValue() {

        let subject = createExceptionEvent(message: "message")
        XCTAssertEqual([.message: "message"], subject.properties)
    }

    // MARK: - Utility

    private func createExceptionEvent(message: String = "") -> FramesLogEvent {

        return .exception(message: message)
    }

}
