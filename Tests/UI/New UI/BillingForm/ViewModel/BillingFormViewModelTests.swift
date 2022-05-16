import XCTest
import Checkout
@testable import Frames

class BillingFormViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UIFont.loadAllFonts
    }
    
    func testIntialization() {
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle())
        XCTAssertNotNil(viewModel)
    }
    
    // TableView Cells
    func testGetHeaderCell() {
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle())
        let view = viewModel.getViewForHeader(sender: UIViewController())
        XCTAssertNotNil(view)
    }
  
    func testValidationWhenTextFieldIsEmptyThenShowError() {
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle())
        let expectedType = BillingFormCell.fullName(DefaultBillingFormFullNameCellStyle(isOptinal: false))
        let tag = 2
        let text = ""
        let textField = BillingFormTextField(type:expectedType, tag: expectedType.hash)
        textField.text = text

        viewModel.validate(text: textField.text, cellStyle: expectedType, row: tag)
        XCTAssertEqual( viewModel.errorFlagOfCellType[expectedType.hash], true)
    }
    
    func testValidationWhenTextFieldIsNotEmptyThenShowSuccess() {
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle())
        let expectedType = BillingFormCell.fullName(nil)
        let text = "fullName"
        let tag = 2
        let textField = BillingFormTextField(type: expectedType, tag: tag)
        textField.text = text
        
        viewModel.validate(text: textField.text, cellStyle: expectedType, row: tag)
        XCTAssertEqual( viewModel.errorFlagOfCellType[expectedType.hash], false)
    }
    
    func testCallDelegateMethodTextFieldIsChanged() {
        let delegate = BillingFormViewModelMockDelegate()
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle())
        let textValueOfCellType =  [
                       BillingFormCell.fullName(nil).hash: "fullName" ,
                       BillingFormCell.postcode(nil).hash: "postcode" ,
                       BillingFormCell.phoneNumber(nil).hash: "phoneNumber" ,
                       BillingFormCell.country(nil).hash: "country" ,
                       BillingFormCell.city(nil).hash: "city" ,
                       BillingFormCell.addressLine1(nil).hash: "addressLine1" ,
                       BillingFormCell.addressLine2(nil).hash: "addressLine2" ,
                       BillingFormCell.state(nil).hash: "state" ]
        
        let phone = Phone(number: textValueOfCellType[BillingFormCell.phoneNumber(nil).hash], country: nil)
        
        let address = Address(addressLine1: textValueOfCellType[BillingFormCell.addressLine1(nil).hash],
                                 addressLine2: textValueOfCellType[BillingFormCell.addressLine2(nil).hash],
                                 city: textValueOfCellType[BillingFormCell.city(nil).hash],
                                 state: textValueOfCellType[BillingFormCell.state(nil).hash],
                                 zip: textValueOfCellType[BillingFormCell.postcode(nil).hash],
                                 country: nil)
        
        viewModel.textValueOfCellType = textValueOfCellType
        viewModel.delegate = delegate
        
        viewModel.doneButtonIsPressed(sender: UIViewController())
        
        XCTAssertEqual(delegate.onTapDoneButtonCalledTimes, 1)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWithNumber, phone)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWithAddress, address)
    }
    
    func testCallDelegateMethodDidFinishEditingBillingForm() {
        let delegate = BillingFormViewModelEditingMockDelegate()
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle())
        let textValueOfCellType =  [BillingFormCell.fullName(nil).hash: "fullName" ,
                       BillingFormCell.postcode(nil).hash: "postcode" ,
                       BillingFormCell.phoneNumber(nil).hash: "phoneNumber" ,
                       BillingFormCell.country(nil).hash: "country" ,
                       BillingFormCell.city(nil).hash: "city" ,
                       BillingFormCell.addressLine1(nil).hash: "addressLine1" ,
                       BillingFormCell.addressLine2(nil).hash: "addressLine2" ,
                       BillingFormCell.state(nil).hash: "state" ]
        viewModel.textValueOfCellType = textValueOfCellType
        viewModel.editDelegate = delegate
        
        viewModel.textFieldShouldEndEditing(textField: BillingFormTextField(type: .fullName(nil), tag: 2), replacementString: "text")
        
        XCTAssertEqual(delegate.didFinishEditingBillingFormCalledTimes, 0)
        XCTAssertNil(delegate.didFinishEditingBillingFormLastCalledWithSuccessfully)
    }
    
}
