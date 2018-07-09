import XCTest
@testable import FramesIos

class StandardInputViewTests: XCTestCase {

    var standardInputView = StandardInputView()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        standardInputView = StandardInputView()
        let window = UIWindow()
        window.addSubview(standardInputView)
    }

    func testEmptyInitialization() {
        let standardInputView = StandardInputView()
        XCTAssertEqual(standardInputView.textField.textContentType, UITextContentType.name)
    }

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let standardInputView = StandardInputView(coder: coder)
        XCTAssertEqual(standardInputView!.textField.textContentType, UITextContentType.name)
    }

    func testFrameInitialization() {
        let standardInputView = StandardInputView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
        XCTAssertEqual(standardInputView.textField.textContentType, UITextContentType.name)
    }

    func testTextFieldBecomeFirstResponderOnTap() {
        standardInputView.onTapView()
        XCTAssertTrue(self.standardInputView.textField.isFirstResponder)
    }

    func testSetTextAndBackgroundColor() {
        standardInputView.set(label: "addressLine1", backgroundColor: .white)
        XCTAssertEqual(standardInputView.label.text, "Address line 1*")
        XCTAssertEqual(standardInputView.backgroundColor, UIColor.white)
    }

    func testSetPlaceholder() {
        standardInputView.placeholder = "Placeholder"
        XCTAssertEqual(standardInputView.textField.placeholder, "Placeholder")
    }

    func testSetText() {
        standardInputView.text = "Text"
        XCTAssertEqual(standardInputView.label.text, "Text")
    }

    func testShowError() {
        let message = "This is an error message"
        standardInputView.showError(message: message)
        XCTAssertEqual(standardInputView.errorLabel.text, message)
        XCTAssertEqual(standardInputView.errorView.isHidden, false)
    }

    func testHideError() {
        testShowError()
        standardInputView.hideError()
        XCTAssertEqual(standardInputView.errorView.isHidden, true)
    }

}
