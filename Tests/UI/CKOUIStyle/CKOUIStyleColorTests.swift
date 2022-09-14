import XCTest
@testable import Frames

final class CKOUIStyleColorTests: XCTestCase {

    // MARK: - Background -

    func testBackgroundPrimaryColor(){
        let color = CKOUIStyle.Color.backgroundPrimary
        let expectedColor = UIColor(hex: "#FFFFFF")

        XCTAssertEqual(color, expectedColor)
    }

    // MARK: - Text -

    func testTextPrimaryColor(){
        let color = CKOUIStyle.Color.textPrimary
        let expectedColor = UIColor(hex: "#000000")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextSecondaryColor(){
        let color = CKOUIStyle.Color.textSecondary
        let expectedColor = UIColor(hex: "#727272")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextActionPrimaryColor(){
        let color = CKOUIStyle.Color.textActionPrimary
        let expectedColor = UIColor(hex: "#727272")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextActionSecondaryColor(){
        let color = CKOUIStyle.Color.textActionSecondary
        let expectedColor = UIColor(hex: "#0B5FF0")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextDisabledColor(){
        let color = CKOUIStyle.Color.textDisabled
        let expectedColor = UIColor(hex: "#727272")

        XCTAssertEqual(color, expectedColor)
    }

    func testTextErrorColor(){
        let color = CKOUIStyle.Color.textError
        let expectedColor = UIColor(hex: "#AD283E")

        XCTAssertEqual(color, expectedColor)
    }

    // MARK: - Border -

    func testBorderPrimaryColor(){
        let color = CKOUIStyle.Color.borderPrimary
        let expectedColor = UIColor(hex: "#8A8A8A")

        XCTAssertEqual(color, expectedColor)
    }

    func testBorderSecondaryColor(){
        let color = CKOUIStyle.Color.borderSecondary
        let expectedColor = UIColor(hex: "#D9D9D9")

        XCTAssertEqual(color, expectedColor)
    }

    func testBorderActiveColor(){
        let color = CKOUIStyle.Color.borderActive
        let expectedColor = UIColor(hex: "#0B5FF0")

        XCTAssertEqual(color, expectedColor)
    }

    func testBorderErrorColor(){
        let color = CKOUIStyle.Color.borderError
        let expectedColor = UIColor(hex: "#AD283E")

        XCTAssertEqual(color, expectedColor)
    }

    // MARK: - Icon -

    func testIconPrimaryColor(){
        let color = CKOUIStyle.Color.iconPrimary
        let expectedColor = UIColor(hex: "#000000")

        XCTAssertEqual(color, expectedColor)
    }

    func testIconDisabledColor(){
        let color = CKOUIStyle.Color.iconDisabled
        let expectedColor = UIColor(hex: "#8A8A8A")

        XCTAssertEqual(color, expectedColor)
    }

    func testIconActionColor(){
        let color = CKOUIStyle.Color.iconAction
        let expectedColor = UIColor(hex: "#0B5FF0")

        XCTAssertEqual(color, expectedColor)
    }

    // MARK: - Action -

    func testActionPrimaryColor(){
        let color = CKOUIStyle.Color.actionPrimary
        let expectedColor = UIColor(hex: "#0B5FF0")

        XCTAssertEqual(color, expectedColor)
    }

    func testActionDisabledColor(){
        let color = CKOUIStyle.Color.actionDisabled
        let expectedColor = UIColor(hex: "#F0F0F0")

        XCTAssertEqual(color, expectedColor)
    }
}
