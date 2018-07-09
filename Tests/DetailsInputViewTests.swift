import XCTest
@testable import FramesIos

class DetailsInputViewTests: XCTestCase {

    var detailsInputView = DetailsInputView()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        detailsInputView = DetailsInputView()
    }

    func testEmptyInitialization() {
        _ = DetailsInputView()
    }

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        _ = DetailsInputView(coder: coder)
    }

    func testFrameInitialization() {
        _ = DetailsInputView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
    }

    func testSetText() {
        detailsInputView.text = "Text"
        XCTAssertEqual(detailsInputView.label.text, "Text")
    }

    func testSetLabelAndBackgroundColor() {
        detailsInputView.set(label: "addressLine1", backgroundColor: .white)
        XCTAssertEqual(detailsInputView.label.text, "Address line 1*")
        XCTAssertEqual(detailsInputView.backgroundColor, UIColor.white)
    }
}
