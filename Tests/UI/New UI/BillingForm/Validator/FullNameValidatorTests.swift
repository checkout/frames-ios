import XCTest
@testable import Frames

class FullNameValidatorTests: XCTestCase {

    func testValidationWhenTextIsEmptyThenShouldBeTrue() {
        let expectedType = BillingFormCellType.fullName
        let text = ""
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertEqual(isValid, true)
    }
    
    func testValidationWhenTextIsNonEmptyThenShouldBeFalse() {
        let expectedType = BillingFormCellType.fullName
        let text = "fullName"
        let isValid = expectedType.validator.validate(text: text)
        XCTAssertEqual(isValid, false)
    }
}
