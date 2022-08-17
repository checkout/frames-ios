import XCTest
@testable import Frames

class BillingFormButtonViewTests: XCTestCase {
    var view: SelectionButtonView!
    var style: DefaultBillingFormCountryCellStyle!

    override func setUp() {
        super.setUp()
        style = DefaultBillingFormCountryCellStyle()
        view = SelectionButtonView()
        view.update(style: style)
    }

    func testHeaderLabelStyle() {
      XCTAssertEqual(view.titleLabel.label.text, style.button.text)
        XCTAssertEqual(view.titleLabel.label.font, style.button.font)
        XCTAssertEqual(view.titleLabel.label.textColor, style.title?.textColor)
    }

    func testButtonStyle() {
        XCTAssertEqual(view.buttonView.layer.borderColor, style.button.normalBorderColor.cgColor)
        XCTAssertEqual(view.buttonView.button.isEnabled, style.button.isEnabled)
        XCTAssertEqual(view.buttonView.layer.cornerRadius, style.button.cornerRadius)
        XCTAssertEqual(view.buttonView.layer.borderWidth, style.button.borderWidth)
    }

    func testImageStyle() {
        XCTAssertEqual(view.imageContainerView.imageView.image, style.button.image)
        XCTAssertEqual(view.imageContainerView.imageView.tintColor, style.button.disabledTintColor)
    }

    func testErrorStyle() {
        XCTAssertTrue(view.errorView.isHidden)
    }

}
