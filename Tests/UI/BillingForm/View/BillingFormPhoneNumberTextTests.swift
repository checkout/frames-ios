import XCTest
@testable import Frames

final class BillingFormPhoneNumberTextTests: XCTestCase {

    func testShouldChangeCharacters() {
        let mockDelegate = BillingFormPhoneNumberTextMockDelegate()
        let view = BillingFormPhoneNumberText(type: .phoneNumber(nil), tag: 1, phoneNumberTextDelegate: mockDelegate)
        view.text = "+44 12345678"
            view.textField(view, shouldChangeCharactersIn: NSRange(location: 13, length: 0), replacementString: "9")

        XCTAssertEqual(mockDelegate.isValidPhoneMaxLengthLastCalledWithText, "+44 1234 56789")
        XCTAssertEqual(mockDelegate.phoneNumberIsUpdatedCalledTimes, 1)
        XCTAssertEqual(mockDelegate.phoneNumberIsUpdatedLastCalledWithTag, 1)
        XCTAssertEqual(mockDelegate.isValidPhoneMaxLengthCalledTimes, 1)
        XCTAssertEqual(mockDelegate.textFieldDidEndEditingCalledTimes, 0)
        XCTAssertNil(mockDelegate.textFieldDidEndEditingLastCalledWithTag)
    }
}
