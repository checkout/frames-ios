import XCTest
import Checkout
@testable import Frames

class BillingFormViewModelTests: XCTestCase {
    
    func testIntialization() {
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle(), data: nil)
        XCTAssertNotNil(viewModel)
    }

    func testCountryCodeIsNotEmpty() {
        let address = Address(addressLine1: "Test line1",
                              addressLine2: nil,
                              city: "London",
                              state: "London",
                              zip: "N12345",
                              country: nil)
        let phone = Phone(number: "77 1234 1234",
                          country: Country(iso3166Alpha2: "GB"))
        let name = "User 1"
        let billingForm = BillingForm(name: name, address: address, phone: phone)
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle(), data: billingForm)
        XCTAssertEqual(viewModel.country?.iso3166Alpha2.uppercased(), Locale.current.regionCode)
    }

    func testGetHeaderCell() {
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle(), data: nil)
        let view = viewModel.getViewForHeader(sender: UIViewController())
        XCTAssertNotNil(view)
    }
  
    func testValidationWhenTextFieldIsEmptyThenShowError() throws {
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle(), data: nil)
        let expectedType = BillingFormCell.fullName(DefaultBillingFormFullNameCellStyle(isMandatory: true))
        let tag = 0
        let text = ""
        let textField = DefaultBillingFormTextField(type:expectedType, tag: expectedType.index)
        textField.text = text

        viewModel.validate(text: textField.text, cellStyle: expectedType, row: tag)
        let value = try XCTUnwrap(viewModel.errorFlagOfCellType[expectedType.index])
        XCTAssertTrue(value)
    }
    
    func testValidationWhenTextFieldIsNotEmptyThenShowSuccess() {
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle(), data: nil)
        let expectedType = BillingFormCell.fullName(nil)
        let text = "fullName"
        let tag = 0
        let textField = DefaultBillingFormTextField(type: expectedType, tag: tag)
        textField.text = text
        
        viewModel.validate(text: textField.text, cellStyle: expectedType, row: tag)
        XCTAssertEqual(viewModel.errorFlagOfCellType[expectedType.index], false)
    }
    
    func testCallDelegateMethodTextFieldIsChanged() {
        let delegate = BillingFormViewModelMockDelegate()
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle(), data: nil)

        let name = "User 1"
        guard let country = Country(iso3166Alpha2: "GB") else {
            XCTFail("could not find country for GB")
            return
        }

        let textValueOfCellType = [
            BillingFormCell.fullName(nil).index: name ,
            BillingFormCell.postcode(nil).index: "postcode" ,
            BillingFormCell.phoneNumber(nil).index: "12345678" ,
            BillingFormCell.country(nil).index: country.name ?? "GB" ,
            BillingFormCell.city(nil).index: "city" ,
            BillingFormCell.addressLine1(nil).index: "addressLine1" ,
            BillingFormCell.addressLine2(nil).index: "addressLine2" ,
            BillingFormCell.state(nil).index: "state" ]

        let phone = Phone(number: textValueOfCellType[BillingFormCell.phoneNumber(nil).index], country: country)
        let address = Address(addressLine1: textValueOfCellType[BillingFormCell.addressLine1(nil).index],
                              addressLine2: textValueOfCellType[BillingFormCell.addressLine2(nil).index],
                              city: textValueOfCellType[BillingFormCell.city(nil).index],
                              state: textValueOfCellType[BillingFormCell.state(nil).index],
                              zip: textValueOfCellType[BillingFormCell.postcode(nil).index],
                              country: country)

        let data = BillingForm(name: name, address: address, phone: phone)
        viewModel.textValueOfCellType = textValueOfCellType
        viewModel.delegate = delegate
        viewModel.update(country: country)
        viewModel.doneButtonIsPressed(sender: UIViewController())
        
        XCTAssertEqual(delegate.onTapDoneButtonCalledTimes, 1)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWithData?.name, data.name)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWithData?.address?.addressLine1, data.address?.addressLine1)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWithData?.address?.addressLine2, data.address?.addressLine2)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWithData?.address?.zip, data.address?.zip)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWithData?.address?.city, data.address?.city)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWithData?.address?.state, data.address?.state)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWithData?.address?.country?.iso3166Alpha2, data.address?.country?.iso3166Alpha2)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWithData?.address?.country?.dialingCode, data.address?.country?.dialingCode)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWithData?.address?.country?.name, data.address?.country?.name)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWithData?.phone?.number, data.phone?.number)

    }
    
    func testCallDelegateMethodDidFinishEditingBillingForm() {
        let delegate = BillingFormViewModelEditingMockDelegate()
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle(), data: nil)
        let textValueOfCellType =  [BillingFormCell.fullName(nil).index: "fullName" ,
                       BillingFormCell.postcode(nil).index: "postcode" ,
                       BillingFormCell.phoneNumber(nil).index: "phoneNumber" ,
                       BillingFormCell.country(nil).index: "country" ,
                       BillingFormCell.city(nil).index: "city" ,
                       BillingFormCell.addressLine1(nil).index: "addressLine1" ,
                       BillingFormCell.addressLine2(nil).index: "addressLine2" ,
                       BillingFormCell.state(nil).index: "state" ]
        viewModel.textValueOfCellType = textValueOfCellType
        viewModel.editDelegate = delegate
        
        _ = viewModel.textFieldShouldEndEditing(textField: DefaultBillingFormTextField(type: .fullName(nil), tag: 2), replacementString: "text")
        
        XCTAssertEqual(delegate.didFinishEditingBillingFormCalledTimes, 0)
        XCTAssertNil(delegate.didFinishEditingBillingFormLastCalledWithSuccessfully)
    }
    
    func testCallsDelegateWhenViewControllerIsApearing() {
        let delegate = BillingFormViewModelMockDelegate()
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle(), delegate: delegate)
        
        XCTAssertEqual(delegate.onBillingScreenShownCounter, 0)
        viewModel.viewControllerWillAppear()
        XCTAssertEqual(delegate.onBillingScreenShownCounter, 1)
    }
    
}
