import XCTest
@testable import Frames

class BillingFormCellTypeTests: XCTestCase {
    
    
    
    func testFullNameValidatorType(){
        XCTAssertTrue(BillingFormCellType.fullName.validator is FullNameValidator)
    }
    
    func testaddressLine1ValidatorType(){
        XCTAssertTrue(BillingFormCellType.addressLine1.validator is AddressLine1Validator)
    }
    
    func testaddressLine2ValidatorType(){
        XCTAssertTrue(BillingFormCellType.addressLine2.validator is AddressLine2Validator)
    }
    
    func testCityValidatorType(){
        XCTAssertTrue(BillingFormCellType.city.validator is CityValidator)
    }
    
    func testStateValidatorType(){
        XCTAssertTrue(BillingFormCellType.state.validator is StateValidator)
    }
    
    func testCountryValidatorType(){
        XCTAssertTrue(BillingFormCellType.country.validator is CountryValidator)
    }
    
    func testPostcodeValidatorType(){
        XCTAssertTrue(BillingFormCellType.postcode.validator is PostcodeValidator)
    }
    
    func testPhoneNumberValidatorType(){
        XCTAssertTrue(BillingFormCellType.phoneNumber.validator is PhoneNumberValidator)
    }
}
