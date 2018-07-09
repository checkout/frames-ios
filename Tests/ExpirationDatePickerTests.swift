import XCTest
@testable import FramesIos

class ExpirationDatePickerTests: XCTestCase {

    var expirationDatePicker = ExpirationDatePicker()

    func getMonthFromPicker() -> String {
        let selectedMonthIndex = expirationDatePicker.selectedRow(inComponent: 0)
        let selectedMonth = expirationDatePicker.pickerView(expirationDatePicker,
                                                            titleForRow: selectedMonthIndex,
                                                            forComponent: 0)
        return String(selectedMonth![...selectedMonth!.index(selectedMonth!.startIndex, offsetBy: 1)])
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.expirationDatePicker = ExpirationDatePicker()
    }

    func testEmptyInitialization() {
        let expirationDatePicker = ExpirationDatePicker()
        XCTAssertEqual(expirationDatePicker.timeZone, TimeZone(secondsFromGMT: 0)!)
    }

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let expirationDatePicker = ExpirationDatePicker(coder: coder)
        XCTAssertNotNil(expirationDatePicker)
        XCTAssertEqual(expirationDatePicker!.timeZone, TimeZone(secondsFromGMT: 0)!)
    }

    func testFrameInitialization() {
        let expirationDatePicker = ExpirationDatePicker(frame: CGRect(x: 0, y: 0, width: 400, height: 100))
        XCTAssertEqual(expirationDatePicker.timeZone, TimeZone(secondsFromGMT: 0)!)
    }

    func testReturnNilWhenAccessNonExistentComponent() {
        let titleRow = expirationDatePicker.pickerView(expirationDatePicker, titleForRow: 1, forComponent: 3)
        XCTAssertNil(titleRow)
    }

    func testReturn0WhenAccessNonExistentComponent() {
        let numberRow = expirationDatePicker.pickerView(expirationDatePicker, numberOfRowsInComponent: 3)
        XCTAssertEqual(numberRow, 0)
    }

    func testSelectMinimumDateWhenUserSelectBelow() {
        expirationDatePicker.selectRow(0, inComponent: 0, animated: false)
        expirationDatePicker.pickerView(expirationDatePicker, didSelectRow: 0, inComponent: 0)
        let selectedMonth = getMonthFromPicker()
        let minimumDateMonth = Calendar(identifier: .gregorian).component(.month, from: Date())
        XCTAssertEqual(Int(selectedMonth), minimumDateMonth)
    }

    func testSelectMaximumDateWhenUserSelectAbove() {
        // select maximum data on the expiration date picker
        expirationDatePicker.selectRow(11, inComponent: 0, animated: false)
        expirationDatePicker.selectRow(20, inComponent: 1, animated: false)
        expirationDatePicker.pickerView(expirationDatePicker, didSelectRow: 20, inComponent: 1)
        // get the month
        let selectedMonth = getMonthFromPicker()
        let maximumDateMonth = Calendar(identifier: .gregorian).component(.month, from: Date())
        XCTAssertEqual(Int(selectedMonth), maximumDateMonth)
    }

}
