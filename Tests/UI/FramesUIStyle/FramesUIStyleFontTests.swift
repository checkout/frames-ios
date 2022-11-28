import XCTest
@testable import Frames

final class FramesUIStyleFontTests: XCTestCase {

    func testFramesUIStyleFont() {
        let font = FramesUIStyle.font(size: 15, weight: .regular)
        let expectedFont =  UIFont.systemFont(ofSize: 15, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    // MARK: - Title -

    func testTitle2Font(){
        let font = FramesUIStyle.Font.title2
        let expectedFont = FramesUIStyle.font(size: 24, weight: .medium)

        XCTAssertEqual(font, expectedFont)
    }

    func testHeadlineFont(){
        let font = FramesUIStyle.Font.headline
        let expectedFont = FramesUIStyle.font(size: 17, weight: .semibold)

        XCTAssertEqual(font, expectedFont)
    }

    // MARK: - Body -

    func testBodyLargeFont(){
        let font = FramesUIStyle.Font.bodyLarge
        let expectedFont = FramesUIStyle.font(size: 17, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    func testBodyDefaultFont(){
        let font = FramesUIStyle.Font.bodyDefault
        let expectedFont = FramesUIStyle.font(size: 15, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    func testBodyDefaultPlusFont(){
        let font = FramesUIStyle.Font.bodyDefaultPlus
        let expectedFont = FramesUIStyle.font(size: 15, weight: .medium)

        XCTAssertEqual(font, expectedFont)
    }

    func testBodySmallFont(){
        let font = FramesUIStyle.Font.bodySmall
        let expectedFont = FramesUIStyle.font(size: 13, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    func testBodySmallPlusFont(){
        let font = FramesUIStyle.Font.bodySmallPlus
        let expectedFont = FramesUIStyle.font(size: 13, weight: .medium)

        XCTAssertEqual(font, expectedFont)
    }

    // MARK: - Input -

    func testInputLabelFont(){
        let font = FramesUIStyle.Font.inputLabel
        let expectedFont = FramesUIStyle.font(size: 15, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }

    // MARK: - Action -

    func testActionLargeFont(){
        let font = FramesUIStyle.Font.actionLarge
        let expectedFont = FramesUIStyle.font(size: 15, weight: .medium)

        XCTAssertEqual(font, expectedFont)
    }

    func testActionDefaultFont(){
        let font = FramesUIStyle.Font.actionDefault
        let expectedFont = FramesUIStyle.font(size: 15, weight: .regular)

        XCTAssertEqual(font, expectedFont)
    }
}
