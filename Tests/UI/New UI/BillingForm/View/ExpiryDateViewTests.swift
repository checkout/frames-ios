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
    let isValid = view.updateExpiryDate(to: "01/7", replacementText: "0")
    XCTAssertTrue(isValid)
    XCTAssertTrue(view.style?.error?.isHidden ?? false)
  }

  func testInValidExpiryDate(){
    let isValid = view.updateExpiryDate(to: "01/1", replacementText: "0")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.past)
  }

  func testValidTodayExpiryDate(){
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/yy"
    let updateExpiryDate = dateFormatter.string(from: Date())
    let isValid = view.updateExpiryDate(to: updateExpiryDate, replacementText: "")
    XCTAssertTrue(isValid)
    XCTAssertTrue(view.style?.error?.isHidden ?? false)
  }

  func testEmptyExpiryDate(){
    let isValid = view.updateExpiryDate(to: "", replacementText: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithWrongYearFormat(){
    let isValid = view.updateExpiryDate(to: "01/2035", replacementText: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithWrongMonthFormat(){
    let isValid = view.updateExpiryDate(to: "Jan/35", replacementText: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }


  func testExpiryDateWithWrongFormat(){
    let isValid = view.updateExpiryDate(to: "01.35", replacementText: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithMoreThan5Characters(){
    let isValid = view.updateExpiryDate(to: "01/01/01/01", replacementText: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithOutBackSlash(){
    let isValid = view.updateExpiryDate(to: "01350", replacementText: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithmoreLess5Characters(){
    let isValid = view.updateExpiryDate(to: "01/0", replacementText: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithString(){
    let isValid = view.updateExpiryDate(to: "Test", replacementText: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithInvalidMaxDate(){
    let isValid = view.updateExpiryDate(to: "99/99", replacementText: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithInvalidMinDate(){
    let isValid = view.updateExpiryDate(to: "00/00", replacementText: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithInvalidLongNumbers(){
    let isValid = view.updateExpiryDate(to: "999999999/999999999", replacementText: "")
    XCTAssertFalse(isValid)
    XCTAssertFalse(view.style?.error?.isHidden ?? true)
    XCTAssertEqual(view.style?.error?.text, Constants.LocalizationKeys.PaymentForm.ExpiryDate.Error.invalid)
  }

  func testExpiryDateWithInvalidLongSpecialCharacter(){
    let isValid = view.updateExpiryDate(to: "-*/@@", replacementText: "")
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

