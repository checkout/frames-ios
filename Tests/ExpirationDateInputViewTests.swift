import XCTest
@testable import FramesIos

class ExpirationDateInputViewTests: XCTestCase {

    func testEmptyInitialization() {
        let expirationDateInputView = ExpirationDateInputView()
        let typeInputView = type(of: expirationDateInputView.textField.inputView as? ExpirationDatePicker)
        XCTAssertEqual(String(describing: typeInputView), String(describing: ExpirationDatePicker?.self))
    }

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let expirationDateInputView = ExpirationDateInputView(coder: coder)
        let typeInputView = type(of: expirationDateInputView?.textField.inputView as? ExpirationDatePicker)
        XCTAssertEqual(String(describing: typeInputView), String(describing: ExpirationDatePicker?.self))
    }

    func testFrameInitialization() {
        let expirationDateInputView = ExpirationDateInputView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
        let typeInputView = type(of: expirationDateInputView.textField.inputView as? ExpirationDatePicker)
        XCTAssertEqual(String(describing: typeInputView), String(describing: ExpirationDatePicker?.self))
    }

    func testChangeTextOnDateChanged() {
        let expirationDateInputView = ExpirationDateInputView()
        expirationDateInputView.onDateChanged(month: "12", year: "2019")
        XCTAssertEqual(expirationDateInputView.textField.text, "12/2019")
    }

}
