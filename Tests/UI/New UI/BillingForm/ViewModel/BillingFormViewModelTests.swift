import XCTest
@testable import Frames

class BillingFormViewModelTests: XCTestCase {
    
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
        let expectation = expectation(description: #function)
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle())
        let expectedType = BillingFormCellType.fullName
        let tag = 2
        let text = ""
        let textField = BillingFormTextField(type: expectedType, tag: tag)
        textField.text = text

        viewModel.updateRow = {
            XCTAssertEqual(viewModel.updatedRow, tag)
            XCTAssertEqual(viewModel.errorFlagOfCellType[expectedType], true)
            XCTAssertEqual(viewModel.textValueOfCellType[expectedType], text)
            expectation.fulfill()
        }

        viewModel.validate(textField: textField)
        waitForExpectations(timeout: 1)
    }
    
    func testValidationWhenTextFieldIsNotEmptyThenShowSuccess() {
        let expectation = expectation(description: #function)
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle())
        let expectedType = BillingFormCellType.fullName
        let text = "fullName"
        let tag = 2
        let textField = BillingFormTextField(type: expectedType, tag: tag)
        textField.text = text
        
        viewModel.updateRow = {
            XCTAssertEqual(viewModel.updatedRow, tag)
            XCTAssertEqual(viewModel.errorFlagOfCellType[expectedType], false)
            XCTAssertEqual(viewModel.textValueOfCellType[expectedType], text)
            expectation.fulfill()
        }

        viewModel.validate(textField: textField)
        waitForExpectations(timeout: 1)
    }
    
    func testCallDelegateMethodTextFieldIsChanged() {
        let delegate = BillingFormViewModelMockDelegate()
        let viewModel = DefaultBillingFormViewModel(style: DefaultBillingFormStyle())
        let textValueOfCellType =  [BillingFormCellType.fullName: "fullName" ,
                       BillingFormCellType.postcode: "postcode" ,
                       BillingFormCellType.phoneNumber: "phoneNumber" ,
                       BillingFormCellType.country: "country" ,
                       BillingFormCellType.city: "city" ,
                       BillingFormCellType.addressLine1: "addressLine1" ,
                       BillingFormCellType.addressLine2: "addressLine2" ,
                       BillingFormCellType.state: "state" ]
        
        let countryCode = "44" //"\(addressView.phoneInputView.phoneNumber?.countryCode ?? 44)"
        let phone = CkoPhoneNumber(countryCode: countryCode, number: textValueOfCellType[.phoneNumber])
        let address = CkoAddress(addressLine1: textValueOfCellType[.addressLine1],
                                 addressLine2: textValueOfCellType[.addressLine2],
                                 city: textValueOfCellType[.city],
                                 state: textValueOfCellType[.state],
                                 zip: textValueOfCellType[.postcode],
                                 country: textValueOfCellType[.country])
        
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
        let textValueOfCellType =  [BillingFormCellType.fullName: "fullName" ,
                       BillingFormCellType.postcode: "postcode" ,
                       BillingFormCellType.phoneNumber: "phoneNumber" ,
                       BillingFormCellType.country: "country" ,
                       BillingFormCellType.city: "city" ,
                       BillingFormCellType.addressLine1: "addressLine1" ,
                       BillingFormCellType.addressLine2: "addressLine2" ,
                       BillingFormCellType.state: "state" ]
        viewModel.textValueOfCellType = textValueOfCellType
        viewModel.editDelegate = delegate
        
        viewModel.textFieldShouldEndEditing(textField: BillingFormTextField(type: .fullName, tag: 2), replacementString: "text")
        
        XCTAssertEqual(delegate.didFinishEditingBillingFormCalledTimes, 1)
        XCTAssertEqual(delegate.didFinishEditingBillingFormLastCalledWithSuccessfully, true)
    }
    
}