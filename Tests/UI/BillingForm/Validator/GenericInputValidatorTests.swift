import XCTest
@testable import Frames

class GenericInputValidatorTests: XCTestCase {

    func testShouldAcceptEmptyInput() {
        let testString = ""
        let validator = GenericInputValidator()
        XCTAssertTrue(validator.shouldAccept(text: testString))
    }
                      

    func testShouldAcceptInput() {
        let testString = "acJGy9^$.achtgfl)= Htha73"
        let validator = GenericInputValidator()
        XCTAssertTrue(validator.shouldAccept(text: testString))
    }
    
    func testIsValidEmptyInput() {
        let testString = ""
        let validator = GenericInputValidator()
        XCTAssertFalse(validator.isValid(text: testString))
    }
    
    func testIsValidInput() {
        let testString = "acJGy9^$.achtgfl)= Htha73"
        let validator = GenericInputValidator()
        XCTAssertTrue(validator.isValid(text: testString))
    }
    
    func testFormatForDisplay() {
        let testString = "acJGy9^$.achtgfl)= Htha73"
        let validator = GenericInputValidator()
        XCTAssertEqual(validator.formatForDisplay(text: testString), testString)
    }
    
}
