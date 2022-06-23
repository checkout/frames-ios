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
        XCTAssertEqual(errorView.headerLabel?.label?.text, style.text)
        XCTAssertEqual(errorView.headerLabel?.label?.font, style.font)
        XCTAssertEqual(errorView.headerLabel?.label?.textColor, style.textColor)
    }

    func testImageStyle() {
        XCTAssertEqual(errorView.imageContainerView?.imageView?.image, style.image)
        XCTAssertEqual(errorView.imageContainerView?.imageView?.tintColor, style.tintColor)
    }
}
