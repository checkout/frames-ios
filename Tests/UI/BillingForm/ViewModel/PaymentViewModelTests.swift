import XCTest
import Checkout
@testable import Frames

final class DefaultPaymentViewModelTests: XCTestCase {

    var viewModel: DefaultPaymentViewModel!
    
    func testInit() {
        let testCardValidator = CardValidator(environment: .sandbox)
        let testLogger = StubFramesEventLogger()
        let testBillingFormData = BillingForm(name: "John Doe",
                                              address: Address(addressLine1: "home", addressLine2: "sleeping", city: "rough night", state: "tired", zip: "Zzzz", country: nil),
                                              phone: Phone(number: "notAvailable", country: nil))
        let testSupportedSchemes: [Card.Scheme] = [.discover, .mada]

        let viewModel = makeViewModel(cardValidator: testCardValidator,
                                      logger: testLogger,
                                      billingForm: testBillingFormData,
                                      paymentFormStyle: nil,
                                      billingFormStyle: nil,
                                      supportedCardSchemes: testSupportedSchemes)
        
        XCTAssertTrue(viewModel.cardValidator === testCardValidator)
        XCTAssertTrue((viewModel.logger as? StubFramesEventLogger) === testLogger)
        XCTAssertEqual(viewModel.billingFormData, testBillingFormData)
        XCTAssertEqual(viewModel.supportedSchemes, testSupportedSchemes)
    }
    
    // MARK: Update Billing
    func testUpdateBillingSummaryViewNoEditBillingSummary() {
        let billingForm = BillingForm(name: "John", address: nil, phone: nil)
        var paymentStyle = DefaultPaymentFormStyle()
        paymentStyle.editBillingSummary = nil
        let model = makeViewModel(billingForm: billingForm,
                                  paymentFormStyle: paymentStyle,
                                  billingFormStyle: DefaultBillingFormStyle())
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate
        
        model.updateBillingSummaryView()
    }
    
    func testUpdateBillingSummaryViewNoBillingStyle() {
        let billingForm = BillingForm(name: "John", address: nil, phone: nil)
        let model = makeViewModel(billingForm: billingForm,
                                  paymentFormStyle: DefaultPaymentFormStyle(),
                                  billingFormStyle: nil)
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate
        
        model.updateBillingSummaryView()
    }
    
    func testUpdateBillingSummaryViewNoBillingFormData() {
        let expect = expectation(description: "Ensure completion handler is called")
        let paymentFormStyle = DefaultPaymentFormStyle()
        let model = makeViewModel(billingForm: nil,
                                  paymentFormStyle: paymentFormStyle,
                                  billingFormStyle: DefaultBillingFormStyle())
        let testDelegate = MockPaymentViewModelDelegate()
        testDelegate.updateAddBillingDetailsCompletion = {
            expect.fulfill()
        }
        model.delegate = testDelegate
        
        model.updateBillingSummaryView()
        waitForExpectations(timeout: 0.1)
    }
    
    func testUpdateBillingSummaryViewEmptySummary() {
        let expect = expectation(description: "Ensure completion handler is called")
        let paymentFormStyle = DefaultPaymentFormStyle()
        let model = makeViewModel(billingForm: BillingForm(name: "", address: nil, phone: nil),
                                  paymentFormStyle: paymentFormStyle,
                                  billingFormStyle: DefaultBillingFormStyle())
        let testDelegate = MockPaymentViewModelDelegate()
        testDelegate.updateAddBillingDetailsCompletion = {
            expect.fulfill()
        }
        model.delegate = testDelegate
        
        model.updateBillingSummaryView()
        waitForExpectations(timeout: 0.1)
    }
    
    func testUpdateBillingSummaryViewContainingSummary() {
        let expect = expectation(description: "Ensure completion handler is called")
        let paymentFormStyle = DefaultPaymentFormStyle()
        let model = makeViewModel(billingForm: BillingForm(name: "Joe Joey", address: nil, phone: nil),
                                  paymentFormStyle: paymentFormStyle,
                                  billingFormStyle: DefaultBillingFormStyle())
        let testDelegate = MockPaymentViewModelDelegate()
        testDelegate.updateEditBillingSummaryCompletion = {
            expect.fulfill()
            XCTAssertEqual(model.paymentFormStyle?.editBillingSummary?.summary?.text, "Joe Joey")
        }
        model.delegate = testDelegate
        
        model.updateBillingSummaryView()
        waitForExpectations(timeout: 0.1)
    }
    
    // MARK: Billing callbacks
    func testOnBillingAppear() {
        let model = makeViewModel(billingForm: BillingForm(name: "Joe Joey", address: nil, phone: nil),
                                  paymentFormStyle: DefaultPaymentFormStyle(),
                                  billingFormStyle: DefaultBillingFormStyle())
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate
        
        model.onBillingScreenShown()
    }
    
    func testOnBillingTapCancel() {
        let model = makeViewModel(billingForm: BillingForm(name: "Joe Joey", address: nil, phone: nil),
                                  paymentFormStyle: DefaultPaymentFormStyle(),
                                  billingFormStyle: DefaultBillingFormStyle())
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate
        
        model.onTapCancelButton()
    }
    
    func testOnBillingTapDone() {
        let expect = expectation(description: "Should call completion handlers")
        expect.expectedFulfillmentCount = 3
        let model = makeViewModel(billingForm: BillingForm(name: "Joe Joey", address: nil, phone: nil),
                                  paymentFormStyle: DefaultPaymentFormStyle(),
                                  billingFormStyle: DefaultBillingFormStyle())
        let testDelegate = MockPaymentViewModelDelegate()
        testDelegate.updateCardholderCompletion = {
            expect.fulfill()
        }
        testDelegate.updateEditBillingSummaryCompletion = {
            expect.fulfill()
        }
        testDelegate.refreshPayButtonStateCompletion = {
            XCTAssertFalse($0)
            expect.fulfill()
        }
        model.delegate = testDelegate
        
        let newAddress = Address(addressLine1: "home", addressLine2: nil, city: nil, state: nil, zip: nil, country: nil)
        let newBillingForm = BillingForm(name: "New client", address: newAddress, phone: nil)
        model.onTapDoneButton(data: newBillingForm)
        
        waitForExpectations(timeout: 0.1)
        
        XCTAssertEqual(model.paymentFormStyle?.cardholderInput?.textfield.text, "New client")
    }
    
    // MARK: Expiry date updates
    func testFullDetailsAvailableAddValidExpiryDate() {
        let expect = expectation(description: "Should call completion handlers")
        expect.expectedFulfillmentCount = 2
        let model = makeViewModel()
        let testDelegate = MockPaymentViewModelDelegate()
        var callbackCounter = 0
        testDelegate.refreshPayButtonStateCompletion = {
            expect.fulfill()
            callbackCounter += 1
            if callbackCounter == 2 {
                XCTAssertTrue($0)
            }
        }
        testDelegate.updateCardSchemeCompletion = { _ in }
        model.delegate = testDelegate
        
        model.update(result: .success(("4242424242424242", .discover)))
        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 12, year: 2060)))
        
        waitForExpectations(timeout: 0.1)
    }
    
    func testFullDetailsAvailableAddInvalidExpiryDate() {
        let expect = expectation(description: "Should call completion handlers")
        expect.expectedFulfillmentCount = 2
        let model = makeViewModel()
        let testDelegate = MockPaymentViewModelDelegate()
        var callbackCounter = 0
        testDelegate.refreshPayButtonStateCompletion = {
            expect.fulfill()
            callbackCounter += 1
            if callbackCounter == 2 {
                XCTAssertFalse($0)
            }
        }
        testDelegate.updateCardSchemeCompletion = { _ in }
        model.delegate = testDelegate
        
        model.update(result: .success(("4242424242424242", .discover)))
        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 12, year: 2010)))
        
        waitForExpectations(timeout: 0.1)
    }
    
    // MARK: Analytic events
    func testOnAppearSendsEventToLogger() {
        let testLogger = StubFramesEventLogger()
        let viewModel = makeViewModel(logger: testLogger)
        
        viewModel.viewControllerWillAppear()
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents, [.paymentFormPresented])
    }
    
    func testViewControllerDismissedSendsEventToLogger() {
        let testLogger = StubFramesEventLogger()
        let viewModel = makeViewModel(logger: testLogger)
        
        viewModel.viewControllerCancelled()
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents.count, 1)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents, [.paymentFormCanceled])
    }
    
    func testOnBillingScreenShownSendsEventToLogger() {
        let testLogger = StubFramesEventLogger()
        let viewModel = makeViewModel(logger: testLogger)
        
        viewModel.onBillingScreenShown()
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents, [.billingFormPresented])
    }
    
    func testOnBillingScreenCancelledSendsEventToLogger() {
        let testLogger = StubFramesEventLogger()
        let viewModel = makeViewModel(logger: testLogger)
        
        viewModel.onTapCancelButton()
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents, [.billingFormCanceled])
    }
    
    func testOnBillingScreenSubmitSendsEventToLogger() {
        let testLogger = StubFramesEventLogger()
        let viewModel = makeViewModel(logger: testLogger)
        
        viewModel.onTapDoneButton(data: makeMockBillingForm())
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents, [.billingFormSubmit])
    }
    
    func testOnPressSubmitWithInsuficientData() {
        let testLogger = StubFramesEventLogger()
        let viewModel = makeViewModel(logger: testLogger)
        
        viewModel.payButtonIsPressed()
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents, [.warn(message: "Pay button pressed without all required fields input")])
    }
    
    func testOnPressSubmitWithValidData() {
        let testLogger = StubFramesEventLogger()
        let viewModel = makeViewModel(logger: testLogger)
        viewModel.update(result: .success(("42", Card.Scheme.dinersClub)))
        viewModel.expiryDateIsUpdated(result: .success(ExpiryDate(month: 12, year: 2055)))
        
        viewModel.payButtonIsPressed()
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents, [.paymentFormSubmitted])
    }
    
    func testOnNetworkReturnToken() {
        let testToken = "tokenFrom_backend"
        let testLogger = StubFramesEventLogger()
        let testService = StubCheckoutAPIService()
        let mockTokenDetails = StubCheckoutAPIService.createTokenDetails(token: testToken)
        testService.createTokenCompletionResult = .success(mockTokenDetails)
        let viewModel = makeViewModel(apiService: testService, logger: testLogger)
        viewModel.update(result: .success(("42", Card.Scheme.dinersClub)))
        viewModel.expiryDateIsUpdated(result: .success(ExpiryDate(month: 12, year: 2055)))
        
        viewModel.payButtonIsPressed()
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents.count, 2)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents, [.paymentFormSubmitted, .paymentFormSubmittedResult(token: testToken)])
    }
    
    func testOnNetworkReturnError() {
        let testLogger = StubFramesEventLogger()
        let testService = StubCheckoutAPIService()
        testService.createTokenCompletionResult = .failure(.couldNotBuildURLForRequest)
        let viewModel = makeViewModel(apiService: testService, logger: testLogger)
        viewModel.update(result: .success(("42", Card.Scheme.dinersClub)))
        viewModel.expiryDateIsUpdated(result: .success(ExpiryDate(month: 12, year: 2055)))
        
        viewModel.payButtonIsPressed()
        
        XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents.count, 2)
        XCTAssertEqual(testLogger.logCalledWithFramesLogEvents, [.paymentFormSubmitted, .warn(message: "3001 The operation couldn’t be completed. (Checkout.TokenisationError.TokenRequest error 3.)")])
    }
    
    func testPreventDuplicateCardholderInput() {
        let paymentFormStyle = DefaultPaymentFormStyle()
        let billingFormStyle = DefaultBillingFormStyle()
        var viewModel = makeViewModel(paymentFormStyle: paymentFormStyle,
                                      billingFormStyle: billingFormStyle)

        XCTAssertNotNil(viewModel.paymentFormStyle?.cardholderInput)
        var billingName = viewModel.billingFormStyle?.cells.first(where: {
            if case BillingFormCell.fullName = $0 {
                return true
            }
            return false
        })
        XCTAssertNotNil(billingName)

        viewModel.preventDuplicateCardholderInput()
        XCTAssertNotNil(viewModel.paymentFormStyle?.cardholderInput)
        billingName = viewModel.billingFormStyle?.cells.first(where: {
            if case BillingFormCell.fullName = $0 {
                return true
            }
            return false
        })
        XCTAssertNil(billingName)
    }

    func testCardholderIsUpdatedCallbackShouldEnablePayButton() {
        let model = makeViewModel()
        let testExpectation = expectation(description: "Should trigger callback")
        let testDelegate = MockPaymentViewModelDelegate()
        testDelegate.refreshPayButtonStateCompletion = {
            testExpectation.fulfill()
            XCTAssertFalse($0)
        }
        model.delegate = testDelegate
        model.cardholderIsUpdated(value: "new owner")
        waitForExpectations(timeout: 0.1)
    }

    // MARK: Mandatory input validation tests
    func testNoSchemePresentFailMandatoryInput() {
        let testPaymentForm = makePaymentFormStyle()
        let model = makeViewModel(paymentFormStyle: testPaymentForm)

        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = 2
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            XCTAssertFalse(isMandatoryInputProvided)
            expectation.fulfill()
        }
        model.update(result: .failure(.invalidScheme))
        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))

        waitForExpectations(timeout: 0.1)
    }

    func testMandatoryCardholderNotPresentFailMandatoryInput() {
        let testPaymentForm = makePaymentFormStyle(isCardholderMandatory: true)
        let model = makeViewModel(paymentFormStyle: testPaymentForm)

        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = 2
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            XCTAssertFalse(isMandatoryInputProvided)
            expectation.fulfill()
        }

        model.update(result: .success(("4242424242424242", .visa)))
        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))

        waitForExpectations(timeout: 0.1)
    }

    func testOptionalCardholderNotPresentPassesMandatoryInput() {
        var expectedCallbacks = 3
        let testPaymentForm = makePaymentFormStyle(isCardholderMandatory: false)
        let model = makeViewModel(paymentFormStyle: testPaymentForm)

        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = expectedCallbacks
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            expectedCallbacks -= 1
            // On the last call we expect that all mandatory inputs were provided
            if expectedCallbacks == 0 {
                XCTAssertTrue(isMandatoryInputProvided)
            } else {
                XCTAssertFalse(isMandatoryInputProvided)
            }
            expectation.fulfill()
        }

        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))
        model.securityCodeIsUpdated(to: "123")
        model.update(result: .success(("4242424242424242", .visa)))

        waitForExpectations(timeout: 0.1)
    }

    func testMissingCardholderPassesMandatoryInput() {
        var expectedCallbacks = 3
        var testPaymentForm = makePaymentFormStyle(isCardholderMandatory: true)
        testPaymentForm.cardholderInput = nil
        let model = makeViewModel(paymentFormStyle: testPaymentForm)
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate
        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = expectedCallbacks
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            expectedCallbacks -= 1
            // On the last call we expect that all mandatory inputs were provided
            if expectedCallbacks == 0 {
                XCTAssertTrue(isMandatoryInputProvided)
            } else {
                XCTAssertFalse(isMandatoryInputProvided)
            }
            expectation.fulfill()
        }

        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))
        model.securityCodeIsUpdated(to: "123")
        model.update(result: .success(("4242424242424242", .visa)))

        waitForExpectations(timeout: 0.1)
    }

    func testMandatorySecurityCodeNotPresentFailMandatoryInput() {
        let testPaymentForm = makePaymentFormStyle(isSecurityCodeMandatory: true)
        let model = makeViewModel(paymentFormStyle: testPaymentForm)
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate
        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = 2
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            XCTAssertFalse(isMandatoryInputProvided)
            expectation.fulfill()
        }

        model.update(result: .success(("4242424242424242", .visa)))
        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))

        waitForExpectations(timeout: 0.1)
    }

    func testOptionalSecurityCodeNotPresentFailsMandatoryInput() {
        // Business requirements specifically asked that Security Code has specific behaviour
        // If shown it is mandatory, making it optional will have no effect in requiring it
        let testPaymentForm = makePaymentFormStyle(isSecurityCodeMandatory: true)
        let model = makeViewModel(paymentFormStyle: testPaymentForm)
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate

        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = 2
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            XCTAssertFalse(isMandatoryInputProvided)
            expectation.fulfill()
        }

        model.update(result: .success(("4242424242424242", .visa)))
        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))

        waitForExpectations(timeout: 0.1)
    }

    func testMissingSecurityCodePassesMandatoryInput() {
        var expectedCallbacks = 2
        var testPaymentForm = makePaymentFormStyle(isSecurityCodeMandatory: true)
        testPaymentForm.securityCode = nil
        let model = makeViewModel(paymentFormStyle: testPaymentForm)
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate
        
        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = expectedCallbacks
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            expectedCallbacks -= 1
            // On the last call we expect that all mandatory inputs were provided
            if expectedCallbacks == 0 {
                XCTAssertTrue(isMandatoryInputProvided)
            } else {
                XCTAssertFalse(isMandatoryInputProvided)
            }
            expectation.fulfill()
        }

        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))
        model.update(result: .success(("4242424242424242", .visa)))

        waitForExpectations(timeout: 0.1)
    }

    func testMandatoryBillingNotPresentFailMandatoryInput() {
        let testPaymentForm = makePaymentFormStyle(isBillingMandatory: true)
        let model = makeViewModel(paymentFormStyle: testPaymentForm)
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate

        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = 2
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            XCTAssertFalse(isMandatoryInputProvided)
            expectation.fulfill()
        }

        model.update(result: .success(("4242424242424242", .visa)))
        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))

        waitForExpectations(timeout: 0.1)
    }

    func testOptionalBillingNotPresentPassesMandatoryInput() {
        var expectedCallbacks = 3
        let testPaymentForm = makePaymentFormStyle(isBillingMandatory: false)
        let model = makeViewModel(paymentFormStyle: testPaymentForm)
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate

        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = expectedCallbacks
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            expectedCallbacks -= 1
            // On the last call we expect that all mandatory inputs were provided
            if expectedCallbacks == 0 {
                XCTAssertTrue(isMandatoryInputProvided)
            } else {
                XCTAssertFalse(isMandatoryInputProvided)
            }
            expectation.fulfill()
        }

        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))
        model.update(result: .success(("4242424242424242", .visa)))
        model.securityCodeIsUpdated(to: "123")

        waitForExpectations(timeout: 0.1)
    }

    func testMissingBillingPassesMandatoryInput() {
        var expectedCallbacks = 3
        var testPaymentForm = makePaymentFormStyle(isBillingMandatory: true)
        testPaymentForm.editBillingSummary = nil
        let model = makeViewModel(paymentFormStyle: testPaymentForm)
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate

        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = expectedCallbacks
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            expectedCallbacks -= 1
            // On the last call we expect that all mandatory inputs were provided
            if expectedCallbacks == 0 {
                XCTAssertTrue(isMandatoryInputProvided)
            } else {
                XCTAssertFalse(isMandatoryInputProvided)
            }
            expectation.fulfill()
        }

        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))
        model.update(result: .success(("4242424242424242", .visa)))
        model.securityCodeIsUpdated(to: "123")

        waitForExpectations(timeout: 0.1)
    }

    func testMissingCardNumberFailMandatoryInput() {
        let testPaymentForm = makePaymentFormStyle(isCardholderMandatory: true,
                                                   isSecurityCodeMandatory: true,
                                                   isBillingMandatory: true)
        let model = makeViewModel(paymentFormStyle: testPaymentForm)
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate

        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = 4
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.updateCardholderCompletion = { }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            XCTAssertFalse(isMandatoryInputProvided)
            expectation.fulfill()
        }

        model.cardholderIsUpdated(value: "John Price")
        model.securityCodeIsUpdated(to: "123")
        model.onTapDoneButton(data: makeMockBillingForm())
        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))

        waitForExpectations(timeout: 0.1)
    }

    func testIncompleteCardNumberFailMandatoryInput() {
        let testPaymentForm = makePaymentFormStyle(isCardholderMandatory: true,
                                                   isSecurityCodeMandatory: true,
                                                   isBillingMandatory: true)
        let model = makeViewModel(paymentFormStyle: testPaymentForm)
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate

        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = 5
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.updateCardholderCompletion = { }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            XCTAssertFalse(isMandatoryInputProvided)
            expectation.fulfill()
        }

        model.cardholderIsUpdated(value: "John Price")
        model.securityCodeIsUpdated(to: "123")
        model.onTapDoneButton(data: makeMockBillingForm())
        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))
        model.update(result: .success((cardNumber: "42424242", scheme: .visa)))

        waitForExpectations(timeout: 0.1)
    }

    func testMissingExpiryDateFailMandatoryInput() {
        let testPaymentForm = makePaymentFormStyle(isCardholderMandatory: true,
                                                   isSecurityCodeMandatory: true,
                                                   isBillingMandatory: true)
        let model = makeViewModel(paymentFormStyle: testPaymentForm)
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate

        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = 4
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.updateCardholderCompletion = { }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            XCTAssertFalse(isMandatoryInputProvided)
            expectation.fulfill()
        }

        model.cardholderIsUpdated(value: "John Price")
        model.securityCodeIsUpdated(to: "123")
        model.onTapDoneButton(data: makeMockBillingForm())
        model.update(result: .success((cardNumber: "4242424242424242", scheme: .visa)))

        waitForExpectations(timeout: 0.1)
    }

    func testHistoricExpiryDateFailMandatoryInput() {
        let testPaymentForm = makePaymentFormStyle(isCardholderMandatory: true,
                                                   isSecurityCodeMandatory: true,
                                                   isBillingMandatory: true)
        let model = makeViewModel(paymentFormStyle: testPaymentForm)
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate

        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = 5
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.updateCardholderCompletion = { }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            XCTAssertFalse(isMandatoryInputProvided)
            expectation.fulfill()
        }

        model.cardholderIsUpdated(value: "John Price")
        model.securityCodeIsUpdated(to: "123")
        model.onTapDoneButton(data: makeMockBillingForm())
        model.update(result: .success((cardNumber: "4242424242424242", scheme: .visa)))
        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 01, year: 1800)))

        waitForExpectations(timeout: 0.1)
    }

    func testCardNumberAndExpiryDateProvidedAllOtherOptionalMissingIsValid() {
        var expectedCallbacks = 2
        var testPaymentForm = makePaymentFormStyle(isCardholderMandatory: false,
                                                   isSecurityCodeMandatory: false,
                                                   isBillingMandatory: false)
        testPaymentForm.securityCode = nil
        let model = makeViewModel(paymentFormStyle: testPaymentForm)

        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = 2
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate
        testDelegate.refreshPayButtonStateCompletion = { isButtonEnabled in
            expectedCallbacks -= 1
            if expectedCallbacks == 0 {
                XCTAssertTrue(isButtonEnabled)
            } else {
                XCTAssertFalse(isButtonEnabled)
            }
            expectation.fulfill()
        }
        testDelegate.updateCardSchemeCompletion = { _ in }

        model.update(result: .success((cardNumber: "4242424242424242", scheme: .visa)))
        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))

        waitForExpectations(timeout: 0.1)
    }

    func testAllFieldsRequiredAndProvided() {
        var expectedCallbacks = 6
        let testPaymentForm = makePaymentFormStyle(isCardholderMandatory: true,
                                                   isSecurityCodeMandatory: true,
                                                   isBillingMandatory: true)
        let model = makeViewModel(paymentFormStyle: testPaymentForm)

        let expectation = expectation(description: "Callback is expected")
        expectation.expectedFulfillmentCount = expectedCallbacks
        let testDelegate = MockPaymentViewModelDelegate()
        model.delegate = testDelegate
        testDelegate.updateCardSchemeCompletion = { _ in }
        testDelegate.updateCardholderCompletion = { }
        testDelegate.refreshPayButtonStateCompletion = { isMandatoryInputProvided in
            expectedCallbacks -= 1
            if expectedCallbacks == 0 {
                XCTAssertTrue(isMandatoryInputProvided)
            } else {
                XCTAssertFalse(isMandatoryInputProvided)
            }
            expectation.fulfill()
        }

        model.cardholderIsUpdated(value: "John Price")
        model.securityCodeIsUpdated(to: "123")
        model.onTapDoneButton(data: makeMockBillingForm())
        model.expiryDateIsUpdated(result: .success(ExpiryDate(month: 5, year: 2067)))
        model.update(result: .success((cardNumber: "42424242", scheme: .visa)))
        model.update(result: .success((cardNumber: "4242424242424242", scheme: .visa)))

        waitForExpectations(timeout: 0.1)
    }

    func testPayButtonPressedWithAllDataValid() {
        let fakeService = StubCheckoutAPIService()
        let fakeLogger = StubFramesEventLogger()
        let model = makeViewModel(apiService: fakeService, logger: fakeLogger)

        let cardNumber = "4242424242424242"
        let expiryDate = ExpiryDate(month: 5, year: 2067)
        model.update(result: .success((cardNumber: cardNumber, scheme: .visa)))
        model.expiryDateIsUpdated(result: .success(expiryDate))

        model.payButtonIsPressed()

        let expectedPaymentCard = Card(number: cardNumber, expiryDate: expiryDate, name: "", cvv: "", billingAddress: nil, phone: nil)
        XCTAssertTrue(model.isLoading)
        XCTAssertNotNil(fakeService.createTokenCalledWith)
        XCTAssertEqual(fakeService.createTokenCalledWith?.paymentSource, .card(expectedPaymentCard))
        XCTAssertFalse(fakeService.loggerCalled)
        XCTAssertEqual(fakeLogger.logCalledWithFramesLogEvents, [.paymentFormSubmitted])
    }

    func testPayButtonOutcomeSuccess() {
        let fakeService = StubCheckoutAPIService()
        let testToken = "t3sTtok3n"
        fakeService.createTokenCompletionResult = .success(StubCheckoutAPIService.createTokenDetails(token: testToken))
        let fakeLogger = StubFramesEventLogger()
        let model = makeViewModel(apiService: fakeService, logger: fakeLogger)

        let cardNumber = "4242424242424242"
        let expiryDate = ExpiryDate(month: 5, year: 2067)
        model.update(result: .success((cardNumber: cardNumber, scheme: .visa)))
        model.expiryDateIsUpdated(result: .success(expiryDate))

        model.payButtonIsPressed()

        XCTAssertFalse(model.isLoading)
        XCTAssertNotNil(fakeService.createTokenCalledWith)
        XCTAssertEqual(fakeLogger.logCalledWithFramesLogEvents, [.paymentFormSubmitted, .paymentFormSubmittedResult(token: testToken)])
    }

    func testPayButtonOutcomeFailure() {
        let fakeService = StubCheckoutAPIService()
        let responseError = TokenisationError.TokenRequest.networkError(.connectionFailed)
        fakeService.createTokenCompletionResult = .failure(responseError)
        let fakeLogger = StubFramesEventLogger()
        let model = makeViewModel(apiService: fakeService, logger: fakeLogger)

        let cardNumber = "4242424242424242"
        let expiryDate = ExpiryDate(month: 5, year: 2067)
        model.update(result: .success((cardNumber: cardNumber, scheme: .visa)))
        model.expiryDateIsUpdated(result: .success(expiryDate))

        model.payButtonIsPressed()

        XCTAssertFalse(model.isLoading)
        XCTAssertNotNil(fakeService.createTokenCalledWith)
        let expectedWarnMessage = "\(responseError.code) \(responseError.localizedDescription)"
        XCTAssertEqual(fakeLogger.logCalledWithFramesLogEvents, [.paymentFormSubmitted, .warn(message: expectedWarnMessage)])
    }
    
    private func makeViewModel(apiService: Frames.CheckoutAPIProtocol = StubCheckoutAPIService(),
                               cardValidator: CardValidator = CardValidator(environment: .sandbox),
                               logger: FramesEventLogging = StubFramesEventLogger(),
                               billingForm: BillingForm? = nil,
                               paymentFormStyle: PaymentFormStyle? = nil,
                               billingFormStyle: BillingFormStyle? = nil,
                               supportedCardSchemes: [Card.Scheme] = [.mastercard, .visa]) -> DefaultPaymentViewModel {
        DefaultPaymentViewModel(checkoutAPIService: apiService,
                                cardValidator: cardValidator,
                                logger: logger,
                                billingFormData: billingForm,
                                paymentFormStyle: paymentFormStyle,
                                billingFormStyle: billingFormStyle,
                                supportedSchemes: supportedCardSchemes)
    }

    private func makeMockBillingForm() -> BillingForm {
        BillingForm(name: "John", address: Address(addressLine1: "Kong Drive", addressLine2: "Blister", city: "Dreamland", state: nil, zip: "DR38ML", country: Country.allAvailable.first), phone: nil)
    }

    private func makePaymentFormStyle(isCardholderMandatory: Bool = false,
                                      isSecurityCodeMandatory: Bool = false,
                                      isBillingMandatory: Bool = false) -> PaymentFormStyle {
        var style = DefaultPaymentFormStyle()

        let cardholderInput = DefaultCardholderFormStyle(isMandatory: isCardholderMandatory)
        style.cardholderInput = cardholderInput

        let securityCode = DefaultSecurityCodeFormStyle(isMandatory: isSecurityCodeMandatory)
        style.securityCode = securityCode

        let addBillingDetails = DefaultAddBillingDetailsViewStyle(isMandatory: isBillingMandatory)
        style.addBillingSummary = addBillingDetails

        let billingSummary = DefaultBillingSummaryViewStyle(isMandatory: isBillingMandatory)
        style.editBillingSummary = billingSummary

        return style
    }
}
