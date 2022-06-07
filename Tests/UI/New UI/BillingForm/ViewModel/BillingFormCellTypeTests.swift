import XCTest
@testable import Frames

class BillingFormCellTests: XCTestCase {

    func testFullNameValidatorType() {
        XCTAssertTrue(BillingFormCell.fullName(nil).validator is FullNameValidator)
    }

    func testaddressLine1ValidatorType() {
        XCTAssertTrue(BillingFormCell.addressLine1(nil).validator is AddressLine1Validator)
    }

    func testaddressLine2ValidatorType() {
        XCTAssertTrue(BillingFormCell.addressLine2(nil).validator is AddressLine2Validator)
    }

    func testCityValidatorType() {
        XCTAssertTrue(BillingFormCell.city(nil).validator is CityValidator)
    }

    func testStateValidatorType() {
        XCTAssertTrue(BillingFormCell.state(nil).validator is StateValidator)
    }

    func testCountryValidatorType() {
        XCTAssertTrue(BillingFormCell.country(nil).validator is CountryValidator)
    }

    func testPostcodeValidatorType() {
        XCTAssertTrue(BillingFormCell.postcode(nil).validator is PostcodeValidator)
    }

    func testPhoneNumberValidatorType() {
        XCTAssertTrue(BillingFormCell.phoneNumber(nil).validator is PhoneNumberValidator)
    }
}
