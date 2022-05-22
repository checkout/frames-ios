import XCTest
@testable import Frames

final class GraphikFontTests: XCTestCase {
    private let fontFamilyName = "GraphikLCG"
    private var expectedType: UIFont.GraphikStyle!

    override func setUp() {
        super.setUp()
        UIFont.loadAllCheckoutFonts
    }

    // MARK: - Black

    func testTypeForBlack() {
        let type = "Black"

        expectedType = .black

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForBlack() {
        let fontName = getFontName(for: "Black")

        expectedType = .black

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForBlack() {
        let font = UIFont(graphikStyle: .black, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - Black Italic

    func testTypeForBlackItalic() {
        let type = "BlackItalic"

        expectedType = .blackItalic

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForBlackItalic() {
        let fontName = getFontName(for: "BlackItalic")

        expectedType = .blackItalic

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForBlackItalic() {
        let font = UIFont(graphikStyle: .blackItalic, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - Bold

    func testTypeForBold() {
        let type = "Bold"

        expectedType = .bold

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForBold() {
        let fontName = getFontName(for: "Bold")

        expectedType = .bold

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForBold() {
        let font = UIFont(graphikStyle: .bold, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - Bold Italic

    func testTypeForBoldItalic() {
        let type = "BoldItalic"

        expectedType = .boldItalic

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForBoldItalic() {
        let fontName = getFontName(for: "BoldItalic")

        expectedType = .boldItalic

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForBoldItalic() {
        let font = UIFont(graphikStyle: .boldItalic, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - ExtraLight

    func testTypeForExtraLight() {
        let type = "Extralight"

        expectedType = .extraLight

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForExtraLight() {
        let fontName = getFontName(for: "Extralight")

        expectedType = .extraLight

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForExtraLight() {
        let font = UIFont(graphikStyle: .extraLight, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - ExtraLight Italic

    func testTypeForExtraLightItalic() {
        let type = "ExtralightItalic"

        expectedType = .extraLightItalic

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForExtraLightItalic() {
        let fontName = getFontName(for: "ExtralightItalic")

        expectedType = .extraLightItalic

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForExtraLightItalic() {
        let font = UIFont(graphikStyle: .extraLightItalic, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - Light

    func testTypeForLight() {
        let type = "Light"

        expectedType = .light

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForLight() {
        let fontName = getFontName(for: "Light")

        expectedType = .light

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForLight() {
        let font = UIFont(graphikStyle: .light, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - Light Italic

    func testTypeForLightItalic() {
        let type = "LightItalic"

        expectedType = .lightItalic

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForLightItalic() {
        let fontName = getFontName(for: "LightItalic")

        expectedType = .lightItalic

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForLightItalic() {
        let font = UIFont(graphikStyle: .lightItalic, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - Medium

    func testTypeForMedium() {
        let type = "Medium"

        expectedType = .medium

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForMedium() {
        let fontName = getFontName(for: "Medium")

        expectedType = .medium

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForMedium() {
        let font = UIFont(graphikStyle: .medium, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - Medium Italic

    func testTypeForMediumItalic() {
        let type = "MediumItalic"

        expectedType = .mediumItalic

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForMediumItalic() {
        let fontName = getFontName(for: "MediumItalic")

        expectedType = .mediumItalic

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForMediumItalic() {
        let font = UIFont(graphikStyle: .mediumItalic, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - Regular

    func testTypeForRegular() {
        let type = "Regular"

        expectedType = .regular

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForRegular() {
        let fontName = getFontName(for: "Regular")

        expectedType = .regular

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForRegular() {
        let font = UIFont(graphikStyle: .regular, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - Regular Italic

    func testTypeForRegularItalic() {
        let type = "RegularItalic"

        expectedType = .regularItalic

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForRegularItalic() {
        let fontName = getFontName(for: "RegularItalic")

        expectedType = .regularItalic

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForRegularItalic() {
        let font = UIFont(graphikStyle: .regularItalic, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - SemiBold

    func testTypeForSemiBold() {
        let type = "Semibold"

        expectedType = .semibold

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForSemiBold() {
        let fontName = getFontName(for: "Semibold")

        expectedType = .semibold

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForSemiBold() {
        let font = UIFont(graphikStyle: .semibold, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - SemiBold Italic

    func testTypeForSemiBoldItalic() {
        let type = "SemiboldItalic"

        expectedType = .semiboldItalic

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForSemiBoldItalic() {
        let fontName = getFontName(for: "SemiboldItalic")

        expectedType = .semiboldItalic

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForSemiBoldItalic() {
        let font = UIFont(graphikStyle: .semiboldItalic, size: 20)

        XCTAssertNotNil(font)
    }
    
    // MARK: - Super

    func testTypeForSuper() {
        let type = "Super"

        expectedType = .super

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForSuper() {
        let fontName = getFontName(for: "Super")

        expectedType = .super

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForSuper() {
        let font = UIFont(graphikStyle: .super, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - Super Italic

    func testTypeForSuperItalic() {
        let type = "SuperItalic"

        expectedType = .superItalic

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForSuperItalic() {
        let fontName = getFontName(for: "SuperItalic")

        expectedType = .superItalic

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForSuperItalic() {
        let font = UIFont(graphikStyle: .superItalic, size: 20)

        XCTAssertNotNil(font)
    }


    // MARK: - Thin

    func testTypeForThin() {
        let type = "Thin"

        expectedType = .thin

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForThin() {
        let fontName = getFontName(for: "Thin")

        expectedType = .thin

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForThin() {
        let font = UIFont(graphikStyle: .thin, size: 20)

        XCTAssertNotNil(font)
    }

    // MARK: - Thin Italic

    func testTypeForThinItalic() {
        let type = "ThinItalic"

        expectedType = .thinItalic

        XCTAssertEqual(expectedType.rawValue, type)
    }

    func testNameForThinItalic() {
        let fontName = getFontName(for: "ThinItalic")

        expectedType = .thinItalic

        XCTAssertEqual(expectedType.fontName, fontName)
    }

    func testFontForThinItalic() {
        let font = UIFont(graphikStyle: .thinItalic, size: 20)

        XCTAssertNotNil(font)
    }

    private func getFontName(for type: String) -> String {
        "\(fontFamilyName)-\(type)"
    }
}
