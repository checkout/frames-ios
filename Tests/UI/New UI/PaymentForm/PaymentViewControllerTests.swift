//
//  PaymentViewControllerTests.swift
//
//  Created by Ehab Alsharkawy
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
import Checkout
@testable import Frames

class PaymentViewControllerTests: XCTestCase {
  var viewController: PaymentViewController!
  var viewModel: DefaultPaymentViewModel!
  let delegate = PaymentViewControllerMockDelegate()
  let stubCheckoutAPIService = StubCheckoutAPIService()
  
  override func setUp() {
    super.setUp()
    
    let testBillingFormData = BillingForm(name: "Name",
                                          address: Address(addressLine1: "addressLine1",
                                                           addressLine2: "addressLine2",
                                                           city: "city",
                                                           state: "state",
                                                           zip: "zip",
                                                           country: Country(iso3166Alpha2: "GB")!),
                                          phone: Phone(number: "0771234567",
                                                       country: Country(iso3166Alpha2: "GB")!))
    viewModel = DefaultPaymentViewModel(checkoutAPIService: stubCheckoutAPIService,
                                        cardValidator: CardValidator(environment: .sandbox),
                                        logger: StubFramesEventLogger(),
                                        billingFormData: testBillingFormData,
                                        paymentFormStyle: DefaultPaymentFormStyle(),
                                        billingFormStyle: DefaultBillingFormStyle(),
                                        supportedSchemes: [.discover, .mada])
    viewController = PaymentViewController(viewModel: viewModel)
  }
  
  func testPaymentViewsHierarchy() {
    viewController.viewDidLoad()
    viewController.viewDidLayoutSubviews()
    
    let mainView = viewController.view
    XCTAssertEqual(mainView?.subviews.count, 1)
    XCTAssertTrue(mainView?.subviews[0] is UIScrollView)
    
    let scrollView = mainView?.subviews[0]
    XCTAssertEqual(scrollView?.subviews.count, 1)
    XCTAssertTrue(scrollView?.subviews[0] is UIStackView)
    
    let stackView = scrollView?.subviews[0]
    XCTAssertEqual(stackView?.subviews.count, 8)
    XCTAssertTrue(stackView?.subviews[0] is UIView) // background for the header view
    XCTAssertTrue(stackView?.subviews[1] is PaymentHeaderView)
    XCTAssertTrue(stackView?.subviews[2] is CardNumberView)
    XCTAssertTrue(stackView?.subviews[3] is ExpiryDateView)
    XCTAssertTrue(stackView?.subviews[4] is SecurityCodeView)
    XCTAssertTrue(stackView?.subviews[5] is SelectionButtonView)
    XCTAssertTrue(stackView?.subviews[6] is BillingFormSummaryView)
    XCTAssertTrue(stackView?.subviews[7] is ButtonView) // pay button
  }
  
  func testCallDelegateMethodOnTapAddBillingButton() {
    viewController.delegate = delegate
    let navigationController = UINavigationController(rootViewController: viewController)
    viewController.selectionButtonIsPressed()
    XCTAssertEqual(delegate.addBillingButtonIsPressedWithSender.count, 1)
    XCTAssertEqual(delegate.addBillingButtonIsPressedWithSender.last, navigationController)
  }
  
  func testCallDelegateMethodOnTapEditBillingButton() {
    viewController.delegate = delegate
    let navigationController = UINavigationController(rootViewController: viewController)
    viewController.summaryButtonIsPressed()
    XCTAssertEqual(delegate.editBillingButtonIsPressedWithSender.count, 1)
    XCTAssertEqual(delegate.editBillingButtonIsPressedWithSender.last, navigationController)
  }
  
  func testCallDelegateMethodFinishEditingExpiryDateView() {
    viewController.delegate = delegate
    let expiryDate = ExpiryDate(month: 01, year: 25)
    viewController.update(result: .success(expiryDate))
    XCTAssertEqual(delegate.expiryDateIsUpdatedWithValue.count, 1)
    switch delegate.expiryDateIsUpdatedWithValue.last {
      case .success(let result):
        XCTAssertEqual(result, expiryDate)
      default:
        XCTFail()
    }

  }
  
  func testCallDelegateMethodFinishEditingSecurityCodeView() {
    viewController.delegate = delegate
    let value = "1234"
    viewController.update(result: .success("1234"))
    XCTAssertEqual(delegate.securityCodeIsUpdatedWithValue.count, 1)
    switch delegate.securityCodeIsUpdatedWithValue.last {
      case .success(let result):
        XCTAssertEqual(result, value)
      default:
        XCTFail()
    }
  }

  func testCallDelegateMethodOnTapPayButton() {
    viewController.delegate = delegate
    let button = UIButton()
    viewController.selectionButtonIsPressed(sender: button)
    XCTAssertEqual(delegate.payButtonIsPressedCounter, 1)
  }
  
  func testCardTokenRequested() {
    let expectation = XCTestExpectation(description: #function)
    let stubCardValidator = MockCardValidator()
    stubCardValidator.validateCardNumberToReturn = .success(.visa)
    stubCheckoutAPIService.cardValidatorToReturn = stubCardValidator
    viewController.viewDidLoad()

    viewModel.update(result: .success(CardInfo("4242 4242 4242 4242", .visa)))
    viewController.update(result: .success(ExpiryDate(month: 01, year: 25)))

    viewModel.cardTokenRequested = { result in
      if case let .success(token) = result {
        XCTAssertEqual(token, StubCheckoutAPIService.createTokenDetails())
      } else {
        XCTFail("card Token has changes")
      }
      expectation.fulfill()
    }
    
    let button = UIButton()
    viewController.selectionButtonIsPressed(sender: button)
    
    wait(for: [expectation], timeout: 1)
  }
  
  func testPaymentViewControllerNotSendingPaymentFormPresentedOnWrongLifecycleEvent() {
    let testLogger = StubFramesEventLogger()
    let testViewModel = DefaultPaymentViewModel(checkoutAPIService: stubCheckoutAPIService,
                                                cardValidator: CardValidator(environment: .sandbox),
                                                logger: testLogger,
                                                billingFormData: nil,
                                                paymentFormStyle: nil,
                                                billingFormStyle: nil,
                                                supportedSchemes: [])
    let testVC = PaymentViewController(viewModel: testViewModel)
    
    let expect = expectation(description: "Free up main thread in case UI work influences outcome")
    testVC.viewDidLoad()
    testVC.viewDidAppear(false)
    testVC.viewDidLayoutSubviews()
    testVC.viewWillDisappear(false)
    testVC.viewDidDisappear(false)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      expect.fulfill()
    }
    
    waitForExpectations(timeout: 1)
    
    XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
    XCTAssertTrue(testLogger.logCalledWithFramesLogEvents.isEmpty)
  }
  
  func testPaymentViewControllerSendingPaymentForPresentedOnLifecycleEvent() {
    let testLogger = StubFramesEventLogger()
    let testViewModel = DefaultPaymentViewModel(checkoutAPIService: stubCheckoutAPIService,
                                                cardValidator: CardValidator(environment: .sandbox),
                                                logger: testLogger,
                                                billingFormData: nil,
                                                paymentFormStyle: nil,
                                                billingFormStyle: nil,
                                                supportedSchemes: [])
    let testVC = PaymentViewController(viewModel: testViewModel)
    
    XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
    XCTAssertTrue(testLogger.logCalledWithFramesLogEvents.isEmpty)
    
    testVC.viewWillAppear(false)
    
    XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
    XCTAssertEqual(testLogger.logCalledWithFramesLogEvents.count, 1)
    XCTAssertEqual(testLogger.logCalledWithFramesLogEvents.first, .paymentFormPresented)
  }
}
