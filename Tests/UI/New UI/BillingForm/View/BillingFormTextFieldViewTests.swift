import XCTest
@testable import Frames

class BillingFormTextFieldViewTests: XCTestCase {
    var view: TextFieldView!
    var style: DefaultBillingFormFullNameCellStyle!

    override func setUp() {
        super.setUp()
        UIFont.loadAllCheckoutFonts
        style = DefaultBillingFormFullNameCellStyle()
        view = TextFieldView()
        view.update(style: style, type: .fullName(nil))
    }

    func testHeaderLabelStyle() {
        XCTAssertEqual(view.headerLabel?.text, style.title?.text)
        XCTAssertEqual(view.headerLabel?.font, style.title?.font)
        XCTAssertEqual(view.headerLabel?.textColor, style.title?.textColor)
    }

    func testHintLabelStyle() {
        XCTAssertEqual(view.hintLabel?.text, style.hint?.text)
    }

    func testTextFieldContainerStyle() {
        XCTAssertEqual(view.textFieldContainer?.layer.borderColor, style.textfield.normalBorderColor.cgColor)
        XCTAssertEqual(view.textFieldContainer?.backgroundColor, style.textfield.backgroundColor)
        XCTAssertEqual(view.textField?.keyboardType, .default)
        XCTAssertEqual(view.textField?.textContentType, .name)
    }

    func testTextFieldtyle() {
        XCTAssertEqual(view.textField?.text, style.textfield.text)
        XCTAssertEqual(view.textField?.font, style.textfield.font)
        XCTAssertNil(view.textField?.placeholder)
        XCTAssertEqual(view.textField?.textColor, style.textfield.textColor)
        XCTAssertEqual(view.textField?.tintColor, style.textfield.tintColor)
    }

}
