import CheckoutEventLoggerKit
import XCTest

@testable import Frames

final class FramesLogEventTests: XCTestCase {
    
    // MARK: - typeIdentifier
    
    func test_typeIdentifier_paymentFormPresented_returnsCorrectValue() {
        
        let subject = FramesLogEvent.paymentFormPresented(theme: Theme(), locale: Locale.current)
        XCTAssertEqual("com.checkout.frames-mobile-sdk.payment_form_presented", subject.typeIdentifier)
    }

    
    func test_typeIdentifier_exception_returnsCorrectValue() {
        
        let subject = createExceptionEvent()
        XCTAssertEqual("com.checkout.frames-mobile-sdk.exception", subject.typeIdentifier)
    }
    
    // MARK: - monitoringLevel
    
    func test_monitoringLevel_paymentFormPresented_returnsCorrectValue() {
        
        let subject = FramesLogEvent.paymentFormPresented(theme: Theme(), locale: Locale.current)
        XCTAssertEqual(.info, subject.monitoringLevel)
    }
    
    func test_monitoringLevel_exception_returnsCorrectValue() {
        
        let subject = createExceptionEvent()
        XCTAssertEqual(.error, subject.monitoringLevel)
    }
    
    // MARK: - properties
    
    func test_properties_paymentFormPresented_returnsCorrectValue() {
        let locale = Locale(identifier: "en_GB")
        let stubTheme = StubTheme()
        let stubProperties: [FramesLogEvent.Property: AnyCodable] = [.red: true, .blue: false]
        stubTheme.propertiesToReturn = stubProperties
        
        
        let subject = FramesLogEvent.paymentFormPresented(theme: stubTheme, locale: locale)
        XCTAssertEqual([.theme: stubProperties.mapKeys(\.rawValue), .locale: locale.identifier].mapValues(AnyCodable.init(_:)), subject.properties)
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
