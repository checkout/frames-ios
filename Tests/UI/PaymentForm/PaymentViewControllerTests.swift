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
  var viewController: FramesPaymentViewController!
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
    viewController = FramesPaymentViewController(viewModel: viewModel)
  }
  
  func testPaymentViewsHierarchy() {
    viewController.viewDidLoad()
    viewController.viewDidLayoutSubviews()
    
    let mainView = viewController.view
    XCTAssertEqual(mainView?.subviews.count, 2)
    XCTAssertTrue(mainView?.subviews[0] is UIScrollView)
    // Privacy cover is added last so it can be brought to front when active.
    XCTAssertFalse(mainView?.subviews[1] is UIScrollView)
    
    let scrollView = mainView?.subviews[0]
    XCTAssertEqual(scrollView?.subviews.count, 1)
    XCTAssertTrue(scrollView?.subviews[0] is UIStackView)
    
    let stackView = scrollView?.subviews[0]
    XCTAssertEqual(stackView?.subviews.count, 9)
    XCTAssertTrue(stackView?.subviews[0] is UIView) // background for the header view
    XCTAssertTrue(stackView?.subviews[1] is PaymentHeaderView)
    XCTAssertTrue(stackView?.subviews[2] is CardholderView)
    XCTAssertTrue(stackView?.subviews[3] is CardNumberView)
    XCTAssertTrue(stackView?.subviews[4] is ExpiryDateView)
    XCTAssertTrue(stackView?.subviews[5] is SecurityCodeView)
    XCTAssertTrue(stackView?.subviews[6] is SelectionButtonView)
    XCTAssertTrue(stackView?.subviews[7] is BillingFormSummaryView)
    XCTAssertTrue(stackView?.subviews[8] is ButtonView) // pay button
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
    
  func testCallDelegateMethodUpdateEditingCardholderView() {
    let testCardholderValue = "card owner"
    viewController.delegate = delegate
    let testExpectation = expectation(description: "Should call completion handler when triggered")
    delegate.cardholderIsUpdatedCompletionHandler = {
        testExpectation.fulfill()
    }
    viewController.cardholderUpdated(to: testCardholderValue)
      
    waitForExpectations(timeout: 0.1)
    XCTAssertEqual(delegate.cardholderIsUpdatedWithValue, [testCardholderValue])
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
    viewController.update(securityCode: value)
    XCTAssertEqual(delegate.securityCodeIsUpdatedWithValue, [value])
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
      stubCheckoutAPIService.createTokenCompletionResult = .success(StubCheckoutAPIService.createTokenDetails())
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
    let testVC = FramesPaymentViewController(viewModel: testViewModel)
    
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
    let testVC = FramesPaymentViewController(viewModel: testViewModel)
    
    XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
    XCTAssertTrue(testLogger.logCalledWithFramesLogEvents.isEmpty)
    
    testVC.viewWillAppear(false)
    
    XCTAssertTrue(testLogger.addCalledWithMetadataPairs.isEmpty)
    XCTAssertEqual(testLogger.logCalledWithFramesLogEvents.count, 1)
    XCTAssertEqual(testLogger.logCalledWithFramesLogEvents.first, .paymentFormPresented)
  }

  // MARK: - Privacy cover tests

  func testPrivacyCoverIsHiddenInitially() {
    viewController.viewDidLoad()
    let coverView = viewController.view.subviews.last
    XCTAssertNotNil(coverView, "Privacy cover view should be in the hierarchy")
    XCTAssertTrue(coverView?.isHidden ?? false, "Privacy cover should be hidden when the app is active")
  }

  func testPrivacyCoverIsShownWhenAppResignsActive() {
    viewController.viewDidLoad()
    viewController.viewWillAppear(false)

    NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)

    let coverView = viewController.view.subviews.last
    XCTAssertFalse(coverView?.isHidden ?? true, "Privacy cover should be visible when the app resigns active")
  }

  func testPrivacyCoverIsHiddenWhenAppBecomesActive() {
    viewController.viewDidLoad()
    viewController.viewWillAppear(false)

    NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
    NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)

    let coverView = viewController.view.subviews.last
    XCTAssertTrue(coverView?.isHidden ?? false, "Privacy cover should be hidden after the app becomes active again")
  }

  func testPrivacyCoverObserversRemovedOnDisappear() {
    viewController.viewDidLoad()
    viewController.viewWillAppear(false)
    // Observers remain active through viewWillDisappear (to cover animated transitions).
    viewController.viewWillDisappear(false)
    NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
    let coverView = viewController.view.subviews.last
    XCTAssertFalse(coverView?.isHidden ?? true,
                   "Privacy cover must still respond between viewWillDisappear and viewDidDisappear")

    // Reset the cover while observers are still registered.
    NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
    XCTAssertTrue(coverView?.isHidden ?? false, "Privacy cover should hide when the app becomes active")

    // After viewDidDisappear, observers are removed and the cover no longer responds.
    viewController.viewDidDisappear(false)
    NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
    XCTAssertTrue(coverView?.isHidden ?? false,
                  "Privacy cover must not respond after viewDidDisappear deregisters observers")
  }

  func testPrivacyCoverSyncedOnReappearAfterMissedActivation() {
    // Scenario: cover is shown, the VC disappears, the app becomes active while
    // the VC is off-screen (so the didBecomeActive notification is missed), then
    // the VC reappears.  The cover must be hidden when reappear runs.
    viewController.viewDidLoad()
    viewController.viewWillAppear(false)

    // Show the cover.
    NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
    let coverView = viewController.view.subviews.last
    XCTAssertFalse(coverView?.isHidden ?? true, "Cover should be visible after resign-active")

    // VC fully disappears and observers are removed.
    viewController.viewWillDisappear(false)
    viewController.viewDidDisappear(false)

    // App becomes active while VC is off-screen – notification not observed.
    // (No post here; UIApplication.shared.applicationState is .active in XCTest.)

    // VC reappears; syncPrivacyCoverToCurrentState should hide the cover.
    viewController.viewWillAppear(false)
    XCTAssertTrue(coverView?.isHidden ?? false,
                  "Privacy cover must be hidden when the VC reappears and the app is already active")
  }

  func testPrivacyCoverObserversUpgradedAfterWindowAttachment() {
    // Scenario: viewWillAppear fires before a scene is available (windowSceneProvider
    // returns nil), so app-level fallback observers are registered. viewDidAppear fires
    // with a scene now available; it must deregister fallback observers and re-register
    // scene-scoped ones. After the upgrade, app-level notifications must NOT affect the
    // cover, and scene-scoped notifications MUST.
    let sceneToken = NSObject()
    viewController.viewDidLoad()

    // Phase 1 – no scene yet; app-level observers are registered.
    viewController.windowSceneProvider = { nil }
    viewController.viewWillAppear(false)

    // Phase 2 – scene becomes available; viewDidAppear triggers the upgrade.
    viewController.windowSceneProvider = { [weak sceneToken] in sceneToken }
    viewController.viewDidAppear(false)

    let coverView = viewController.view.subviews.last

    // After upgrade, app-level resign-active must NOT show the cover.
    NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
    XCTAssertTrue(coverView?.isHidden ?? false,
                  "App-level notifications must not affect the cover after scene-scoped upgrade")

    // After upgrade, owning-scene deactivation MUST show the cover.
    if #available(iOS 13.0, *) {
      NotificationCenter.default.post(name: UIScene.willDeactivateNotification, object: sceneToken)
      XCTAssertFalse(coverView?.isHidden ?? true,
                     "Cover must be shown when the owning-scene deactivation notification fires")

      // A notification from an UNRELATED scene object must leave the cover unchanged.
      NotificationCenter.default.post(name: UIScene.didActivateNotification, object: sceneToken)
      XCTAssertTrue(coverView?.isHidden ?? false, "Cover should be hidden after scene re-activation")

      let unrelatedToken = NSObject()
      NotificationCenter.default.post(name: UIScene.willDeactivateNotification, object: unrelatedToken)
      XCTAssertTrue(coverView?.isHidden ?? false,
                    "An unrelated-scene notification must not affect the cover")
    }
  }
}
