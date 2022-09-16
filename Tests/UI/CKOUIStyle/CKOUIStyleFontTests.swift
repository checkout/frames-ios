import XCTest
@testable import Frames

final class UIStyleFontTests: XCTestCase {

    func testUIStyleFont() {
        let font = UIStyle.font(size: 15, weight: .regular)
        let expectedFont =  UIFont.systemFont(ofSize: 15, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    // MARK: - Title -

    func testTitle2Font(){
        let font = UIStyle.Font.title2
        let expectedFont = UIStyle.font(size: 24, weight: .medium)

        XCTAssertEqual(font, expectedFont)
    }

    func testHeadlineFont(){
        let font = UIStyle.Font.headline
        let expectedFont = UIStyle.font(size: 17, weight: .semibold)

        XCTAssertEqual(font, expectedFont)
    }

    // MARK: - Body -

    func testBodyLargeFont(){
        let font = UIStyle.Font.bodyLarge
        let expectedFont = UIStyle.font(size: 17, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    func testBodyDefaultFont(){
        let font = UIStyle.Font.bodyDefault
        let expectedFont = UIStyle.font(size: 15, weight: .medium)

        XCTAssertEqual(font, expectedFont)
    }

    func testBodyDefaultPlusFont(){
        let font = UIStyle.Font.bodyDefaultPlus
        let expectedFont = UIStyle.font(size: 15, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    func testBodySmallFont(){
        let font = UIStyle.Font.bodySmall
        let expectedFont = UIStyle.font(size: 13, weight: .medium)

        XCTAssertEqual(font, expectedFont)
    }

    func testBodySmallPlusFont(){
        let font = UIStyle.Font.bodySmallPlus
        let expectedFont = UIStyle.font(size: 13, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    // MARK: - Input -

    func testInputLabelFont(){
        let font = UIStyle.Font.inputLabel
        let expectedFont = UIStyle.font(size: 15, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    // MARK: - Action -

    func testActionLargeFont(){
        let font = UIStyle.Font.actionLarge
        let expectedFont = UIStyle.font(size: 15, weight: .medium)

        XCTAssertEqual(font, expectedFont)
    }

    func testActionDefaultFont(){
        let font = UIStyle.Font.actionDefault
        let expectedFont = UIStyle.font(size: 15, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }
}
