import XCTest
import Checkout
@testable import Frames

class PaymentViewModelTests: XCTestCase {

    var viewModel: DefaultPaymentViewModel!

    override func setUp() {
        super.setUp()
        UIFont.loadAllCheckoutFonts
    }

  func testUpdateExpiryDateView() {
    viewModel = DefaultPaymentViewModel(environment: .sandbox,
                                        billingFormData: nil,
                                        paymentFormStyle: DefaultPaymentFormStyle(),
                                        billingFormStyle: DefaultBillingFormStyle(),
                                        supportedSchemes: [.unknown])

        let expectation = expectation(description: #function)
        viewModel?.updateExpiryDateView = {
            expectation.fulfill()
        }

        viewModel?.updateAll()

        waitForExpectations(timeout: 1)
    }

    func testUpdateAddBillingSummaryView() {
      viewModel = DefaultPaymentViewModel(environment: .sandbox,
                                          billingFormData: nil,
                                          paymentFormStyle: DefaultPaymentFormStyle(),
                                          billingFormStyle: DefaultBillingFormStyle(),
                                          supportedSchemes: [.unknown])

        let expectation = expectation(description: #function)
        viewModel?.updateAddBillingDetailsView = {
            expectation.fulfill()
        }

        viewModel?.updateAll()

        waitForExpectations(timeout: 1)
    }

    func testUpdateEditBillingSummaryView() {
        let userName = "User Custom 1"
        let address = Address(addressLine1: "Test line1 Custom 1",
                              addressLine2: nil,
                              city: "London Custom 1",
                              state: "London Custom 1",
                              zip: "N12345",
                              country: Country(iso3166Alpha2: "GB"))
        let phone = Phone(number: "77 1234 1234",
                          country: Country(iso3166Alpha2: "GB"))
        let billingFormData = BillingForm(name: userName,
                                          address: address,
                                          phone: phone)
      viewModel = DefaultPaymentViewModel(environment: .sandbox,
                                          billingFormData: billingFormData,
                                          paymentFormStyle: DefaultPaymentFormStyle(),
                                          billingFormStyle: DefaultBillingFormStyle(),
                                          supportedSchemes: [.unknown])

        let expectation = expectation(description: #function)
        viewModel.updateEditBillingSummaryView = {
            expectation.fulfill()
        }

        viewModel.updateAll()
        waitForExpectations(timeout: 1)
    }

    func testSummaryText() throws {
        let userName = "User Custom 1"
        let phone = Phone(number: "77 1234 1234",
                          country: Country(iso3166Alpha2: "GB"))
        let billingFormData = BillingForm(name: userName,
                                          address: nil,
                                          phone: phone)
        viewModel = DefaultPaymentViewModel(environment: .sandbox,
                                            billingFormData: billingFormData,
                                            paymentFormStyle: DefaultPaymentFormStyle(),
                                            billingFormStyle: DefaultBillingFormStyle(),
                                            supportedSchemes: [.unknown])

        let summaryValue = "User Custom 1\n\n77 1234 1234"
        viewModel.updateBillingSummaryView()
        let expectedSummaryText = try XCTUnwrap(viewModel.paymentFormStyle?.editBillingSummary?.summary?.text)
        XCTAssertEqual(expectedSummaryText, summaryValue)
    }
}
