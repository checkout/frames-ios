import XCTest
@testable import Frames

class PhoneNumberValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCellType.phoneNumber
        let text = ""
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertTrue(isValid)
    }
    
    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCellType.phoneNumber
        let text = "phoneNumber"
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertFalse(isValid)
    }
}
