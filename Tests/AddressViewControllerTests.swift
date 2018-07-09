import XCTest
@testable import FramesIos

class AddressViewControllerTests: XCTestCase {

    var addressViewController: AddressViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        addressViewController = AddressViewController()
        let navigation = UINavigationController()
        navigation.viewControllers = [addressViewController]
    }

    func setupAddress() {
        addressViewController.addressView.nameInputView.textField.text = "Pierre Paul"
        addressViewController.addressView.phoneInputView.textField.text = "+33 6 22 54 56 88"
        addressViewController.regionCodeSelected = "FR"
        addressViewController.addressView.addressLine1InputView.textField.text = "12 rue de la boulangerie"
        addressViewController.addressView.cityInputView.textField.text = "Lyon"
        addressViewController.addressView.zipInputView.textField.text = "69002"
    }

    func testInitialization() {
        let addressViewController = AddressViewController()
        addressViewController.viewDidLoad()
        addressViewController.viewDidLayoutSubviews()
        XCTAssertEqual(addressViewController.navigationItem.rightBarButtonItem?.isEnabled, false)
        XCTAssertEqual(addressViewController.view.subviews.count, 1)
    }

    func testAddHandlersInViewWillAppear() {
        addressViewController.notificationCenter = NotificationCenterMock()
        addressViewController.viewWillAppear(true)
        if let notificationCenterMock = addressViewController.notificationCenter as? NotificationCenterMock {
            XCTAssertEqual(notificationCenterMock.handlers.count, 2)
            XCTAssertEqual(notificationCenterMock.handlers[0].name, NSNotification.Name.UIKeyboardWillShow)
            XCTAssertEqual(notificationCenterMock.handlers[1].name, NSNotification.Name.UIKeyboardWillHide)
        } else {
            XCTFail("Notification center is not a mock")
        }
    }

    func testRemoveHandlersInViewWillDisappear() {
        addressViewController.notificationCenter = NotificationCenterMock()
        // Add the handlers
        testAddHandlersInViewWillAppear()
        // Remove the handlers
        addressViewController.viewWillDisappear(true)
        if let notificationCenterMock = addressViewController.notificationCenter as? NotificationCenterMock {
            XCTAssertEqual(notificationCenterMock.handlers.count, 0)
        } else {
            XCTFail("Notification center is not a mock")
        }
    }

    func testScrollViewOnKeyboardWillShow() {
        addressViewController.viewDidLoad()
        let notification = NSNotification(name: NSNotification.Name.UIKeyboardWillShow, object: nil, userInfo: [
                UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
            ])

        addressViewController
            .scrollViewOnKeyboardWillShow(notification: notification,
                                          scrollView: addressViewController.addressView.scrollView,
                                          activeField: addressViewController.addressView.phoneInputView.textField)
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 380, right: 0.0)
        XCTAssertEqual(addressViewController.addressView.scrollView.contentInset, contentInsets)
    }

    func testScrollViewOnKeyboardWillHide() {
        addressViewController.viewDidLoad()
        testScrollViewOnKeyboardWillShow()
        let notification = NSNotification(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo: [
            UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
            ])
        addressViewController.scrollViewOnKeyboardWillHide(notification: notification,
                                                           scrollView: addressViewController.addressView.scrollView)
        let contentInsets = UIEdgeInsets.zero
        XCTAssertEqual(addressViewController.addressView.scrollView.contentInset, contentInsets)
    }

    func testKeyboardWillShow() {
        /// Mock Address View Controller
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let addressVC = AddressViewControllerMock(coder: coder)
        addressVC?.viewDidLoad()
        let notification = NSNotification(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo: [
            UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
            ])
        addressVC?.keyboardWillShow(notification: notification)
        XCTAssertEqual(addressVC?.kbShowCalledTimes, 1)
        XCTAssertEqual(addressVC?.kbShowLastCalledWith?.0, notification)
        XCTAssertEqual(addressVC?.kbShowLastCalledWith?.1, addressVC?.addressView.scrollView)
    }

    func testKeyboardWillHide() {
        /// Mock Address View Controller
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let addressVC = AddressViewControllerMock(coder: coder)
        addressVC?.viewDidLoad()
        let notification = NSNotification(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo: [
            UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
            ])
        addressVC?.keyboardWillHide(notification: notification)
        XCTAssertEqual(addressVC?.kbHideCalledTimes, 1)
        XCTAssertEqual(addressVC?.kbHideLastCalledWith?.0, notification)
        XCTAssertEqual(addressVC?.kbHideLastCalledWith?.1, addressVC?.addressView.scrollView)
    }

    func testDisableDoneButtonIfFormNotValid() {
        addressViewController.viewDidLoad()
        addressViewController.textFieldDidEndEditing(UITextField())
        XCTAssertFalse((addressViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
    }

    func testDisableDoneButtonIfFormNotValidEmpty() {
        addressViewController.viewDidLoad()
        addressViewController.regionCodeSelected = "FR"
        addressViewController.textFieldDidEndEditing(UITextField())
        XCTAssertFalse((addressViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
    }

    func testEnableDoneButtonIfFormIsValid() {
        // Setup
        addressViewController.viewDidLoad()
        setupAddress()
        // Assert
        addressViewController.textFieldDidEndEditing(UITextField())
        XCTAssertTrue((addressViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
    }

    func testCallDelegateMethodOnTapDoneButton() {
        let delegate = AddressViewControllerMockDelegate()
        addressViewController.viewDidLoad()
        addressViewController.delegate = delegate
        setupAddress()
        _ = addressViewController.addressView.phoneInputView.isValidNumber
        addressViewController.onTapDoneButton()
        XCTAssertEqual(delegate.onTapDoneButtonCalledTimes, 1)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWith?.addressLine1, "12 rue de la boulangerie")
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWith?.city, "Lyon")
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWith?.country, "FR")
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWith?.postcode, "69002")
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWith?.phone?.countryCode, "33")
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWith?.phone?.number, "622545688")
    }

    func testSetCountryOnCountrySelected() {
        addressViewController.onCountrySelected(country: "France", regionCode: "FR")
        XCTAssertEqual(addressViewController.regionCodeSelected, "FR")
        XCTAssertEqual(addressViewController.addressView.countryRegionInputView.value.text, "France")
    }

    func testPushCountrySelectionViewControllerOnTapCountryRegion() {
        let navigation = MockNavigationController()
        let addressViewController = AddressViewController()
        navigation.viewControllers = [addressViewController]
        addressViewController.onTapCountryRegionView()
        XCTAssertTrue(navigation.pushedViewController is CountrySelectionViewController)
    }

}
