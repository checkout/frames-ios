import XCTest
@testable import Frames

class CvvInputViewTests: XCTestCase {

    var cvvInputView: CvvInputView!
    var stubCardValidator: MockCardValidator! = MockCardValidator()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cvvInputView = CvvInputView(cardValidator: stubCardValidator)
        let window = UIWindow()
        window.addSubview(cvvInputView)
    }

    override func tearDown() {
        stubCardValidator = nil

        super.tearDown()
    }

    func testEmptyInitialization() {
        let cvvInputView = CvvInputView()
        XCTAssertNil(cvvInputView.textField.textContentType)
        XCTAssertEqual(cvvInputView.textField.keyboardType, .asciiCapableNumberPad)
    }

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let cvvInputView = CvvInputView(coder: coder)
        XCTAssertNil(cvvInputView!.textField.textContentType)
        XCTAssertEqual(cvvInputView!.textField.keyboardType, .asciiCapableNumberPad)
    }

    func testFrameInitialization() {
        let cvvInputView = CvvInputView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
        XCTAssertNil(cvvInputView.textField.textContentType)
        XCTAssertEqual(cvvInputView.textField.keyboardType, .asciiCapableNumberPad)
    }

    func testDoNotChangeCvvIfExceedingMaxLength() {
        cvvInputView.textField.text = "1000"
        let shouldChange = cvvInputView.textField(cvvInputView.textField,
                                                  shouldChangeCharactersIn: NSRange(),
                                                  replacementString: "9")
        XCTAssertFalse(shouldChange)
    }

    func testDoNotChangeCvvIfExceedingCardTypeMaxLength() {
        cvvInputView.textField.text = "1000"
        cvvInputView.scheme = .americanExpress
        let shouldChange = cvvInputView.textField(cvvInputView.textField,
                                                  shouldChangeCharactersIn: NSRange(),
                                                  replacementString: "9")
        XCTAssertFalse(shouldChange)
    }

    func testDoChangeCvvIfNotExceedingCardTypeMaxLength() {
        cvvInputView.textField.text = "100"
        cvvInputView.scheme = .americanExpress
        let shouldChange = cvvInputView.textField(cvvInputView.textField,
                                                  shouldChangeCharactersIn: NSRange(),
                                                  replacementString: "0")
        XCTAssertTrue(shouldChange)
    }

    func testCallDelegateMethodTextFieldDidEndEditing() {
        let delegate = CvvInputViewMockDelegate()
        cvvInputView.delegate = delegate
        cvvInputView.textFieldDidEndEditing(cvvInputView.textField)
        XCTAssertEqual(delegate.calledTimes, 1)
        XCTAssertEqual(delegate.lastCalledWith, cvvInputView.textField)
    }

}
