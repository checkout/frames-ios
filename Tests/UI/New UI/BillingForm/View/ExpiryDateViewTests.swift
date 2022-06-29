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
        let text = dateFormatter.string(from: nextMonthDate)
        let isValid = view.isValidExpiryDate(text: text)
        XCTAssertTrue(isValid)
        XCTAssertTrue(view.style?.error?.isHidden ?? false)
    }

    func testInValidExpiryDate(){
        guard let previousYearDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) else {
            XCTFail("Previous Year Date is empty")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        let text = dateFormatter.string(from: previousYearDate)
        let isValid = view.isValidExpiryDate(text: text)
        XCTAssertFalse(isValid)
        XCTAssertFalse(view.style?.error?.isHidden ?? true)
    }

    func testValidTodayExpiryDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        let text = dateFormatter.string(from: Date())
        let isValid = view.isValidExpiryDate(text: text)
        XCTAssertTrue(isValid)
        XCTAssertTrue(view.style?.error?.isHidden ?? false)
    }

    func testEmptyExpiryDate(){
        let isValid = view.isValidExpiryDate(text: "")
        XCTAssertFalse(isValid)
        XCTAssertFalse(view.style?.error?.isHidden ?? true)
    }
}
