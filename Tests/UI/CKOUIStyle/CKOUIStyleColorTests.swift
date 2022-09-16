import XCTest
@testable import Frames

final class UIStyleColorTests: XCTestCase {

    // MARK: - Background -

    func testBackgroundPrimaryColor(){
        let color = UIStyle.Color.backgroundPrimary
        let expectedColor = UIColor(hex: "#FFFFFF")

        XCTAssertEqual(color, expectedColor)
    }

    // MARK: - Text -

    func testTextPrimaryColor(){
        let color = UIStyle.Color.textPrimary
        let expectedColor = UIColor(hex: "#000000")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextSecondaryColor(){
        let color = UIStyle.Color.textSecondary
        let expectedColor = UIColor(hex: "#727272")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextActionPrimaryColor(){
        let color = UIStyle.Color.textActionPrimary
        let expectedColor = UIColor(hex: "#727272")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextActionSecondaryColor(){
        let color = UIStyle.Color.textActionSecondary
        let expectedColor = UIColor(hex: "#0B5FF0")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextDisabledColor(){
        let color = UIStyle.Color.textDisabled
        let expectedColor = UIColor(hex: "#727272")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextErrorColor(){
        let color = UIStyle.Color.textError
        let expectedColor = UIColor(hex: "#AD283E")

        XCTAssertEqual(color, expectedColor)
    }

    // MARK: - Border -

    func testBorderPrimaryColor(){
        let color = UIStyle.Color.borderPrimary
        let expectedColor = UIColor(hex: "#8A8A8A")

        XCTAssertEqual(color, expectedColor)
    }

    func testBorderSecondaryColor(){
        let color = UIStyle.Color.borderSecondary
        let expectedColor = UIColor(hex: "#D9D9D9")

        XCTAssertEqual(color, expectedColor)
    }

    func testBorderActiveColor(){
        let color = UIStyle.Color.borderActive
        let expectedColor = UIColor(hex: "#0B5FF0")

        XCTAssertEqual(color, expectedColor)
    }

    func testBorderErrorColor(){
        let color = UIStyle.Color.borderError
        let expectedColor = UIColor(hex: "#AD283E")

        XCTAssertEqual(color, expectedColor)
    }

    // MARK: - Icon -

    func testIconPrimaryColor(){
        let color = UIStyle.Color.iconPrimary
        let expectedColor = UIColor(hex: "#000000")

        XCTAssertEqual(color, expectedColor)
    }

    func testIconDisabledColor(){
        let color = UIStyle.Color.iconDisabled
        let expectedColor = UIColor(hex: "#8A8A8A")

        XCTAssertEqual(color, expectedColor)
    }

    func testIconActionColor(){
        let color = UIStyle.Color.iconAction
        let expectedColor = UIColor(hex: "#0B5FF0")

        XCTAssertEqual(color, expectedColor)
    }

    // MARK: - Action -

    func testActionPrimaryColor(){
        let color = UIStyle.Color.actionPrimary
        let expectedColor = UIColor(hex: "#0B5FF0")

        XCTAssertEqual(color, expectedColor)
    }

    func testActionDisabledColor(){
        let color = UIStyle.Color.actionDisabled
        let expectedColor = UIColor(hex: "#F0F0F0")

        XCTAssertEqual(color, expectedColor)
    }
}
