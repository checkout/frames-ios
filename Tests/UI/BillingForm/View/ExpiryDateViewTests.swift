import XCTest
import Checkout
@testable import Frames

class ExpiryDateViewTests: XCTestCase {

  var view: ExpiryDateView!
  var style: DefaultExpiryDateFormStyle!

  override func setUp() {
    super.setUp()
    style = DefaultExpiryDateFormStyle()
    view = ExpiryDateView(cardValidator: CardValidator(environment: .sandbox))
    view.update(style: style)
  }

  // Invalid string case of of pre-filled expiry date text from the merchant.
  func testInValidStringPrefilledTextFieldTextStyle(){
    style.textfield.text = "Test"
    view.update(style: style)

    XCTAssertEqual(view.dateInputView.textFieldView.textField.text, "")
  }

  // Invalid old date case of of pre-filled expiry date text from the merchant.
  func testInValidOldDatePrefilledTextFieldTextStyle(){
    style.textfield.text = "10/19"
    view.update(style: style)

    XCTAssertEqual(view.dateInputView.textFieldView.textField.text, "")
  }

  // Valid date case of pre-filled expiry date text from the merchant.
  func testValidDatePrefilledTextFieldTextStyle(){
    style.textfield.text = "10/77"
    view.update(style: style)

    XCTAssertEqual(view.dateInputView.textFieldView.textField.text, "10/77")
  }

  func testValidExpiryDate(){
    let error = view.validateInputChanges(of: "01/7", newInput: "0")
    XCTAssertNil(error)
    XCTAssertTrue(view.style?.error?.isHidden ?? false)
  }

  func testValidTodayExpiryDate(){
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/yy"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    let dateText = dateFormatter.string(from: Date())
    let error = view.validateInputChanges(of: dateText, newInput: "")
    XCTAssertNil(error)
    XCTAssertTrue(view.style?.error?.isHidden ?? false)
  }

  func testPastExpiryDate(){
    let error = view.validateInputChanges(of: "01/1", newInput: "2")
    XCTAssertEqual(error, .inThePast)
  }

  func testEmptyExpiryDate(){
    let error = view.validateInputChanges(of: "", newInput: "")
    XCTAssertEqual(error, .incompleteYear)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithWrongYearFormat(){
    let error = view.validateInputChanges(of: "01/2035", newInput: "")
    XCTAssertEqual(error, .incompleteYear)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithWrongMonthFormat(){
    let error = view.validateInputChanges(of: "Jan/35", newInput: "")
    XCTAssertEqual(error, .incompleteYear)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }


  func testExpiryDateWithWrongFormat(){
    let error = view.validateInputChanges(of: "01.35", newInput: "")
    XCTAssertEqual(error, .invalidYearString)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithMoreThan5Characters(){
    let error = view.validateInputChanges(of: "01/01/01/01", newInput: "")
    XCTAssertEqual(error, .incompleteYear)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithOutBackSlash(){
    let error = view.validateInputChanges(of: "01350", newInput: "")
    XCTAssertEqual(error, .invalidYearString)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithmoreLess5Characters(){
    let error = view.validateInputChanges(of: "01/0", newInput: "")
    XCTAssertEqual(error, .incompleteYear)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithString(){
    let error = view.validateInputChanges(of: "Test", newInput: "")
    XCTAssertEqual(error, .incompleteYear)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithInvalidMaxDate(){
    let error = view.validateInputChanges(of: "99/99", newInput: "")
    XCTAssertEqual(error, .invalidMonth)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithInvalidMinDate(){
    let error = view.validateInputChanges(of: "00/00", newInput: "")
    XCTAssertEqual(error, .incompleteYear)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithInvalidLongNumbers(){
    let error = view.validateInputChanges(of: "999999999/999999999", newInput: "")
    XCTAssertEqual(error, .incompleteYear)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithInvalidLongSpecialCharacter(){
    let error = view.validateInputChanges(of: "-*/@@", newInput: "")
    XCTAssertEqual(error, .invalidYearString)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testValidFirstDigitInputWith0() {
    let textField = UITextField()
    textField.text = ""
    let input = "0"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: input)
    XCTAssertTrue(shouldContinueAdding)

    textField.text?.append(input)
    XCTAssertEqual(textField.text, "0")
  }

  func testInvalidSecondDigitInputWith0() {
    let textField = UITextField()
    textField.text = "0"
    let input = "0"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 1, length: 0), replacementString: input)

    XCTAssertFalse(shouldContinueAdding)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
    XCTAssertEqual(textField.text, "0")
  }

  func testValidSecondDigitInputWith3() {
    let textField = UITextField()
    textField.text = ""
    let input = "3"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: input)
    XCTAssertTrue(shouldContinueAdding)

    textField.text?.append(input)
    XCTAssertEqual(textField.text, "03")
  }

  func testValidSecondDigitInputWith2() {
    let textField = UITextField()
    textField.text = "1"
    let input = "2"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 1, length: 0), replacementString: input)
    XCTAssertTrue(shouldContinueAdding)

    textField.text?.append(input)
    XCTAssertEqual(textField.text, "12")
  }

  func testInvalidSecondDigitInputWith9() {
    let textField = UITextField()
    textField.text = "1"
    let input = "9"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 1, length: 0), replacementString: input)

    XCTAssertFalse(shouldContinueAdding)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
    XCTAssertEqual(textField.text, "1")
  }

  func testInvalidthirdDigitInputWith0() {
    let textField = UITextField()
    textField.text = "01"
    let input = "0"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 2, length: 0), replacementString: input)

    XCTAssertFalse(shouldContinueAdding)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
    XCTAssertEqual(textField.text, "01/")
  }

  func testInvalidthirdDigitInputWith1() {
    let textField = UITextField()
    textField.text = "02"
    let input = "1"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 2, length: 0), replacementString: input)

    XCTAssertFalse(shouldContinueAdding)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
    XCTAssertEqual(textField.text, "02/")
  }

  func testValidthirdDigitInputWith2() {
    let textField = UITextField()
    textField.text = "02"
    let input = "2"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 2, length: 0), replacementString: input)
    XCTAssertTrue(shouldContinueAdding)

    textField.text?.append(input)
    XCTAssertEqual(textField.text, "02/2")
  }

  func testValidFourthDigitInputWith2() {
    let textField = UITextField()
    textField.text = "02/3"
    let input = "2"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 3, length: 0), replacementString: input)
    XCTAssertTrue(shouldContinueAdding)

    textField.text?.append(input)
    XCTAssertEqual(textField.text, "02/32")
  }

  func testInvalidFourthDigitInputWith() {
    let textField = UITextField()
    textField.text = "02/2"
    let input = "0"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 3, length: 0), replacementString: input)

    XCTAssertFalse(shouldContinueAdding)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
    XCTAssertEqual(textField.text, "02/2")
  }

}

