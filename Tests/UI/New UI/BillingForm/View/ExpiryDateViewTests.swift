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
        guard let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: Date()) else {
            XCTFail("Next Month Date is empty")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        let updateExpiryDate = dateFormatter.string(from: nextMonthDate)
        view.updateExpiryDate(to: updateExpiryDate)

        XCTAssertTrue(view.style?.error?.isHidden ?? false)
    }

    func testInValidExpiryDate(){
        guard let previousYearDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) else {
            XCTFail("Previous Year Date is empty")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        let updateExpiryDate = dateFormatter.string(from: previousYearDate)
        view.updateExpiryDate(to: updateExpiryDate)

        XCTAssertFalse(view.style?.error?.isHidden ?? true)
    }

    func testValidTodayExpiryDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        let updateExpiryDate = dateFormatter.string(from: Date())
        view.updateExpiryDate(to: updateExpiryDate)

        XCTAssertTrue(view.style?.error?.isHidden ?? false)
    }

    func testEmptyExpiryDate(){
        view.updateExpiryDate(to: "")
        XCTAssertFalse(view.style?.error?.isHidden ?? true)
    }

    func testExpiryDateWithWrongYearFormat(){
        view.updateExpiryDate(to: "01/2035")
        XCTAssertFalse(view.style?.error?.isHidden ?? true)
    }

    func testExpiryDateWithWrongMonthFormat(){
        view.updateExpiryDate(to: "Jan/35")
        XCTAssertFalse(view.style?.error?.isHidden ?? true)
    }


    func testExpiryDateWithWrongFormat(){
        view.updateExpiryDate(to: "01.35")
        XCTAssertFalse(view.style?.error?.isHidden ?? true)
    }

    func testExpiryDateWithMoreThan5Characters(){
        view.updateExpiryDate(to: "01/01/01/01")
        XCTAssertFalse(view.style?.error?.isHidden ?? true)
    }

    func testExpiryDateWithOutBackSlash(){
        view.updateExpiryDate(to: "01350")
        XCTAssertFalse(view.style?.error?.isHidden ?? true)
    }

    func testExpiryDateWithmoreLess5Characters(){
        view.updateExpiryDate(to: "01/0")
        XCTAssertFalse(view.style?.error?.isHidden ?? true)
    }

    func testExpiryDateWithNonDigits(){
        view.updateExpiryDate(to: "Test")
        XCTAssertFalse(view.style?.error?.isHidden ?? true)
    }

  func testValidFirstDigitInputWith0() {
    let input = "0"
    let textField = UITextField()
    textField.text = ""

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: input)
    if shouldContinueAdding {
      textField.text?.append(input)
    }

    XCTAssertTrue(shouldContinueAdding)
    XCTAssertEqual(textField.text, "0")
  }

  func testInvalidSecondDigitInputWith0() {
    let input = "0"
    let textField = UITextField()
    textField.text = "0"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 1, length: 0), replacementString: input)
    if shouldContinueAdding {
      textField.text?.append(input)
    }

    XCTAssertFalse(shouldContinueAdding)
    XCTAssertEqual(textField.text, "0")
  }

  func testValidSecondDigitInputWith3() {
    let textField = UITextField()
    textField.text = ""
    let input = "3"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: input)
    if shouldContinueAdding {
      textField.text?.append(input)
    }

    XCTAssertTrue(shouldContinueAdding)
    XCTAssertEqual(textField.text, "03")
  }

  func testValidSecondDigitInputWith2() {
    let textField = UITextField()
    textField.text = "1"
    let input = "2"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 1, length: 0), replacementString: input)
    if shouldContinueAdding {
      textField.text?.append(input)
    }

    XCTAssertTrue(shouldContinueAdding)
    XCTAssertEqual(textField.text, "12")
  }

  func testInvalidSecondDigitInputWith9() {
    let textField = UITextField()
    textField.text = "1"
    let input = "9"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 1, length: 0), replacementString: input)
    if shouldContinueAdding {
      textField.text?.append(input)
    }
    XCTAssertFalse(shouldContinueAdding)
    XCTAssertEqual(textField.text, "1")
  }

  func testInvalidthirdDigitInputWith0() {
    let textField = UITextField()
    textField.text = "01"
    let input = "0"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 2, length: 0), replacementString: input)
    if shouldContinueAdding {
      textField.text?.append(input)
    }
    XCTAssertFalse(shouldContinueAdding)
    XCTAssertEqual(textField.text, "01/")
  }

  func testInvalidthirdDigitInputWith1() {
    let textField = UITextField()
    textField.text = "02"
    let input = "1"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 2, length: 0), replacementString: input)
    if shouldContinueAdding {
      textField.text?.append(input)
    }
    XCTAssertFalse(shouldContinueAdding)
    XCTAssertEqual(textField.text, "02/")
  }

  func testValidthirdDigitInputWith2() {
    let textField = UITextField()
    textField.text = "02"
    let input = "2"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 2, length: 0), replacementString: input)
    if shouldContinueAdding {
      textField.text?.append(input)
    }
    XCTAssertTrue(shouldContinueAdding)
    XCTAssertEqual(textField.text, "02/2")
  }

  func testValidFourthDigitInputWith2() {
    let textField = UITextField()
    textField.text = "02/3"
    let input = "2"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 3, length: 0), replacementString: input)
    if shouldContinueAdding {
      textField.text?.append(input)
    }
    XCTAssertTrue(shouldContinueAdding)
    XCTAssertEqual(textField.text, "02/32")
  }

  func testInvalidFourthDigitInputWith() {
    let textField = UITextField()
    textField.text = "02/2"
    let input = "0"

    let shouldContinueAdding = view.textField(textField, shouldChangeCharactersIn: NSRange(location: 3, length: 0), replacementString: input)
    if shouldContinueAdding {
      textField.text?.append(input)
    }
    XCTAssertFalse(shouldContinueAdding)
    XCTAssertEqual(textField.text, "02/2")
  }
  
}
