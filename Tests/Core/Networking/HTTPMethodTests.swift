import XCTest

@testable import Frames

final class HTTPMethodTests: XCTestCase {
    
    // MARK: - rawValue
    
    func test_rawValue_get_returnsCorrectValue() {
        
        XCTAssertEqual("GET", HTTPMethod.get.rawValue)
    }
    
    func test_rawValue_post_returnsCorrectValue() {
        
        XCTAssertEqual("POST", HTTPMethod.post.rawValue)
    }
    
}
