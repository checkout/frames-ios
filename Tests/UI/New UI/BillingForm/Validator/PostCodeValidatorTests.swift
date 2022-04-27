import XCTest
@testable import Frames

class PostcodeValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCellType.postcode
        let text = ""
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertTrue(isValid)
    }
    
    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCellType.postcode
        let text = "postcode"
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertFalse(isValid)
    }
}
