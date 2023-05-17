import XCTest
import Checkout
@testable import Frames

class ExpiryDateViewTests: XCTestCase {

  // Valid date case of pre-filled expiry date text from the merchant.
    func testValidDatePrefilledTextFieldTextStyle() {
        var style = DefaultExpiryDateFormStyle()
        style.textfield.text = "10/77"
        let view = ExpiryDateView(cardValidator: CardValidator(environment: .sandbox))
        view.update(style: style)
        view.update(style: style)
        
        XCTAssertEqual(view.dateInputView.textFieldView.textField.text, "10/77")
    }
    
    func testValidExpiryDate() {
        let view = createView()
        let mockDelegate = MockExpiryDateViewDelegate()
        view.delegate = mockDelegate
        let textField = UITextField()
        textField.text = "01/7"
        XCTAssertFalse(view.textField(textField, shouldChangeCharactersIn: NSRange(location: 4, length: 0), replacementString: "0"))
        XCTAssertTrue(view.style?.error?.isHidden == true)
        XCTAssertEqual(view.style?.textfield.text, "01/70")
        
        XCTAssertEqual(mockDelegate.receivedResults.count, 1)
        switch mockDelegate.receivedResults.first {
        case .success(let expiry):
            XCTAssertEqual(expiry.month, 1)
            XCTAssertEqual(expiry.year, 2070)
        default:
            XCTFail("Should call delegate with a success!")
        }
    }

    func testValidTodayExpiryDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateText = dateFormatter.string(from: Date())
        let view = createView()
        let mockDelegate = MockExpiryDateViewDelegate()
        view.delegate = mockDelegate
        let textField = UITextField()
        textField.text = dateText
        XCTAssertTrue(view.textField(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: ""))
        XCTAssertTrue(view.style?.error?.isHidden == true)
        XCTAssertEqual(view.style?.textfield.text, dateText)
        
        XCTAssertEqual(mockDelegate.receivedResults.count, 1)
        switch mockDelegate.receivedResults.first {
        case .success(let expiry):
            XCTAssertEqual(expiry.month, Int(dateText.prefix(2)))
            XCTAssertEqual(expiry.year, Int("20\(dateText.suffix(2))"))
        default:
            XCTFail("Should call delegate with a success!")
        }
    }

    func testPastExpiryDate() {
        let view = createView()
        let mockDelegate = MockExpiryDateViewDelegate()
        view.delegate = mockDelegate
        let textField = UITextField()
        textField.text = "01/1"
        XCTAssertFalse(view.textField(textField, shouldChangeCharactersIn: NSRange(location: 4, length: 0), replacementString: "2"))
        XCTAssertTrue(view.style?.error?.isHidden == false)
        XCTAssertEqual(view.style?.textfield.text, "01/12")
        
        XCTAssertEqual(mockDelegate.receivedResults.count, 1)
        switch mockDelegate.receivedResults.first {
        case .failure(let error):
            XCTAssertEqual(error, .invalidCode)
        default:
            XCTFail("Should call delegate with a failure!")
        }
    }
    
    private func createView(validator: CardValidating = CardValidator(environment: .sandbox),
                            style: CellTextFieldStyle = DefaultExpiryDateFormStyle()) -> ExpiryDateView {
        let view = ExpiryDateView(cardValidator: CardValidator(environment: .sandbox))
        view.update(style: style)
        return view
    }
}

