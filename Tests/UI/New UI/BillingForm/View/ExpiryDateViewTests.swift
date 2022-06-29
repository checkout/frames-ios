import XCTest
@testable import Frames

class ExpiryDateViewTests: XCTestCase {

    var view: ExpiryDateView!
    var style: DefaultExpiryDateFormStyle!

    override func setUp() {
        super.setUp()
        UIFont.loadAllCheckoutFonts
        style = DefaultExpiryDateFormStyle()
        view = ExpiryDateView()
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

}
