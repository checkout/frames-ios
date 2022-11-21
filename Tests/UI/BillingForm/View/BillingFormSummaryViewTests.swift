import XCTest
@testable import Frames

class BillingFormSummaryViewTests: XCTestCase {
    var view: BillingFormSummaryView!
    var style: DefaultBillingSummaryViewStyle!
    override func setUp() {
        super.setUp()
        style = DefaultBillingSummaryViewStyle()
        view = BillingFormSummaryView()
        view.update(style: style)
    }

    func testStyleTitleView() {
        XCTAssertEqual(view.titleLabel.label.text, style.title?.text)
        XCTAssertEqual(view.titleLabel.label.font, style.title?.font)
        XCTAssertEqual(view.titleLabel.label.textColor, style.title?.textColor)
        XCTAssertEqual(view.titleLabel.label.backgroundColor, style.title?.backgroundColor)
    }

    func testStyleHintView() {
        XCTAssertEqual(view.hintLabel.label.text, style.hint?.text)
        XCTAssertEqual(view.hintLabel.label.font, style.hint?.font)
        XCTAssertEqual(view.hintLabel.label.textColor, style.hint?.textColor)
        XCTAssertEqual(view.hintLabel.label.backgroundColor, style.hint?.backgroundColor)
    }

    func testStyleSummaryView() {
        XCTAssertEqual(view.summaryLabel.label.text, style.summary?.text)
        XCTAssertEqual(view.summaryLabel.label.font, style.summary?.font)
        XCTAssertEqual(view.summaryLabel.label.textColor, style.summary?.textColor)
        XCTAssertEqual(view.summaryLabel.label.backgroundColor, style.summary?.backgroundColor)
    }

    func testStyleSummarySeparatorLineView() {
        XCTAssertEqual(view.summarySeparatorLineView.backgroundColor, style.separatorLineColor)
    }

    func testStyleSummaryContainerView() {
        XCTAssertEqual(view.summaryContainerView.backgroundColor, .clear)
    }

    func testStyleIconImageView() {
        XCTAssertEqual(view.imageContainerView.imageView.image, style.button.image)
        XCTAssertEqual(view.imageContainerView.imageView.tintColor, style.button.imageTintColor)
    }

    func testStyleButtonView() {
        XCTAssertTrue(view.buttonView.button.isEnabled)
        XCTAssertEqual(view.buttonView.button.tintColor, .clear)
        XCTAssertEqual(view.buttonView.clipsToBounds, true)
    }

    func testStyleErrorView() {
        XCTAssertEqual(view.errorView.isHidden, style.error?.isHidden ?? true)
        XCTAssertEqual(view.errorView.backgroundColor, style.error?.backgroundColor)
        guard let errorStyle = style.error else { return }
        let headerLabelStyle = DefaultTitleLabelStyle(backgroundColor: .clear,
                                                      isHidden: false,
                                                      text: errorStyle.text,
                                                      font: errorStyle.font,
                                                      textColor: errorStyle.textColor)

        XCTAssertEqual(view.errorView.headerLabel.label.text, headerLabelStyle.text)
        XCTAssertEqual(view.errorView.headerLabel.label.font, headerLabelStyle.font)
        XCTAssertEqual(view.errorView.headerLabel.label.textColor, headerLabelStyle.textColor)
        XCTAssertEqual(view.errorView.headerLabel.label.backgroundColor, headerLabelStyle.backgroundColor)

        XCTAssertEqual(view.errorView.imageContainerView.imageView.image, style.error?.image)
        XCTAssertEqual(view.errorView.imageContainerView.imageView.tintColor, style.error?.tintColor)
    }
}
