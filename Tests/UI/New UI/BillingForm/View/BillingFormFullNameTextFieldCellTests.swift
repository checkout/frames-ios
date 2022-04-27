import XCTest
@testable import Frames

class BillingFormTextFieldCellTests: XCTestCase {
    var view: BillingFormTextFieldCell!
    
    override func setUp() {
        super.setUp()
        view = BillingFormTextFieldCell(type: .fullName, style: DefaultBillingFormFullNameCellStyle(), delegate: nil)
    }
    
    func testCallDelegateMethodTextFieldShouldBeginEditing() {
        let delegate = BillingFormTextFieldCellMockDelegate()
        let textField = BillingFormTextField(type: .fullName)
        view.delegate = delegate
        
        view.textFieldShouldBeginEditing(textField: textField)
        
        XCTAssertEqual(delegate.textFieldShouldBeginEditingCalledTimes, 1)
        XCTAssertEqual(delegate.textFieldShouldBeginEditingLastCalledWithTextField, textField)
    }
    
    func testCallDelegateMethodTextFieldShouldReturn() {
        let delegate = BillingFormTextFieldCellMockDelegate()
        view.delegate = delegate
        
        view.textFieldShouldReturn()
        XCTAssertEqual(delegate.textFieldShouldReturnCalledTimes, 1)
    }
    
    func testCallDelegateMethodTextFieldDidEndEditing() {
        let delegate = BillingFormTextFieldCellMockDelegate()
        let textField = BillingFormTextField(type: .fullName)
        view.delegate = delegate
        
        view.textFieldDidEndEditing(textField: textField)
        
        XCTAssertEqual(delegate.textFieldDidEndEditingCalledTimes, 1)
        XCTAssertEqual(delegate.textFieldDidEndEditingLastCalledWithTextField, textField)
    }
    
    func testCallDelegateMethodTextFieldDidChangeCharacters() {
        let delegate = BillingFormTextFieldCellMockDelegate()
        let textField = BillingFormTextField(type: .fullName)
        let text = "test"
        view.delegate = delegate
        
        view.textFieldDidChangeCharacters(textField: textField, replacementString: text)
        
        XCTAssertEqual(delegate.textFieldDidChangeCharactersCalledTimes, 1)
        XCTAssertEqual(delegate.textFieldDidChangeCharactersLastCalledWithTextField, textField)
        XCTAssertEqual(delegate.textFieldDidChangeCharactersLastCalledWithReplacementString, text)
    }
    
}
