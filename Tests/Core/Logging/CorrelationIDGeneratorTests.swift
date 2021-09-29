import XCTest

@testable import Frames

final class CorrelationIDGeneratorTests: XCTestCase {
    
    // MARK: - generateCorrelationID
    
    func test_generateCorrelationID_returnsCorrectValue() throws {
        
        let uuid = try XCTUnwrap(UUID(uuidString: "00112233-4455-6677-8899-AABBCCDDEEFF"))
        let subject = CorrelationIDGenerator(createUUID: { uuid })
        
        XCTAssertEqual("00112233-4455-6677-8899-aabbccddeeff", subject.generateCorrelationID())
    }
    
}
