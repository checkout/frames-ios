import XCTest
@testable import FramesIos

class SchemeIconsStackViewTests: XCTestCase {

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let schemeIconsStackView = SchemeIconsStackView(coder: coder)
        XCTAssertNotNil(schemeIconsStackView)
        XCTAssertFalse(schemeIconsStackView.translatesAutoresizingMaskIntoConstraints)
    }

    func testFrameInitialization() {
        let schemeIconsStackView = SchemeIconsStackView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
        XCTAssertFalse(schemeIconsStackView.translatesAutoresizingMaskIntoConstraints)
    }
}
