import XCTest
@testable import FramesIos

class CardViewControllerTests: XCTestCase {

    var cardViewController: CardViewController!
    // swiftlint:disable:next weak_delegate
    var cardViewControllerDelegate: CardViewControllerMockDelegate!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cardViewController = CardViewController()
        cardViewControllerDelegate = CardViewControllerMockDelegate()
        let navigation = UINavigationController()
        navigation.viewControllers = [cardViewController]
    }

    func testInitialization() {
        /// Empty constructor
        let cardViewController = CardViewController()
        XCTAssertEqual(cardViewController.cardHolderNameState, .required)
        XCTAssertEqual(cardViewController.billingDetailsState, .required)
        cardViewController.viewDidLoad()
        XCTAssertEqual(cardViewController.cardView.stackView.subviews.count, 5)
        cardViewController.viewDidLayoutSubviews()
        XCTAssertEqual(cardViewController.view.subviews.count, 1)
    }

    func testInitializationHiddenFields() {
        let cardViewController = CardViewController(cardHolderNameState: .hidden, billingDetailsState: .hidden)
        XCTAssertEqual(cardViewController.cardHolderNameState, .hidden)
        XCTAssertEqual(cardViewController.billingDetailsState, .hidden)
        cardViewController.viewDidLoad()
        XCTAssertEqual(cardViewController.cardView.stackView.subviews.count, 3)
    }

    func testInitializationNibBundle() {
        let cardViewController = CardViewController(nibName: nil, bundle: nil)
        XCTAssertEqual(cardViewController.cardHolderNameState, .required)
        XCTAssertEqual(cardViewController.billingDetailsState, .required)
        cardViewController.viewDidLoad()
        XCTAssertEqual(cardViewController.cardView.stackView.subviews.count, 5)
    }

    func testInitializationCoder() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let cardViewController = CardViewController(coder: coder)
        XCTAssertEqual(cardViewController?.cardHolderNameState, .required)
        XCTAssertEqual(cardViewController?.billingDetailsState, .required)
        cardViewController?.viewDidLoad()
        XCTAssertEqual(cardViewController?.cardView.stackView.subviews.count, 5)
    }

    func testAddHandlersInViewWillAppear() {
        cardViewController.notificationCenter = NotificationCenterMock()
        cardViewController.viewWillAppear(true)
        if let notificationCenterMock = cardViewController.notificationCenter as? NotificationCenterMock {
            XCTAssertEqual(notificationCenterMock.handlers.count, 2)
            XCTAssertEqual(notificationCenterMock.handlers[0].name, NSNotification.Name.UIKeyboardWillShow)
            XCTAssertEqual(notificationCenterMock.handlers[1].name, NSNotification.Name.UIKeyboardWillHide)
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
        let notification = NSNotification(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo: [
            UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
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
        let notification = NSNotification(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo: [
            UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
            ])
        cardVC?.keyboardWillHide(notification: notification)
        XCTAssertEqual(cardVC?.kbHideCalledTimes, 1)
        XCTAssertEqual(cardVC?.kbHideLastCalledWith?.0, notification)
        XCTAssertEqual(cardVC?.kbHideLastCalledWith?.1, cardVC?.cardView.scrollView)
    }

    func testValidateFieldsWithRequiredBillingDetailsMissing() {
        // Setup
        let cardViewController = CardViewController(cardHolderNameState: .hidden, billingDetailsState: .required)
        cardViewController.viewDidLoad()
        XCTAssertFalse((cardViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
        // Simulate the end of a text field editing
        cardViewController.textFieldDidEndEditing(cardViewController.cardView.cvvInputView.textField)
        // Assert
        XCTAssertFalse((cardViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
    }

    func testValidateFieldsWithRequiredNameMissing() {
        // Setup
        let cardViewController = CardViewController(cardHolderNameState: .required, billingDetailsState: .hidden)
        cardViewController.viewDidLoad()
        XCTAssertFalse((cardViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
        // Simulate the end of a text field editing
        cardViewController.textFieldDidEndEditing(cardViewController.cardView.cvvInputView.textField)
        // Assert
        XCTAssertFalse((cardViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
    }

    func testValidateFields() {
        // Setup
        let cardViewController = CardViewController(cardHolderNameState: .hidden, billingDetailsState: .hidden)
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
        let cardViewController = CardViewController(cardHolderNameState: .hidden, billingDetailsState: .hidden)
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

    func testCalledDelegateMethodWhenTapDoneIfDataValid() {
        // Setup
        cardViewController.viewDidLoad()
        cardViewController.cardView.cardNumberInputView.textField.text = "4242 4242 4242 4242"
        cardViewController.cardView.expirationDateInputView.textField.text = "06/2020"
        cardViewController.cardView.cvvInputView.textField.text = "100"
        // Execute
        cardViewController.delegate = cardViewControllerDelegate
        cardViewController.onTapDoneCardButton()
        // Assert
        XCTAssertEqual(cardViewControllerDelegate.calledTimes, 1)
        XCTAssertEqual(cardViewControllerDelegate.lastCalledWith?.number, "4242424242424242")
        XCTAssertEqual(cardViewControllerDelegate.lastCalledWith?.expiryMonth, "06")
        XCTAssertEqual(cardViewControllerDelegate.lastCalledWith?.expiryYear, "20")
        XCTAssertEqual(cardViewControllerDelegate.lastCalledWith?.cvv, "100")
    }

    func testPushAddressViewControllerOnTapAddress() {
        cardViewController = CardViewController()
        cardViewControllerDelegate = CardViewControllerMockDelegate()
        let navigation = MockNavigationController()
        navigation.viewControllers = [cardViewController]
        cardViewController.onTapAddressView()
        XCTAssertTrue(navigation.pushedViewController is AddressViewController)
    }

    func testOnTapDoneButtonAddress() {
        let address = CkoAddress(name: "Pierre Paul", addressLine1: "12 rue de la boulangerie",
                                 addressLine2: nil, city: "Lyon", state: nil, postcode: "69002",
                                 country: "FR", phone: nil)
        cardViewController.onTapDoneButton(address: address)
        XCTAssertFalse((cardViewController.cardView.billingDetailsInputView.value.text?.isEmpty)!)
    }

    func testChangeCvvCardTypeOnCardNumberEndEditing() {
        cardViewController.cardView.cardNumberInputView.textField.text = "4242 4242 4242 4242"
        cardViewController.textFieldDidEndEditing(view: cardViewController.cardView.cardNumberInputView)
        let visaType = CardUtils().getCardType(scheme: .visa)
        XCTAssertEqual(cardViewController.cardView.cvvInputView.cardType, visaType)
    }

    func testSetImageHighlightedOnChangeCardType() {
        cardViewController.availableSchemes = [.visa, .mastercard, .discover, .dinersClub]
        cardViewController.cardView.schemeIconsStackView.setIcons(schemes: cardViewController.availableSchemes)
        cardViewController.onChangeCardNumber(cardType: CardUtils().getCardType(scheme: .visa))
        let nFadedCard = cardViewController.cardView.schemeIconsStackView.arrangedSubviews
            .filter { $0.alpha == 0.5}.count
        XCTAssertEqual(nFadedCard, 4)
    }

    func testChangeImageHighlightedOChangeCardType() {
        testSetImageHighlightedOnChangeCardType()
        cardViewController.onChangeCardNumber(cardType: CardUtils().getCardType(scheme: .mastercard))
        let nFadedCard = cardViewController.cardView.schemeIconsStackView.arrangedSubviews
            .filter { $0.alpha == 0.5}.count
        XCTAssertEqual(nFadedCard, 4)
    }

    func testResetViewOnChangeIfCardNumberUnknownType() {
        testSetImageHighlightedOnChangeCardType()
        cardViewController.onChangeCardNumber(cardType: nil)
        let nFadedCard = cardViewController.cardView.schemeIconsStackView.arrangedSubviews
            .filter { $0.alpha == 0.5}.count
        XCTAssertEqual(nFadedCard, 0)
    }

}
