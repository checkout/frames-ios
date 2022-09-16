import XCTest
@testable import Frames

final class FramesUIStyleColorTests: XCTestCase {

    // MARK: - Background -

    func testBackgroundPrimaryColor(){
        let color = FramesUIStyle.Color.backgroundPrimary
        let expectedColor = UIColor(hex: "#FFFFFF")

        XCTAssertEqual(color, expectedColor)
    }

    // MARK: - Text -

    func testTextPrimaryColor(){
        let color = FramesUIStyle.Color.textPrimary
        let expectedColor = UIColor(hex: "#000000")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextSecondaryColor(){
        let color = FramesUIStyle.Color.textSecondary
        let expectedColor = UIColor(hex: "#727272")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextActionPrimaryColor(){
        let color = FramesUIStyle.Color.textActionPrimary
        let expectedColor = UIColor(hex: "#FFFFFF")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextActionSecondaryColor(){
        let color = FramesUIStyle.Color.textActionSecondary
        let expectedColor = UIColor(hex: "#0B5FF0")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextDisabledColor(){
        let color = FramesUIStyle.Color.textDisabled
        let expectedColor = UIColor(hex: "#727272")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextErrorColor(){
        let color = FramesUIStyle.Color.textError
        let expectedColor = UIColor(hex: "#AD283E")

        XCTAssertEqual(color, expectedColor)
    }

    // MARK: - Border -

    func testBorderPrimaryColor(){
        let color = FramesUIStyle.Color.borderPrimary
        let expectedColor = UIColor(hex: "#8A8A8A")

        XCTAssertEqual(color, expectedColor)
    }

    func testBorderSecondaryColor(){
        let color = FramesUIStyle.Color.borderSecondary
        let expectedColor = UIColor(hex: "#D9D9D9")

        XCTAssertEqual(color, expectedColor)
    }

    func testBorderActiveColor(){
        let color = FramesUIStyle.Color.borderActive
        let expectedColor = UIColor(hex: "#0B5FF0")

        XCTAssertEqual(color, expectedColor)
    }

    func testBorderErrorColor(){
        let color = FramesUIStyle.Color.borderError
        let expectedColor = UIColor(hex: "#AD283E")

        XCTAssertEqual(color, expectedColor)
    }

    // MARK: - Icon -

    func testIconPrimaryColor(){
        let color = FramesUIStyle.Color.iconPrimary
        let expectedColor = UIColor(hex: "#000000")

        XCTAssertEqual(color, expectedColor)
    }

    func testIconDisabledColor(){
        let color = FramesUIStyle.Color.iconDisabled
        let expectedColor = UIColor(hex: "#8A8A8A")

        XCTAssertEqual(color, expectedColor)
    }

    func testIconActionColor(){
        let color = FramesUIStyle.Color.iconAction
        let expectedColor = UIColor(hex: "#0B5FF0")

        XCTAssertEqual(color, expectedColor)
    }

    // MARK: - Action -

    func testActionPrimaryColor(){
        let color = FramesUIStyle.Color.actionPrimary
        let expectedColor = UIColor(hex: "#0B5FF0")

        XCTAssertEqual(color, expectedColor)
    }

    func testActionDisabledColor(){
        let color = FramesUIStyle.Color.actionDisabled
        let expectedColor = UIColor(hex: "#F0F0F0")

        XCTAssertEqual(color, expectedColor)
    }
}
