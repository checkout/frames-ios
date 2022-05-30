import XCTest
import Checkout
@testable import Frames

class BillingFormViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UIFont.loadAllCheckoutFonts
    }
    
    func testIntialization() {
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle(), data: nil)
        XCTAssertNotNil(viewModel)
    }
    
    // TableView Cells
    func testGetHeaderCell() {
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle(), data: nil)
        let view = viewModel.getViewForHeader(sender: UIViewController())
        XCTAssertNotNil(view)
    }
  
    func testValidationWhenTextFieldIsEmptyThenShowError() throws {
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle(), data: nil)
        let expectedType = BillingFormCell.fullName(DefaultBillingFormFullNameCellStyle(isOptional: false))
        let tag = 2
        let text = ""
        let textField = BillingFormTextField(type:expectedType, tag: expectedType.index)
        textField.text = text

        viewModel.validate(text: textField.text, cellStyle: expectedType, row: tag)
        let value = try XCTUnwrap(viewModel.errorFlagOfCellType[expectedType.index])
        XCTAssertTrue(value)
    }
    
    func testValidationWhenTextFieldIsNotEmptyThenShowSuccess() {
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle(), data: nil)
        let expectedType = BillingFormCell.fullName(nil)
        let text = "fullName"
        let tag = 2
        let textField = BillingFormTextField(type: expectedType, tag: tag)
        textField.text = text
        
        viewModel.validate(text: textField.text, cellStyle: expectedType, row: tag)
        XCTAssertEqual( viewModel.errorFlagOfCellType[expectedType.index], false)
    }
    
    func testCallDelegateMethodTextFieldIsChanged() {
        let delegate = BillingFormViewModelMockDelegate()
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle(), data: nil)
        let textValueOfCellType = [
                       BillingFormCell.fullName(nil).index: "fullName" ,
                       BillingFormCell.postcode(nil).index: "postcode" ,
                       BillingFormCell.phoneNumber(nil).index: "phoneNumber" ,
                       BillingFormCell.country(nil).index: "country" ,
                       BillingFormCell.city(nil).index: "city" ,
                       BillingFormCell.addressLine1(nil).index: "addressLine1" ,
                       BillingFormCell.addressLine2(nil).index: "addressLine2" ,
                       BillingFormCell.state(nil).index: "state" ]
        
        let phone = Phone(number: textValueOfCellType[BillingFormCell.phoneNumber(nil).index], country: nil)
        
        let address = Address(addressLine1: textValueOfCellType[BillingFormCell.addressLine1(nil).index],
                                 addressLine2: textValueOfCellType[BillingFormCell.addressLine2(nil).index],
                                 city: textValueOfCellType[BillingFormCell.city(nil).index],
                                 state: textValueOfCellType[BillingFormCell.state(nil).index],
                                 zip: textValueOfCellType[BillingFormCell.postcode(nil).index],
                                 country: nil)
        let data = BillingFormData(address: address, phone: phone)
        viewModel.textValueOfCellType = textValueOfCellType
        viewModel.delegate = delegate
        
        viewModel.doneButtonIsPressed(sender: UIViewController())
        
        XCTAssertEqual(delegate.onTapDoneButtonCalledTimes, 1)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWithData, data)
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
        
        viewModel.textFieldShouldEndEditing(textField: BillingFormTextField(type: .fullName(nil), tag: 2), replacementString: "text")
        
        XCTAssertEqual(delegate.didFinishEditingBillingFormCalledTimes, 0)
        XCTAssertNil(delegate.didFinishEditingBillingFormLastCalledWithSuccessfully)
    }
    
}
