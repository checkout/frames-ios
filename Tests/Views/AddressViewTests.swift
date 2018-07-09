import XCTest
@testable import FramesIos

class AddressViewTests: XCTestCase {

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let addressView = AddressView(coder: coder)
        XCTAssertNotNil(addressView)
        XCTAssertEqual(addressView?.stackView.arrangedSubviews.count, 8)
    }

    func testFrameInitialization() {
        let addressView = AddressView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
        XCTAssertEqual(addressView.stackView.arrangedSubviews.count, 8)
    }
}
