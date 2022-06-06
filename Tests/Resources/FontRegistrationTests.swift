import XCTest
@testable import Frames

final class FontRegistrationTests: XCTestCase{
    let fileName = "GraphikLCG-Bold"
    let ext = "otf"
    var bundle:Foundation.Bundle!

    override func setUp() {
        super.setUp()
        bundle = fileName.getBundle(forClass: CheckoutTheme.self)
    }

    func testFrameSDKBundleExistence(){
        XCTAssertNotNil(bundle)
    }

    func testPathForResourceString(){
        let pathForResourceString = bundle.url(forResource: fileName, withExtension: ext)

        XCTAssertNotNil(pathForResourceString)
    }

    func testFontData() throws {
        let pathForResourceString = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: ext))

        let fontData = NSData(contentsOf: pathForResourceString)

        XCTAssertNotNil(fontData)
    }

    func testFontDataProvider() throws {
        let pathForResourceString = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: ext))
        let fontData = try XCTUnwrap(NSData(contentsOf: pathForResourceString))

        let dataProvider = CGDataProvider.init(data: fontData)

        XCTAssertNotNil(dataProvider)
    }

    func testFontReference() throws {
        let pathForResourceString = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: ext))
        let fontData = try XCTUnwrap(NSData(contentsOf: pathForResourceString))
        let dataProvider = try XCTUnwrap(CGDataProvider.init(data: fontData))

        let fontRef = CGFont(dataProvider)

        XCTAssertNotNil(fontRef)
    }

    func testFontManagerRegisterGraphikLCGFont() throws {
        let pathForResourceString = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: ext))
        let fontData = try XCTUnwrap(NSData(contentsOf: pathForResourceString))
        let dataProvider = try XCTUnwrap(CGDataProvider.init(data: fontData))
        let fontRef = try XCTUnwrap(CGFont(dataProvider))
        var errorRef: Unmanaged<CFError>?
        let manager = CTFontManagerRegisterGraphicsFont(fontRef, &errorRef)

        guard let errorRef: Error = errorRef?.takeRetainedValue() else {
            XCTAssertTrue(manager)
            XCTAssertNil(errorRef)
            return
        }

        let code = (errorRef as NSError).code
        guard code == CTFontManagerError.alreadyRegistered.rawValue else {
            XCTFail("UIFont: Failed to register font with error: \(errorRef)")
            return
        }

    }

}
