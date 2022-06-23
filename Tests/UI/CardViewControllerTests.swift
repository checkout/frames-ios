import XCTest
import CheckoutEventLoggerKit
@testable import Frames
import Checkout

class CardViewControllerTests: XCTestCase {

    var cardViewController: CardViewController!
    // swiftlint:disable:next weak_delegate
    var cardViewControllerDelegate: CardViewControllerMockDelegate!
    var stubCheckoutAPIService: StubCheckoutAPIService!

    override func setUp() {
        super.setUp()
        UIFont.loadAllCheckoutFonts
        cardViewController = CardViewController()
        cardViewControllerDelegate = CardViewControllerMockDelegate()
        stubCheckoutAPIService = StubCheckoutAPIService()
        let navigation = UINavigationController()
        navigation.viewControllers = [cardViewController]
    }

    override func tearDown() {
        cardViewController = nil
        cardViewControllerDelegate = nil
        stubCheckoutAPIService = nil

        super.tearDown()
    }

    func testInitialization() {
        /// Empty constructor
        let cardViewController = CardViewController()
        XCTAssertEqual(cardViewController.cardHolderNameState, .required)
        XCTAssertEqual(cardViewController.billingDetailsState, .required)
        XCTAssertEqual(cardViewController.isNewUI, false)
        cardViewController.viewDidLoad()
        XCTAssertEqual(cardViewController.cardView.stackView.subviews.count, 5)
        cardViewController.viewDidLayoutSubviews()
        XCTAssertEqual(cardViewController.view.subviews.count, 1)
    }

    func testInitializationHiddenFields() {
        let cardViewController = CardViewController(isNewUI: false,
                                                    checkoutAPIService: stubCheckoutAPIService,
                                                    billingFormData: nil,
                                                    cardHolderNameState: .hidden,
                                                    billingDetailsState: .hidden)
        XCTAssertEqual(cardViewController.cardHolderNameState, .hidden)
        XCTAssertEqual(cardViewController.billingDetailsState, .hidden)
        XCTAssertEqual(cardViewController.isNewUI, false)

        cardViewController.viewDidLoad()
        XCTAssertEqual(cardViewController.cardView.stackView.subviews.count, 3)
    }

    func testInitializationNibBundle() {
        let cardViewController = CardViewController(nibName: nil, bundle: nil)
        XCTAssertEqual(cardViewController.cardHolderNameState, .required)
        XCTAssertEqual(cardViewController.billingDetailsState, .required)
        XCTAssertEqual(cardViewController.isNewUI, false)
        cardViewController.viewDidLoad()
        XCTAssertEqual(cardViewController.cardView.stackView.subviews.count, 5)
    }

    func testInitializationCoder() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let cardViewController = CardViewController(coder: coder)
        XCTAssertEqual(cardViewController?.cardHolderNameState, .required)
        XCTAssertEqual(cardViewController?.billingDetailsState, .required)
        XCTAssertEqual(cardViewController?.isNewUI, false)
        cardViewController?.viewDidLoad()
        XCTAssertEqual(cardViewController?.cardView.stackView.subviews.count, 5)
    }

    func testAddHandlersInViewWillAppear() {
        cardViewController.notificationCenter = NotificationCenterMock()
        cardViewController.viewWillAppear(true)
        if let notificationCenterMock = cardViewController.notificationCenter as? NotificationCenterMock {
            XCTAssertEqual(notificationCenterMock.handlers.count, 2)
            XCTAssertEqual(notificationCenterMock.handlers[0].name, UIResponder.keyboardWillShowNotification)
            XCTAssertEqual(notificationCenterMock.handlers[1].name, UIResponder.keyboardWillHideNotification)
        } else {
            XCTFail("Notification center is not a mock")
        }
    }

    func testRemoveHandlersInViewWillDisappear() {
        cardViewController.notificationCenter = NotificationCenterMock()
        // Add the handlers
        testAddHandlersInViewWillAppear()
        // Remove the handlers
        cardViewController.viewWillDisappear(true)
        if let notificationCenterMock = cardViewController.notificationCenter as? NotificationCenterMock {
            XCTAssertEqual(notificationCenterMock.handlers.count, 0)
        } else {
            XCTFail("Notification center is not a mock")
        }
    }

    func testKeyboardWillShow() {
        /// Mock Address View Controller
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let cardVC = CardViewControllerMock(coder: coder)
        cardVC?.viewDidLoad()
        let notification = NSNotification(name: UIResponder.keyboardWillHideNotification, object: nil, userInfo: [
            UIResponder.keyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
            ])
        cardVC?.keyboardWillShow(notification: notification)
        XCTAssertEqual(cardVC?.kbShowCalledTimes, 1)
        XCTAssertEqual(cardVC?.kbShowLastCalledWith?.0, notification)
        XCTAssertEqual(cardVC?.kbShowLastCalledWith?.1, cardVC?.cardView.scrollView)
    }

    func testKeyboardWillHide() {
        /// Mock Address View Controller
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let cardVC = CardViewControllerMock(coder: coder)
        cardVC?.viewDidLoad()
        let notification = NSNotification(name: UIResponder.keyboardWillHideNotification, object: nil, userInfo: [
            UIResponder.keyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
            ])
        cardVC?.keyboardWillHide(notification: notification)
        XCTAssertEqual(cardVC?.kbHideCalledTimes, 1)
        XCTAssertEqual(cardVC?.kbHideLastCalledWith?.0, notification)
        XCTAssertEqual(cardVC?.kbHideLastCalledWith?.1, cardVC?.cardView.scrollView)
    }

    func testValidateFieldsWithRequiredBillingDetailsMissing() {
        // Setup
        let cardViewController = CardViewController(isNewUI: false,
                                                    checkoutAPIService: stubCheckoutAPIService,
                                                    billingFormData: nil,
                                                    cardHolderNameState: .hidden,
                                                    billingDetailsState: .required)
        XCTAssertEqual(cardViewController.isNewUI, false)
        cardViewController.viewDidLoad()
        XCTAssertFalse((cardViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
        // Simulate the end of a text field editing
        cardViewController.textFieldDidEndEditing(cardViewController.cardView.cvvInputView.textField)
        // Assert
        XCTAssertFalse((cardViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
    }

    func testValidateFieldsWithRequiredNameMissing() {
        // Setup
        let cardViewController = CardViewController(isNewUI: false,
                                                    checkoutAPIService: stubCheckoutAPIService,
                                                    billingFormData: nil,
                                                    cardHolderNameState: .required,
                                                    billingDetailsState: .hidden)
        XCTAssertEqual(cardViewController.isNewUI, false)
        cardViewController.viewDidLoad()
        XCTAssertFalse((cardViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
        // Simulate the end of a text field editing
        cardViewController.textFieldDidEndEditing(cardViewController.cardView.cvvInputView.textField)
        // Assert
        XCTAssertFalse((cardViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
    }

    func testValidateFields() {
        // Setup
        let cardViewController = CardViewController(isNewUI: false,
                                                    checkoutAPIService: stubCheckoutAPIService,
                                                    billingFormData: nil,
                                                    cardHolderNameState: .hidden,
                                                    billingDetailsState: .hidden)
        XCTAssertEqual(cardViewController.isNewUI, false)
        cardViewController.viewDidLoad()
        XCTAssertFalse((cardViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
        cardViewController.cardView.cardNumberInputView.textField.text = "4242 4242 4242 4242"
        cardViewController.cardView.expirationDateInputView.textField.text = "06/2020"
        cardViewController.cardView.cvvInputView.textField.text = "100"
        // Simulate the end of a text field editing
        cardViewController.textFieldDidEndEditing(cardViewController.cardView.cvvInputView.textField)
        // Assert
        XCTAssertTrue((cardViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
    }

    func testValidateFieldsWithEmptyValues() {
        // Setup
        let cardViewController = CardViewController(isNewUI: false,
                                                    checkoutAPIService: stubCheckoutAPIService,
                                                    billingFormData: nil,
                                                    cardHolderNameState: .hidden,
                                                    billingDetailsState: .hidden)
        XCTAssertEqual(cardViewController.isNewUI, false)
        cardViewController.viewDidLoad()
        XCTAssertFalse((cardViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
        // Simulate the end of a text field editing
        cardViewController.textFieldDidEndEditing(cardViewController.cardView.cvvInputView.textField)
        // Assert
        XCTAssertFalse((cardViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
    }

    func testDoNothingWhenTapDoneIfCardDoesNotHaveType() {
        // Setup
        cardViewController.viewDidLoad()
        cardViewController.cardView.cardNumberInputView.textField.text = "5"
        cardViewController.cardView.expirationDateInputView.textField.text = "06/2020"
        cardViewController.cardView.cvvInputView.textField.text = "100"
        // Execute
        cardViewController.delegate = cardViewControllerDelegate
        cardViewController.onTapDoneCardButton()
        // Assert
        XCTAssertEqual(cardViewControllerDelegate.calledTimes, 0)
        XCTAssertNil(cardViewControllerDelegate.lastCalledWith)
    }

    func testDoNothingWhenTapDoneIfCardNumberInvalid() {
        // Setup
        cardViewController.viewDidLoad()
        cardViewController.cardView.cardNumberInputView.textField.text = "4242 4242 4242 4243"
        cardViewController.cardView.expirationDateInputView.textField.text = "06/2020"
        cardViewController.cardView.cvvInputView.textField.text = "100"
        // Execute
        cardViewController.delegate = cardViewControllerDelegate
        cardViewController.onTapDoneCardButton()
        // Assert
        XCTAssertEqual(cardViewControllerDelegate.calledTimes, 0)
        XCTAssertNil(cardViewControllerDelegate.lastCalledWith)
    }

    func testDoNothingWhenTapDoneIfCardTypeNotAccepted() {
        // Setup
        cardViewController.availableSchemes = [.mastercard]
        cardViewController.viewDidLoad()
        cardViewController.cardView.cardNumberInputView.textField.text = "4242 4242 4242 4242"
        cardViewController.cardView.expirationDateInputView.textField.text = "06/2020"
        cardViewController.cardView.cvvInputView.textField.text = "100"
        // Execute
        cardViewController.delegate = cardViewControllerDelegate
        cardViewController.onTapDoneCardButton()
        // Assert
        XCTAssertEqual(cardViewControllerDelegate.calledTimes, 0)
        XCTAssertNil(cardViewControllerDelegate.lastCalledWith)
    }

    func testDoNothingWhenTapDoneIfExpirationDateInvalid() {
        // Setup
        cardViewController.viewDidLoad()
        cardViewController.cardView.cardNumberInputView.textField.text = "4242 4242 4242 4242"
        cardViewController.cardView.expirationDateInputView.textField.text = "06/2017"
        cardViewController.cardView.cvvInputView.textField.text = "100"
        // Execute
        cardViewController.delegate = cardViewControllerDelegate
        cardViewController.onTapDoneCardButton()
        // Assert
        XCTAssertEqual(cardViewControllerDelegate.calledTimes, 0)
        XCTAssertNil(cardViewControllerDelegate.lastCalledWith)
    }

    func testDoNothingWhenTapDoneIfCvvInvalid() {
        // Setup
        cardViewController.viewDidLoad()
        cardViewController.cardView.cardNumberInputView.textField.text = "4242 4242 4242 4242"
        cardViewController.cardView.expirationDateInputView.textField.text = "06/2020"
        cardViewController.cardView.cvvInputView.textField.text = "10"
        // Execute
        cardViewController.delegate = cardViewControllerDelegate
        cardViewController.onTapDoneCardButton()
        // Assert
        XCTAssertEqual(cardViewControllerDelegate.calledTimes, 0)
        XCTAssertNil(cardViewControllerDelegate.lastCalledWith)
    }

//    func testCalledDelegateMethodWhenTapDoneIfDataValid() {
//        // Setup
//        cardViewController.viewDidLoad()
//        cardViewController.cardView.cardNumberInputView.textField.text = "4242 4242 4242 4242"
//        cardViewController.cardView.expirationDateInputView.textField.text = "06/2020"
//        cardViewController.cardView.cvvInputView.textField.text = "100"
//        // Execute
//        cardViewController.delegate = cardViewControllerDelegate
//        cardViewController.onTapDoneCardButton()
//        // Assert
//        XCTAssertEqual(cardViewControllerDelegate.calledTimes, 1)
//    }

    func testPushAddressViewControllerOnTapAddress() {
        cardViewController = CardViewController()
        cardViewControllerDelegate = CardViewControllerMockDelegate()
        let navigation = MockNavigationController()
        navigation.viewControllers = [cardViewController]
        cardViewController.onTapAddressView()
        XCTAssertTrue(navigation.pushedViewController is AddressViewController)
    }

    func testOnTapDoneButtonAddress() {
        let country = Country.allAvailable.first { $0.iso3166Alpha2 == "FR" }!
        let address = Address(addressLine1: "12 rue de la boulangerie",
                              addressLine2: nil,
                              city: "Lyon",
                              state: nil,
                              zip: "69002",
                              country: country)
        let phone = Phone(number: nil, country: country)
        cardViewController.onTapDoneButton(controller: cardViewController.addressViewController,
                                           address: address,
                                           phone: phone)
        XCTAssertFalse((cardViewController.cardView.billingDetailsInputView.value.text?.isEmpty)!)
    }

    func testChangeCvvCardTypeOnCardNumberEndEditing() {
        let cardViewController = CardViewController(isNewUI: false,
                                                    checkoutAPIService: stubCheckoutAPIService,
                                                    billingFormData: nil,
                                                    cardHolderNameState: .hidden,
                                                    billingDetailsState: .required)
        XCTAssertEqual(cardViewController.isNewUI, false)

        let stubCardValidator = StubCardValidator()
        stubCardValidator.validateCardNumberToReturn = .success(.visa)
        stubCheckoutAPIService.cardValidatorToReturn = stubCardValidator

        cardViewController.cardView.cardNumberInputView.textField.text = "4242 4242 4242 4242"
        cardViewController.textFieldDidEndEditing(view: cardViewController.cardView.cardNumberInputView)
        XCTAssertEqual(cardViewController.cardView.cvvInputView.scheme, .visa)
    }

    func testSetImageHighlightedOnChangeCardType() {
        cardViewController.availableSchemes = [.visa, .mastercard, .discover, .dinersClub]
        cardViewController.cardView.schemeIconsStackView.setIcons(schemes: cardViewController.availableSchemes)
        cardViewController.onChangeCardNumber(scheme: .visa)
        let nFadedCard = cardViewController.cardView.schemeIconsStackView.arrangedSubviews
            .filter { $0.alpha == 0.5}.count
        XCTAssertEqual(nFadedCard, 4)
    }

    func testChangeImageHighlightedOChangeCardType() {
        testSetImageHighlightedOnChangeCardType()
        cardViewController.onChangeCardNumber(scheme: .mastercard)
        let nFadedCard = cardViewController.cardView.schemeIconsStackView.arrangedSubviews
            .filter { $0.alpha == 0.5}.count
        XCTAssertEqual(nFadedCard, 4)
    }

    func testResetViewOnChangeIfCardNumberUnknownType() {
        testSetImageHighlightedOnChangeCardType()
        cardViewController.onChangeCardNumber(scheme: .unknown)
        let nFadedCard = cardViewController.cardView.schemeIconsStackView.arrangedSubviews
            .filter { $0.alpha == 0.5}.count
        XCTAssertEqual(nFadedCard, 0)
    }

    func test_onTapDoneCardButton_checkoutAPIClientReturnsError_delegateCalledWithFailure() {

        let stubCardViewControllerDelegate = StubCardViewControllerDelegate()
        let cardViewController = CardViewController(isNewUI: false,
                                                    checkoutAPIService: stubCheckoutAPIService,
                                                    billingFormData: nil,
                                                    cardHolderNameState: .normal,
                                                    billingDetailsState: .normal)
        XCTAssertEqual(cardViewController.isNewUI, false)

        cardViewController.delegate = stubCardViewControllerDelegate
        cardViewController.cardView.cardNumberInputView.textField.text = "4242 4242 4242 4242"
        cardViewController.cardView.cvvInputView.textField.text = "123"
        cardViewController.cardView.expirationDateInputView.textField.text = "01/23"

        cardViewController.onTapDoneCardButton()

        stubCheckoutAPIService.createTokenCalledWith?.completion(.failure(.networkError(.connectionLost)))

        XCTAssertEqual(stubCardViewControllerDelegate.onTapDoneCalledWith?.controller, cardViewController)
        XCTAssertEqual(stubCardViewControllerDelegate.onTapDoneCalledWith?.result, .failure(.networkError(.connectionLost)))
    }

    func test_viewDidLoad_paymentFormPresentedLogCalled() {

        let cardViewController = CardViewController(isNewUI: false,
                                                    checkoutAPIService: stubCheckoutAPIService,
                                                    billingFormData: nil,
                                                    cardHolderNameState: .normal,
                                                    billingDetailsState: .normal)
        XCTAssertEqual(cardViewController.isNewUI, false)
        cardViewController.viewWillAppear(true)

        let events = stubCheckoutAPIService.loggerToReturn.logCalledWithFramesLogEvents
        XCTAssertEqual(1, events.count)

        XCTAssertEqual(.paymentFormPresented, events.first)
        XCTAssertTrue(stubCheckoutAPIService.loggerCalled)
    }

    func test_viewDidLoad_paymentFormPresentedLogNotCalledAfterAddressView() {

        let cardViewController = CardViewController(isNewUI: false,
                                                    checkoutAPIService: stubCheckoutAPIService,
                                                    billingFormData: nil,
                                                    cardHolderNameState: .normal,
                                                    billingDetailsState: .normal)
        XCTAssertEqual(cardViewController.isNewUI, false)
        cardViewController.viewWillAppear(true)

        cardViewController.onTapAddressView()
        cardViewController.viewWillAppear(true)

        cardViewController.viewWillAppear(true)

        let events = stubCheckoutAPIService.loggerToReturn.logCalledWithFramesLogEvents
        XCTAssertEqual(3, events.count)

        XCTAssertEqual(.paymentFormPresented, events.first)
        XCTAssertTrue(stubCheckoutAPIService.loggerCalled)
    }

    func test_onTapAddressView_billingFormPresentedLogCalled() {

        let cardViewController = CardViewController(isNewUI: false,
                                                    checkoutAPIService: stubCheckoutAPIService,
                                                    billingFormData: nil,
                                                    cardHolderNameState: .normal,
                                                    billingDetailsState: .normal)
        XCTAssertEqual(cardViewController.isNewUI, false)
        cardViewController.onTapAddressView()

        let events = stubCheckoutAPIService.loggerToReturn.logCalledWithFramesLogEvents
        XCTAssertEqual(1, events.count)

        XCTAssertEqual(.billingFormPresented, events.first)
        XCTAssertTrue(stubCheckoutAPIService.loggerCalled)
    }

    func testUpdateBillingFormDetailsInputView(){
        let country = Country.allAvailable.first { $0.iso3166Alpha2 == "FR" }!
        let address = Address(addressLine1: "12 rue de la boulangerie",
                              addressLine2: nil,
                              city: "Lyon",
                              state: nil,
                              zip: "69002",
                              country: country)
        let phone = Phone(number: "+44123456789", country: country)
        let billingForm = BillingForm(name: "John smith", address: address, phone: phone)
        let summaryStyle = DefaultSummaryViewStyle()
        let summaryValue = "John smith\n\n12 rue de la boulangerie\n\nLyon\n\n69002\n\nFrance\n\n+44123456789"
        let cardViewController = CardViewController(isNewUI: true,
                                                    summaryCellButtonStyle: summaryStyle,
                                                    checkoutAPIService: stubCheckoutAPIService,
                                                    billingFormData: billingForm,
                                                    cardHolderNameState: .normal,
                                                    billingDetailsState: .normal)
        XCTAssertEqual(cardViewController.isNewUI, true)
        XCTAssertEqual(cardViewController.summaryCellButtonStyle?.summary.text, summaryValue)
    }
}
