import XCTest
@testable import Frames

class BillingFormButtonViewTests: XCTestCase {
    var view: SelectionButtonView!
    var style: DefaultBillingFormCountryCellStyle!

    override func setUp() {
        super.setUp()
        UIFont.loadAllCheckoutFonts
        style = DefaultBillingFormCountryCellStyle()
        view = SelectionButtonView(style: style, type: .country(style))
        view.update(style: style, type: .country(style))
    }

    func testHeaderLabelStyle() {
        XCTAssertEqual(view.titleLabel?.text, style.button.text)
        XCTAssertEqual(view.titleLabel?.font, style.button.font)
        XCTAssertEqual(view.titleLabel?.textColor, style.title?.textColor)
    }

    func testViewStyle() {
        XCTAssertEqual(view.layer.borderColor, style.button.normalBorderColor.cgColor)
        XCTAssertEqual(view.backgroundColor, style.button.backgroundColor)
    }

    func testImageStyle() {
        XCTAssertEqual(view.image?.image, style.button.image)
        XCTAssertEqual(view.image?.tintColor, style.button.disabledTintColor)
    }

    func testButtonStyle() {
        XCTAssertEqual(view.button?.isEnabled, style.button.isEnabled)
        XCTAssertEqual(view.button?.tintColor, .clear)
        XCTAssertEqual(view.button?.backgroundColor, .clear)
    }

    func testErrorStyle() {
        XCTAssertEqual(view.errorView?.isHidden, style.error.isHidden)
    }

}
