import XCTest
import Checkout
@testable import Frames

class PaymentViewModelTests: XCTestCase {

    var viewModel: DefaultPaymentViewModel!
    
    func testInit() {
        let testCardValidator = CardValidator(environment: .sandbox)
        let testLogger = StubFramesEventLogger()
        let testBillingFormData = BillingForm(name: "John Doe",
                                              address: Address(addressLine1: "home", addressLine2: "sleeping", city: "rough night", state: "tired", zip: "Zzzz", country: nil),
                                              phone: Phone(number: "notAvailable", country: nil))
        let testSupportedSchemes = [Card.Scheme.discover, .mada]
        let viewModel = DefaultPaymentViewModel(cardValidator: testCardValidator,
                                                logger: testLogger,
                                                billingFormData: testBillingFormData,
                                                paymentFormStyle: nil,
                                                billingFormStyle: nil,
                                                supportedSchemes: testSupportedSchemes)
        
        XCTAssertTrue(viewModel.cardValidator === testCardValidator)
        XCTAssertTrue((viewModel.logger as? StubFramesEventLogger) === testLogger)
        XCTAssertEqual(viewModel.billingFormData, testBillingFormData)
        XCTAssertEqual(viewModel.supportedSchemes, testSupportedSchemes)
    }
    
    func testOnAppearSendsEventToLoggger() {
        let testLogger = StubFramesEventLogger()
        let viewModel = DefaultPaymentViewModel(cardValidator: CardValidator(environment: .sandbox),
                                                logger: testLogger,
                                                billingFormData: nil,
                                                paymentFormStyle: nil,
                                                billingFormStyle: nil,
                                                supportedSchemes: [])
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertTrue(testLogger.logCalledWithFramesLogEvents.isEmpty)
        
        viewModel.viewControllerWillAppear()
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents.count, 1)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents.first, .paymentFormPresented)
    }
    
    func testOnBillingScreenShownSendsEventToLogger() {
        let testLogger = StubFramesEventLogger()
        let viewModel = DefaultPaymentViewModel(cardValidator: CardValidator(environment: .sandbox),
                                                logger: testLogger,
                                                billingFormData: nil,
                                                paymentFormStyle: nil,
                                                billingFormStyle: nil,
                                                supportedSchemes: [])
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertTrue(testLogger.logCalledWithFramesLogEvents.isEmpty)
        
        viewModel.onBillingScreenShown()
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents.count, 1)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents.first, .billingFormPresented)
    }

  func testUpdateExpiryDateView() {
      viewModel = DefaultPaymentViewModel(cardValidator: CardValidator(environment: .sandbox),
                                          logger: StubFramesEventLogger(),
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
      viewModel = DefaultPaymentViewModel(cardValidator: CardValidator(environment: .sandbox),
                                          logger: StubFramesEventLogger(),
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
      viewModel = DefaultPaymentViewModel(cardValidator: CardValidator(environment: .sandbox),
                                          logger: StubFramesEventLogger(),
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
        viewModel = DefaultPaymentViewModel(cardValidator: CardValidator(environment: .sandbox),
                                            logger: StubFramesEventLogger(),
                                            billingFormData: billingFormData,
                                            paymentFormStyle: DefaultPaymentFormStyle(),
                                            billingFormStyle: DefaultBillingFormStyle(),
                                            supportedSchemes: [.unknown])

        let summaryValue = "User Custom 1\n\n77 1234 1234"
        viewModel.updateBillingSummaryView()
        let expectedSummaryText = try XCTUnwrap(viewModel.paymentFormStyle?.editBillingSummary?.summary?.text)
        XCTAssertEqual(expectedSummaryText, summaryValue)
    }

  func testSummaryTextWithEmptyValue() throws {
      let userName = "User"

    let address = Address(addressLine1: "Checkout.com",
                          addressLine2: "",
                          city: "London city",
                          state: "London County",
                          zip: "N12345",
                          country: Country(iso3166Alpha2: "GB"))

      let phone = Phone(number: "077 1234 1234",
                        country: Country(iso3166Alpha2: "GB"))
      let billingFormData = BillingForm(name: userName,
                                        address: address,
                                        phone: phone)
      viewModel = DefaultPaymentViewModel(cardValidator: CardValidator(environment: .sandbox),
                                          logger: StubFramesEventLogger(),
                                          billingFormData: billingFormData,
                                          paymentFormStyle: DefaultPaymentFormStyle(),
                                          billingFormStyle: DefaultBillingFormStyle(),
                                          supportedSchemes: [.unknown])

      let summaryValue = "User\n\nCheckout.com\n\nLondon city\n\nLondon County\n\nN12345\n\nUnited Kingdom\n\n077 1234 1234"
      viewModel.updateBillingSummaryView()
      let expectedSummaryText = try XCTUnwrap(viewModel.paymentFormStyle?.editBillingSummary?.summary?.text)
      XCTAssertEqual(expectedSummaryText, summaryValue)
  }
}
