import XCTest
@testable import Frames

class ExpiryDateViewTests: XCTestCase {

  var view: ExpiryDateView!
  var style: DefaultExpiryDateFormStyle!

  override func setUp() {
    super.setUp()
    UIFont.loadAllCheckoutFonts
    style = DefaultExpiryDateFormStyle()
    view = ExpiryDateView(environment: .sandbox)
    view.update(style: style)
  }

  func testValidExpiryDate(){
    let isValid = view.validateInputChanges(Of: "01/7", newInput: "0")
    XCTAssertTrue(isValid)
    XCTAssertTrue(view.style?.error?.isHidden ?? false)
  }

  func testInValidExpiryDate(){
    let isValid = view.validateInputChanges(Of: "01/1", newInput: "0")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.past)
  }

  func testValidTodayExpiryDate(){
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/yy"
    let dateText = dateFormatter.string(from: Date())
    let isValid = view.validateInputChanges(Of: dateText, newInput: "")
    XCTAssertTrue(isValid)
    XCTAssertTrue(view.style?.error?.isHidden ?? false)
  }

  func testEmptyExpiryDate(){
    let isValid = view.validateInputChanges(Of: "", newInput: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithWrongYearFormat(){
    let isValid = view.validateInputChanges(Of: "01/2035", newInput: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithWrongMonthFormat(){
    let isValid = view.validateInputChanges(Of: "Jan/35", newInput: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }


  func testExpiryDateWithWrongFormat(){
    let isValid = view.validateInputChanges(Of: "01.35", newInput: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithMoreThan5Characters(){
    let isValid = view.validateInputChanges(Of: "01/01/01/01", newInput: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithOutBackSlash(){
    let isValid = view.validateInputChanges(Of: "01350", newInput: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithmoreLess5Characters(){
    let isValid = view.validateInputChanges(Of: "01/0", newInput: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithString(){
    let isValid = view.validateInputChanges(Of: "Test", newInput: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithInvalidMaxDate(){
    let isValid = view.validateInputChanges(Of: "99/99", newInput: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithInvalidMinDate(){
    let isValid = view.validateInputChanges(Of: "00/00", newInput: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithInvalidLongNumbers(){
    let isValid = view.validateInputChanges(Of: "999999999/999999999", newInput: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithInvalidLongSpecialCharacter(){
    let isValid = view.validateInputChanges(Of: "-*/@@", newInput: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
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

