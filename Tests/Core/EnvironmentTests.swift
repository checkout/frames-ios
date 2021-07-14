import XCTest

@testable import Frames

final class EnvironmentTests: XCTestCase {
    
    // MARK: - classicURL
    
    func test_classicURL_live_returnsCorrectValue() {
        
        let expectedURLString = "https://api2.checkout.com/v2/"
        let actualURLString = Environment.live.classicURL.absoluteString
        XCTAssertEqual(expectedURLString, actualURLString)
    }
    
    func test_classicURL_sandbox_returnsCorrectValue() {
        
        let expectedURLString = "https://sandbox.checkout.com/api2/v2/"
        let actualURLString = Environment.sandbox.classicURL.absoluteString
        XCTAssertEqual(expectedURLString, actualURLString)
    }
    
    // MARK: - unifiedPaymentsURL

    func test_unifiedPaymentsURL_live_returnsCorrectValue() {
        
        let expectedURLString = "https://api.checkout.com/"
        let actualURLString = Environment.live.unifiedPaymentsURL.absoluteString
        XCTAssertEqual(expectedURLString, actualURLString)
    }
    
    func test_unifiedPaymentsURL_sandbox_returnsCorrectValue() {
        
        let expectedURLString = "https://api.sandbox.checkout.com/"
        let actualURLString = Environment.sandbox.unifiedPaymentsURL.absoluteString
        XCTAssertEqual(expectedURLString, actualURLString)
    }
    
}
