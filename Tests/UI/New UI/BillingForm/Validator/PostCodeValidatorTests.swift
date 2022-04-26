import XCTest
@testable import Frames

class PostCodeValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCellType.postcode
        let text = ""
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertEqual(isValid, true)
    }
    
    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCellType.postcode
        let text = "postcode"
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertEqual(isValid, false)
    }
}
