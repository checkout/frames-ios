import XCTest
@testable import Frames

class DetailsInputViewTests: XCTestCase {

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
        let detailsInputView = DetailsInputView()
        detailsInputView.text = "Text"
        XCTAssertEqual(detailsInputView.label.text, "Text")
    }

    func testSetLabelAndBackgroundColor() {
        let detailsInputView = DetailsInputView()
        detailsInputView.set(label: "addressLine1", backgroundColor: .white)
        XCTAssertEqual(detailsInputView.label.text, "Address line 1*")
        XCTAssertEqual(detailsInputView.backgroundColor, UIColor.white)
    }

    func testChevronRenderingMode() {
        let detailsInputView = DetailsInputView()
        XCTAssertEqual(detailsInputView.button.image(for: .normal)?.renderingMode, .alwaysTemplate)
    }

    func testDefaultChevronColor() {
        let previousChevronColor = CheckoutTheme.chevronColor
        CheckoutTheme.chevronColor = .cyan
        let detailsInputView = DetailsInputView()
        XCTAssertEqual(detailsInputView.button.tintColor, .cyan)
        CheckoutTheme.chevronColor = previousChevronColor
    }

    func testCustomizedChevronColor() {
        let detailsInputView = DetailsInputView()
        XCTAssertEqual(detailsInputView.button.tintColor, .black)
    }
}
