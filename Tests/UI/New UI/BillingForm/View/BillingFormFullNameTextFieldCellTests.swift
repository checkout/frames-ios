import XCTest
@testable import Frames

class BillingFormTextFieldCellTests: XCTestCase {
    var cell: BillingFormTextFieldCell!
    
    override func setUp() {
        super.setUp()
        cell = BillingFormTextFieldCell()
    }
    
    func testCallDelegateMethodTextFieldShouldBeginEditing() {
        let delegate = BillingFormTextFieldCellMockDelegate()
        let textField = BillingFormTextField(type: .fullName(nil), tag: 2)
        cell.delegate = delegate
        
        cell.textFieldShouldBeginEditing(textField: textField)
        
        XCTAssertEqual(delegate.textFieldShouldBeginEditingCalledTimes, 1)
        XCTAssertEqual(delegate.textFieldShouldBeginEditingLastCalledWithTextField, textField)
    }
    
    func testCallDelegateMethodTextFieldShouldReturn() {
        let delegate = BillingFormTextFieldCellMockDelegate()
        cell.delegate = delegate
        
        cell.textFieldShouldReturn()
        XCTAssertEqual(delegate.textFieldShouldReturnCalledTimes, 1)
    }
    
    func testCallDelegateMethodTextFieldDidEndEditing() {
        let delegate = BillingFormTextFieldCellMockDelegate()
        let textField = BillingFormTextField(type: .fullName(nil), tag: 2)
        cell.delegate = delegate
        
        cell.textFieldShouldEndEditing(textField: textField, replacementString: "test")
        
        XCTAssertEqual(delegate.textFieldShouldEndEditingCalledTimes, 1)
        XCTAssertEqual(delegate.textFieldShouldEndEditingLastCalledWithTextField, textField)
    }
    
}
