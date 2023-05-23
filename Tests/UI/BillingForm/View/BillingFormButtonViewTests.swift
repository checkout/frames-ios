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
        XCTAssertTrue(view.buttonView.button.isEnabled)
    }

    func testImageStyle() {
        XCTAssertEqual(view.imageContainerView.imageView.image, style.button.image)
        XCTAssertEqual(view.imageContainerView.imageView.tintColor, style.button.imageTintColor)
    }

    func testErrorStyle() {
        XCTAssertTrue(view.errorView.isHidden)
    }

}
