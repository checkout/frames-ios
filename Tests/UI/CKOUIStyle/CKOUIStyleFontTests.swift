import XCTest
@testable import Frames

final class CKOUIStyleFontTests: XCTestCase {

    func testCKOUIStyleFont() {
        let font = CKOUIStyle.font(size: 15, weight: .regular)
        let expectedFont =  UIFont.systemFont(ofSize: 15, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    // MARK: - Title -

    func testTitle2Font(){
        let font = CKOUIStyle.Font.title2
        let expectedFont = CKOUIStyle.font(size: 24, weight: .medium)

        XCTAssertEqual(font, expectedFont)
    }

    func testHeadlineFont(){
        let font = CKOUIStyle.Font.headline
        let expectedFont = CKOUIStyle.font(size: 17, weight: .semibold)

        XCTAssertEqual(font, expectedFont)
    }

    // MARK: - Body -

    func testBodyLargeFont(){
        let font = CKOUIStyle.Font.bodyLarge
        let expectedFont = CKOUIStyle.font(size: 17, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    func testBodyDefaultFont(){
        let font = CKOUIStyle.Font.bodyDefault
        let expectedFont = CKOUIStyle.font(size: 15, weight: .medium)

        XCTAssertEqual(font, expectedFont)
    }

    func testBodyDefaultPlusFont(){
        let font = CKOUIStyle.Font.bodyDefaultPlus
        let expectedFont = CKOUIStyle.font(size: 15, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    func testBodySmallFont(){
        let font = CKOUIStyle.Font.bodySmall
        let expectedFont = CKOUIStyle.font(size: 13, weight: .medium)

        XCTAssertEqual(font, expectedFont)
    }

    func testBodySmallPlusFont(){
        let font = CKOUIStyle.Font.bodySmallPlus
        let expectedFont = CKOUIStyle.font(size: 13, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    // MARK: - Input -

    func testInputLabelFont(){
        let font = CKOUIStyle.Font.inputLabel
        let expectedFont = CKOUIStyle.font(size: 15, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    // MARK: - Action -

    func testActionLargeFont(){
        let font = CKOUIStyle.Font.actionLarge
        let expectedFont = CKOUIStyle.font(size: 15, weight: .medium)

        XCTAssertEqual(font, expectedFont)
    }

    func testActionDefaultFont(){
        let font = CKOUIStyle.Font.actionDefault
        let expectedFont = CKOUIStyle.font(size: 15, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }
}
