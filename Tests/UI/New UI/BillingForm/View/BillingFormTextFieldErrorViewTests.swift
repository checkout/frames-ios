import XCTest
@testable import Frames

class BillingFormTextFieldErrorViewTests: XCTestCase {
    var errorView: SimpleErrorView!
    var style: DefaultErrorInputLabelStyle!

    override func setUp() {
        super.setUp()
        UIFont.loadAllCheckoutFonts
        style = DefaultErrorInputLabelStyle()
        errorView = SimpleErrorView()
        errorView.update(style: style)
    }

    func testStyleCurrentView() {
        XCTAssertEqual(errorView.backgroundColor, style.backgroundColor)
    }

    func testHeaderLabelStyle() {
        XCTAssertEqual(errorView.headerLabel?.text, style.text)
        XCTAssertEqual(errorView.headerLabel?.font, style.font)
        XCTAssertEqual(errorView.headerLabel?.textColor, style.textColor)
    }

    func testImageStyle() {
        XCTAssertEqual(errorView.image?.image, style.image)
        XCTAssertEqual(errorView.image?.tintColor, style.tintColor)
    }
}
