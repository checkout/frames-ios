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
        XCTAssertEqual(view.countryLabel?.text, style.button.text)
        XCTAssertEqual(view.countryLabel?.font, style.button.font)
        XCTAssertEqual(view.countryLabel?.textColor, style.title?.textColor)
    }

    func testViewStyle() {
        XCTAssertEqual(view.button?.layer.borderColor, style.button.normalBorderColor.cgColor)
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
