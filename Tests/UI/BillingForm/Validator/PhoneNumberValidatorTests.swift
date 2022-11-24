import XCTest
import Checkout
@testable import Frames

class PhoneNumberValidatorTests: XCTestCase {

    func testShouldAcceptEmptyInput() {
        let testString = ""
        let validator = PhoneNumberValidator()
        XCTAssertTrue(validator.shouldAccept(text: testString))
    }
    
    func testShouldAcceptNonNumericalInput() {
        let testString = "acJGy9^$.achtgfl)= Htha73"
        let validator = PhoneNumberValidator()
        XCTAssertFalse(validator.shouldAccept(text: testString))
    }
    
    func testShouldAcceptValidCharacterInput() {
        let testString = "12 + 0345 6789"
        let validator = PhoneNumberValidator()
        XCTAssertTrue(validator.shouldAccept(text: testString))
    }
    
    func testShouldAcceptOversizedInput() {
        var testString = ""
        (0...Checkout.Constants.Phone.phoneMaxLength).forEach { _ in
            testString.append("1")
        }
        let validator = PhoneNumberValidator()
        XCTAssertFalse(validator.shouldAccept(text: testString))
    }
    
    func testIsValidEmptyInput() {
        let testString = ""
        let validator = PhoneNumberValidator()
        XCTAssertFalse(validator.isValid(text: testString))
    }

    func testIsValidInputInvalidCharacters() {
        let testString = "acJGy9^$.achtgfl)= Htha73"
        let validator = PhoneNumberValidator()
        XCTAssertFalse(validator.isValid(text: testString))
    }
    
    func testIsValidInputValidCharactersNotPhoneNumber() {
        let testString = "+1234567890123"
        let validator = PhoneNumberValidator()
        XCTAssertFalse(validator.isValid(text: testString))
    }

    func testIsValidInputValidLocalePhoneNumber() {
        let testString = "01206333222"
        let validator = PhoneNumberValidator()
        XCTAssertTrue(validator.isValid(text: testString))
    }
    
    func testIsValidInputValidInternationalPhoneNumber() {
        let testString = "+919999999999"
        let validator = PhoneNumberValidator()
        XCTAssertTrue(validator.isValid(text: testString))
    }
    
    func testFormatForDisplayInvalidString() {
        let testString = "acJGy9^$.achtgfl)= Htha73"
        let validator = PhoneNumberValidator()
        XCTAssertEqual(validator.formatForDisplay(text: testString), testString)
    }
    
    func testFormatForDisplayValidStringInvalidPhoneNumber() {
        let testString = "012345678901234"
        let validator = PhoneNumberValidator()
        XCTAssertEqual(validator.formatForDisplay(text: testString), testString)
    }
    
    func testFormatForDisplayInternationPhoneNumber() {
        let testString = "+919999999999"
        let validator = PhoneNumberValidator()
        XCTAssertEqual(validator.formatForDisplay(text: testString), "+91 99999 99999")
    }
    
    func testFormatForDisplayValidPhoneNumber() {
        let testString = "01206321321"
        let validator = PhoneNumberValidator()
        XCTAssertEqual(validator.formatForDisplay(text: testString), "+44 1206 321321")
    }
    
}
