import XCTest

@testable import Frames

final class EnvironmentTests: XCTestCase {
    
    // MARK: - classicURL
    
    func test_classicURL_live_returnsCorrectValue() {
        
        let expectedURL = URL(staticString: "https://api2.checkout.com/v2/")
        let actualURL = Environment.live.classicURL
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_classicURL_sandbox_returnsCorrectValue() {
        
        let expectedURL = URL(staticString: "https://sandbox.checkout.com/api2/v2/")
        let actualURL = Environment.sandbox.classicURL
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    // MARK: - unifiedPaymentsURL

    func test_unifiedPaymentsURL_live_returnsCorrectValue() {
        
        let expectedURL = URL(staticString: "https://api.checkout.com/")
        let actualURL = Environment.live.unifiedPaymentsURL
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_unifiedPaymentsURL_sandbox_returnsCorrectValue() {
        
        let expectedURL = URL(staticString: "https://api.sandbox.checkout.com/")
        let actualURL = Environment.sandbox.unifiedPaymentsURL
        XCTAssertEqual(expectedURL, actualURL)
    }
    
}
