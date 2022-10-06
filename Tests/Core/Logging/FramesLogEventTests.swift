import CheckoutEventLoggerKit
import XCTest
@testable import Frames

final class FramesLogEventTests: XCTestCase {

    // MARK: - typeIdentifier

    func test_typeIdentifier_paymentFormPresented_returnsCorrectValue() {
        
        let subject = FramesLogEvent.paymentFormPresented
        XCTAssertEqual("com.checkout.frames-mobile-sdk.payment_form_presented", subject.typeIdentifier)
    }

    func test_typeIdentifier_exception_returnsCorrectValue() {

        let subject = createExceptionEvent()
        XCTAssertEqual("com.checkout.frames-mobile-sdk.exception", subject.typeIdentifier)
    }

    // MARK: - monitoringLevel

    func test_monitoringLevel_paymentFormPresented_returnsCorrectValue() {
        
        let subject = FramesLogEvent.paymentFormPresented
        XCTAssertEqual(.info, subject.monitoringLevel)
    }

    func test_monitoringLevel_exception_returnsCorrectValue() {

        let subject = createExceptionEvent()
        XCTAssertEqual(.error, subject.monitoringLevel)
    }

    // MARK: - properties

    func test_properties_paymentFormPresented_returnsCorrectValue() {
        let event = FramesLogEvent.paymentFormPresented
        let eventProperties = event.properties.mapValues(\.value)
        
        XCTAssertEqual(eventProperties.count, 1)
        XCTAssertEqual(eventProperties[.locale] as? String, Locale.current.identifier)
    }

    func test_properties_exception_returnsCorrectValue() {

        let subject = createExceptionEvent(message: "message")
        XCTAssertEqual([.message: "message"], subject.properties)
    }
    
    func testPaymentFormSubmittedFormat() {
        let event = FramesLogEvent.paymentFormSubmitted
        XCTAssertEqual(event.typeIdentifier, "com.checkout.frames-mobile-sdk.payment_form_submitted")
        XCTAssertEqual(event.properties, [:])
        XCTAssertEqual(event.monitoringLevel, .info)
        XCTAssertEqual(event.rawProperties, [:])
    }
    
    func testPaymentFormOutcomeFormat() {
        let testToken = "ABCIamAtoken123"
        let event = FramesLogEvent.paymentFormOutcome(token: testToken)

        XCTAssertEqual(event.typeIdentifier, "com.checkout.frames-mobile-sdk.payment_form_outcome")
        XCTAssertEqual(event.properties, [FramesLogEvent.Property.tokenID: AnyCodable(testToken)])
        XCTAssertEqual(event.monitoringLevel, .info)
        XCTAssertEqual(event.rawProperties, ["tokenID": AnyCodable(testToken)])
    }

    // MARK: - Utility

    private func createExceptionEvent(message: String = "") -> FramesLogEvent {

        return .exception(message: message)
    }

}
